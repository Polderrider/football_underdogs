
-- remove test table if already exists
DROP TABLE IF EXISTS matches_test;


-- create test table + data types
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

-- insert match data
INSERT INTO matches_test (
    id, league, season, match_date, home_team, away_team, home_goals, away_goals, result, b365_home, b365_draw, b365_away
) VALUES
(1, 'EO', '2223', '2022-01-10', 'TEAMA', 'TEAMD', 2, 0, 'H', 1.2, 2.4, 5.0),          -- result home team goals for 1
(2, 'EO', '2223', '2022-01-10', 'TEAMC', 'TEAMA', 1, 0, 'A', 1.2, 2.4, 5.0),          -- result favourite did win 
(3, 'EO', '2223', '2022-01-10', 'TEAMB', 'TEAMZ', 3, 0, 'H', 1.6, 2.4, 4.0),          -- result favourite did not win
(4, 'EO', '2223', '2022-01-10', 'TEAMX', 'TEAMB', 0, 0, 'D', 1.6, 2.4, 4.0),         -- result favourite did win 
(5, 'EO', '2223', '2022-01-10', 'TEAMX', 'TEAMC', 0, 0, 'A', 1.6, 2.4, 4.0);          -- result favourite did win 



WITH goal_stats AS (    
    SELECT
        season,
        home_team AS team,
        COUNT(*) AS matches_played,
        SUM(home_goals) AS goals_for,
        SUM(away_goals) AS goals_against
    FROM matches_test
    GROUP BY season, home_team

    UNION ALL

    SELECT
       season,
        away_team AS team,
        COUNT(*) AS matches_played,
        SUM(away_goals) AS goals_for,
        SUM(home_goals) AS goals_against
    FROM matches_test
    GROUP BY season, away_team
)
SELECT
    season,
    team,
    SUM(matches_played) AS matches,
    SUM(goals_for) AS goals_for,
    SUM(goals_against) AS goals_against,
    SUM(goals_for) - SUM(goals_against) AS goal_difference   
    
FROM goal_stats
WHERE season = '2223'
GROUP BY season, team
ORDER BY goal_difference DESC;


-- test query output

-- season  team   matches  goals_for  goals_against  goal_difference
-- ------  -----  -------  ---------  -------------  ---------------
-- 2223    TEAMB  2        3          0              3              
-- 2223    TEAMA  2        2          1              1              
-- 2223    TEAMC  2        1          0              1              
-- 2223    TEAMX  2        0          0              0              
-- 2223    TEAMD  1        0          2              -2             
-- 2223    TEAMZ  1        0          3              -3  