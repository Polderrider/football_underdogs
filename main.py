from fastapi import FastAPI
import sqlite3

app = FastAPI()

def get_connection():

    conn = sqlite3.connect("football_pipeline.db")
    conn.row_factory = sqlite3.Row
    return conn


@app.get("/kpi/underdog-win-rate")
def underdog_win_rate():

    
    conn = get_connection()

    try:

        # calculates underdog win rate. underdog is a team with betting odds are worse (higher) than opponent.
        row = conn.execute("""
            SELECT
                COUNT(*) AS total_matches,
                SUM(
                    CASE
                        WHEN b365_home > b365_away AND result = 'H' THEN 1
                        WHEN b365_away > b365_home AND result = 'A' THEN 1
                        ELSE 0
                    END
                ) AS underdog_wins
                FROM matches
                WHERE b365_home IS NOT NULL
                 AND b365_away IS NOT NULL
                 AND b365_home != b365_away
        """).fetchone()
        
        total = row["total_matches"] or 0
        wins = row["underdog_wins"] or 0
        rate = wins / total if total else 0.0
                        
        return {
            "kpi": "underdog_win_rate",
            "total_matches": total,
            "underdog_wins": wins,
            "underdog_win_rate": round(rate, 4),
        }
     
       
    finally:
        conn.close()

