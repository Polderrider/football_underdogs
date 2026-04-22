from pathlib import Path
import pandas as pd
from mappings import map_team_names

REQUIRED_COLUMNS = [
    "Date",
    "HomeTeam",
    "AwayTeam",
    "FTHG",
    "FTAG",
    "FTR",
    "B365H",
    "B365D",
    "B365A",
]

COLUMN_MAP = {
    "Date": "match_date",
    "HomeTeam": "home_team_raw",
    "AwayTeam": "away_team_raw",
    "FTHG": "home_goals",
    "FTAG": "away_goals",
    "FTR": "result",
    "B365H": "b365_home",
    "B365D": "b365_draw",
    "B365A": "b365_away",
}


# ── Helpers ───────────────────────────────────────────────────────────────────

def read_csv(path: str | Path) -> pd.DataFrame:
    return pd.read_csv(path, encoding="latin-1")

    """ TPDO Football-data csv sometimes latin-1 (not UTF-8), which cause crash """

def select_columns(df: pd.DataFrame) -> pd.DataFrame:

    if df.empty:       
        raise ValueError("csv is empty")
    
    missing = [col for col in REQUIRED_COLUMNS if col not in df.columns]
    if missing:
        raise ValueError(f"Missing required columns: {missing}")
    
    return df[REQUIRED_COLUMNS].copy()  # use .copy() to avoid pandas chained-assignment issues later

def rename_columns(df: pd.DataFrame) -> pd.DataFrame:
    return df.rename(columns=COLUMN_MAP)

def clean_types(df: pd.DataFrame) -> pd.DataFrame:
    df["home_team_raw"] = df["home_team_raw"].astype(str).str.strip()
    df["away_team_raw"] = df["away_team_raw"].astype(str).str.strip()

    # dates
    df["match_date"] = pd.to_datetime(
        df["match_date"],
        dayfirst=True,
        errors="coerce",
    )
    # log bad dates
    bad_dates = df["match_date"].isna().sum()
    if bad_dates:
        print(f"[WARNING] {bad_dates} rows with unparseable dates")

    # goals
    df["home_goals"] = pd.to_numeric(df["home_goals"], errors="coerce").astype("Int64")
    df["away_goals"] = pd.to_numeric(df["away_goals"], errors="coerce").astype("Int64")

    # betting odds
    for col in ["b365_home", "b365_draw", "b365_away"]:
        df[col] = pd.to_numeric(df[col], errors="coerce")

    df["result"] = df["result"].astype(str).str.strip().str.upper()

    return df

def drop_bad_rows(df: pd.DataFrame) -> pd.DataFrame:
    
    
    df = df.dropna(subset=[
        "match_date",
        "home_team_raw",
        "away_team_raw",
        "home_goals",
        "away_goals",
        "result",
        "b365_home",
        "b365_draw",
        "b365_away",
    ])

    df = df[df["home_team_raw"] != ""]
    df = df[df["away_team_raw"] != ""]
    df = df[df["result"].isin(["H", "D", "A"])]

    # Goals can't be negative
    df = df[(df["home_goals"] >= 0) & (df["away_goals"] >= 0)]

    # Odds must be >= 1.0 (implied probability <= 100%)
    for col in ["b365_home", "b365_draw", "b365_away"]:
        df = df[df[col] >= 1.0]

    # Note: '~' is bitwise NOT on a boolean
    # rows to be dropped
    corrupted = (
        ((df["result"] == "H") & (df["home_goals"] <= df["away_goals"])) |
        ((df["result"] == "A") & (df["away_goals"] <= df["home_goals"])) |
        ((df["result"] == "D") & (df["home_goals"] != df["away_goals"]))
    )
    # SNIPPETS ~ bitwise NOT operator
    # Keep only rows that are NOT ~ corrupted
    df = df[~corrupted]

    return df

def add_metadata(df: pd.DataFrame, season: str, league: str) -> pd.DataFrame:
    """ 
     important because the file name carries meaning 
     Improvement: parse "2223" and "E0" from the filename rather than manually pass """
    
    df["season"] = season
    df["league"] = league
    return df


# ── Main Cleaning ───────────────────────────────────────────────────────────


# add_metadata is called before drop_bad_rows, which means dropped rows briefly carry metadata. 
# logically makes more sense to add metadata last, after the data is known-good:


def clean_match_file(path: str | Path, season: str, league: str) -> pd.DataFrame:
    raw_df = read_csv(path)
    df = select_columns(raw_df)
    df = rename_columns(df)
    df = clean_types(df)
    df = drop_bad_rows(df)
    df = map_team_names(df)
    print(df["home_team_raw"].unique())   # what raw names exist
    
    print(f"{df}")
    df = add_metadata(df, season, league)
    return raw_df, df

""" 
TODO
        encoding handling 
        odds range validation
        goals sanity check
        result/scoreline consistency check
        
 """


# ── Entry point ───────────────────────────────────────────────────────────────

if __name__ == "__main__":
   
   pass 
    # pipeline_clean.py.clean_matchfile() called in pipeline_load.py

    # raw_df, df = clean_match_file("data/2324_E0.csv", season="2324", league="E0")
    # print(df.head())
    # print(df.dtypes)
    # print(f"Raw Rows loaded: {len(raw_df)}")
    # print(f"Clean Rows loaded: {len(df)}")
    # dropped = len(raw_df) - len(df)
    # print(f"Dropped Rows: {dropped}")
