from datetime import datetime, UTC
import sqlite3
import pandas as pd

from db import get_connection, create_tables
from pipeline_clean import clean_match_file
from mappings import calculate_mapping_coverage


def utc_now_iso() -> str:
    return datetime.now(UTC).isoformat()


def log_run_start(conn: sqlite3.Connection) -> int:
    cursor = conn.cursor()
    cursor.execute("""
        INSERT INTO pipeline_runs (started_at, status)
        VALUES (?, ?)
    """, (utc_now_iso(), "RUNNING"))
    return cursor.lastrowid


def log_run_success(
    conn: sqlite3.Connection,
    run_id: int,
    rows_processed: int,
    mapping_coverage: float | None = None,
) -> None:
    cursor = conn.cursor()
    cursor.execute("""
        UPDATE pipeline_runs
        SET finished_at = ?,
            status = ?,
            rows_processed = ?,
            mapping_coverage = ?
        WHERE run_id = ?
    """, (
        utc_now_iso(),
        "SUCCESS",
        rows_processed,
        mapping_coverage,
        run_id,
    ))


def log_run_failure(
    conn: sqlite3.Connection,
    run_id: int,
    error_message: str,
) -> None:
    cursor = conn.cursor()
    cursor.execute("""
        UPDATE pipeline_runs
        SET finished_at = ?,
            status = ?,
            error_message = ?
        WHERE run_id = ?
    """, (
        utc_now_iso(),
        "FAILED",
        error_message,
        run_id,
    ))


def load_matches(conn: sqlite3.Connection, df) -> int:
    cursor = conn.cursor()
    rows = []
    ingested_at = utc_now_iso()
    

    # SNIPPETS df.iterrows() versus df.itertuples() => itertuples() is significantly faster than iterrows() and attribute access is cleaner.
    # when usign itertuples(), ensure dot notation is used with row eg row.league; not row["league"] which is dict access for when using .iterrows()
    # for _, row in df.iterrows():
    for row in df.itertuples():
        rows.append((
            row.league,
            row.season,
            row.match_date.date().isoformat(),
            row.home_team_raw,
            row.away_team_raw,
            row.home_team,
            row.away_team,
            None if pd.isna(row.home_goals) else int(row.home_goals),  # pandas.isna() used to catch vlaeu NaN, pd.Na, values != None
            None if pd.isna(row.away_goals) else int(row.away_goals),
            row.result,
            None if pd.isna(row.b365_home)  else float(row.b365_home),
            None if pd.isna(row.b365_draw)  else float(row.b365_draw),
            None if pd.isna(row.b365_away)  else float(row.b365_away),
            ingested_at,
        ))

    before_row_count = conn.execute("SELECT COUNT(*) FROM matches").fetchone()[0]
    cursor.executemany("""
        INSERT OR IGNORE INTO matches (
            league,
            season,
            match_date,
            home_team_raw,
            away_team_raw,
            home_team,
            away_team,
            home_goals,
            away_goals,
            result,
            b365_home,
            b365_draw,
            b365_away,
            ingested_at
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, rows)
    after_row_count = conn.execute("SELECT COUNT(*) FROM matches").fetchone()[0]

    # SNIPPET print debug sql script - count rows
    # count = conn.execute("SELECT COUNT(*) FROM matches").fetchone()[0]
    # print(f"matches in db: {count}")

    attempted = len(rows)
    inserted = after_row_count - before_row_count
    skipped = attempted - inserted

    print(f"Rows loaded into db: Attempted: {attempted} | Inserted: {inserted} | Skipped (duplicates): {skipped}")

    return inserted


def run_load(
    file_path: str,
    season: str,
    league: str,
    mapping_coverage: float | None = None,
) -> None:
    create_tables()

    # return cleaned df
    raw_df, df = clean_match_file(file_path, season=season, league=league)      # TODO refactor - investigate clean_match_file() in pipeline_fetch.py. unnecessary for raw_df to be returned.
    
    # check team name mapping >95% coverage
    coverage = calculate_mapping_coverage(df)
    if coverage < 0.95:
        print(f"WARNING: mapping coverage low: {coverage:.2%}")
        # print(df["home_team"].isna().sum())   # how many failed to map
        print(f"Team name mapping failures: {df[df["home_team"].isna()][["home_team_raw"]].drop_duplicates()}")  # which ones failed
    else:
        print(f"Team name mapping coverage: {coverage:.2%}")
    conn = get_connection()
    run_id = None

    try:
        run_id = log_run_start(conn)            # primary key for pipeline_runs table taken from last row loaded

        inserted_rows = load_matches(conn, df)
        log_run_success(
            conn=conn,
            run_id=run_id,
            rows_processed=inserted_rows,
            mapping_coverage=mapping_coverage,
        )

        conn.commit()
        print(f"Load completed. Inserted {inserted_rows} new rows.")

    except Exception as exc:
        conn.rollback()

        # Need a fresh connection if the previous transaction rolled back
        if run_id is not None:
            fail_conn = get_connection()
            try:
                log_run_failure(fail_conn, run_id, str(exc))
                fail_conn.commit()
            finally:
                fail_conn.close()

        print(f"Load failed: {exc}")
        raise

    finally:
        conn.close()


if __name__ == "__main__":
    run_load(
        file_path="data/2425_E0.csv",
        season="2425",
        league="E0",
        mapping_coverage=None,
    )