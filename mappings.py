# football_underdogs/mappings.py

import pandas as pd

# Canonical mapping dictionary
TEAM_NAME_MAP = {
    "Man United": "Manchester United",
    "Man U": "Manchester United",
    "Man Utd": "Manchester United",
    "Man City": "Manchester City",
    "Manchester City": "Manchester City",
    "Wolves": "Wolverhampton Wanderers",
    "Wolverhampton": "Wolverhampton Wanderers",
    "Newcastle": "Newcastle United",
    "Newcastle United": "Newcastle United",
    "Crystal Palace": "Crystal Palace",
    "Palace": "Crystal Palace",
    "Bournemouth": "Bournemouth",
    "Everton": "Everton",
    "Fulham": "Fulham",
    "Tottenham": "Tottenham Hotspur",
    "Tottenham Hotspur": "Tottenham Hotspur",
    "Spurs": "Tottenham Hotspur",
    "Leeds": "Leeds United",
    "Leeds United": "Leeds United",
    "Arsenal": "Arsenal",
    "West Ham United": "West Ham United",
    "West Ham": "West Ham United",
    "Nottingham Forest": "Nottingham Forest",
    "Forest": "Nottingham Forest",
    "Nott'm Forest": "Nottingham Forest",
    "Liverpool": "Liverpool",
    "Villa": "Aston Villa",
    "Aston Villa": "Aston Villa",
    "Brentford": "Brentford FC",
    "Brentford FC": "Brentford FC",
    "Brighton": "Brighton",
    "Chelsea": "Chelsea",
    "Burnley": "Burnley",
    "Leicester": "Leicester City",
    "Southampton": "Southampton FC",
    "Sheffield United": "Sheffield United",
    "Luton": "Luton",

}


def map_team_names(df: pd.DataFrame) -> pd.DataFrame:
    """
    Adds canonical team names:
    - home_team
    - away_team
    """

    df["home_team"] = df["home_team_raw"].map(TEAM_NAME_MAP)        
    df["away_team"] = df["away_team_raw"].map(TEAM_NAME_MAP)

    return df


def calculate_mapping_coverage(df: pd.DataFrame) -> float:
    """
    % of team names successfully mapped
    """

    total = len(df) * 2  # home + away

    mapped = (
        df["home_team"].notna().sum() +
        df["away_team"].notna().sum()
    )

    return mapped / total if total > 0 else 0.0


def get_unmapped_teams(df: pd.DataFrame) -> set:
    unmapped_home = df[df["home_team"].isna()]["home_team_raw"]
    unmapped_away = df[df["away_team"].isna()]["away_team_raw"]

    return set(unmapped_home).union(set(unmapped_away))