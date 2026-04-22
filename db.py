from pathlib import Path
import sqlite3          # SQLite is built into Python 3, so no pip install is necessary to start using it. Simply import sqlite3

DB_PATH = Path("football_pipeline.db")


def get_connection() -> sqlite3.Connection:
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def create_tables() -> None:
    conn = get_connection()

    try:
        cursor = conn.cursor()

        cursor.execute("""
            CREATE TABLE IF NOT EXISTS matches (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                league TEXT NOT NULL,
                season TEXT NOT NULL,
                match_date TEXT NOT NULL,
                home_team_raw TEXT NOT NULL,
                away_team_raw TEXT NOT NULL,
                home_team TEXT NULL,
                away_team TEXT NULL,
                home_goals INTEGER,
                away_goals INTEGER,
                result TEXT,
                b365_home REAL,
                b365_draw REAL,
                b365_away REAL,  
                ingested_at TEXT NOT NULL,
                UNIQUE (league, season, match_date, home_team_raw, away_team_raw)
            )
        """)

        cursor.execute("""
            CREATE TABLE IF NOT EXISTS pipeline_runs (
                run_id INTEGER PRIMARY KEY AUTOINCREMENT,
                started_at TEXT NOT NULL,
                finished_at TEXT,
                status TEXT NOT NULL,
                rows_processed INTEGER,
                mapping_coverage REAL,
                error_message TEXT
            )
        """)

        conn.commit()
    finally:
        conn.close()


if __name__ == "__main__":
    create_tables()
    print(f"Database initialized at: {DB_PATH}")