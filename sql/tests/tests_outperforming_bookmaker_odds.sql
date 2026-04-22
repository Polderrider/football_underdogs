
-- run in football_underdogs/
-- sqlite3 -header -column football_pipeline.db < sql/tests/tests_outperforming_bookmaker_odds.sql
-- test data: 2223 season, team A has 2 underdog wins and plays 4 underdog matches. underdog winrate = 50%

-- create test table
DROP TABLE IF EXISTS matches_test;

CREATE TABLE matches_test (
    id INTEGER PRIMARY KEY,
    league TEXT,
    season TEXT,
    match_date TEXT,
    home_team TEXT,
    away_team TEXT,
    home_goals INTEGER,
    away_goals INTEGER,
    result TEXT,
    b365_home REAL,
    b365_draw REAL,
    b365_away REAL
);

-- dummy data
INSERT INTO matches_test (
    id, league, season, match_date, home_team, away_team, home_goals, away_goals, result, b365_home, b365_draw, b365_away
) VALUES
(1, 'EO', '2223', '2022-01-10', 'A', 'B', 2, 0, 'H', 5.2, 2.4, 1.0),    -- A underdog home wins  
(2, 'EO', '2223', '2022-01-10', 'C', 'A', 0, 3, 'A', 1.2, 2.4, 5.0),    -- underdog away wins
(3, 'EO', '2223', '2022-01-10', 'A', 'F', 0, 2, 'A', 5.2, 2.4, 1.0),    -- underdog home loses
(4, 'EO', '2223', '2022-01-10', 'G', 'A', 4, 1, 'H', 1.2, 2.4, 5.0),    -- underdog away loses      
(5, 'EO', '2223', '2022-01-10', 'X', 'Y', 5, 5, 'D', 1.2, 2.4, 1.2);    -- equal odds


-- query using test data
WITH underdog_stats AS (
    SELECT 
        season,
        home_team AS team,
        SUM(CASE WHEN b365_home > b365_away THEN 1 ELSE 0 END) AS underdog_match_count,
        SUM(CASE WHEN b365_home > b365_away AND result = 'H' THEN 1 ELSE 0 END) AS underdog_win_count
        FROM matches_test
        GROUP BY season, team

    UNION ALL

    SELECT 
        season,
        away_team AS team,
        SUM(CASE WHEN b365_away > b365_home THEN 1 ELSE 0 END) AS underdog_match_count,
        SUM(CASE WHEN b365_away > b365_home AND result = 'A' THEN 1 ELSE 0 END) AS underdog_win_count
    FROM matches_test
    GROUP BY season, team
   
)
SELECT
    season,
    team,
    SUM(underdog_match_count) AS underdog_match_count,
    SUM(underdog_win_count) AS underdog_win_count,
    ROUND(
        100.0 * SUM(underdog_win_count) / SUM(underdog_match_count),
        1
    ) AS underdog_win_rate
FROM underdog_stats
WHERE season = 2223
GROUP BY season, team 
ORDER BY underdog_win_rate DESC;


-- EXPECTED OUTCOME

-- season  team  underdog_match_count  underdog_win_count  underdog_win_rate
-- ------  ----  --------------------  ------------------  -----------------
-- 2223    A     4                     2                   50.0             
-- 2223    B     0                     0                                    
-- 2223    C     0                     0                                    
-- 2223    F     0                     0                                    
-- 2223    G     0                     0                                    
-- 2223    X     0                     0                                    
-- 2223    Y     0                     0   

  