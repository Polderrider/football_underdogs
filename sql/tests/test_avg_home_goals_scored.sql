

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

-- insert match data
INSERT INTO matches_test (
    id, league, season, match_date, home_team, away_team, home_goals, away_goals, result, b365_home, b365_draw, b365_away
) VALUES
(1, 'EO', '2223', '2022-01-10', 'TEAMA', 'TEAMB', 3, 0, 'H', 5.2, 2.4, 1.0),          -- 
(2, 'EO', '2223', '2022-01-10', 'TEAMA', 'TEAMD', 3, 3, 'D', 5.2, 2.4, 1.0),          -- result home underdog loss
(3, 'EO', '2223', '2022-01-10', 'TEAMA', 'TEAMF', 3, 2, 'H', 1.2, 2.4, 5.0),         -- result away underdog wins
(4, 'EO', '2223', '2022-01-10', 'TEAMX', 'TEAMB', 0, 0, 'D', 5.2, 2.4, 1.0),          -- 
(5, 'EO', '2223', '2022-01-10', 'TEAMX', 'TEAMD', 1, 3, 'A', 5.2, 2.4, 1.0),          -- result home underdog loss
(6, 'EO', '2223', '2022-01-10', 'TEAMX', 'TEAMF', 2, 2, 'D', 1.2, 2.4, 5.0);         -- result away underdog wins

-- Expected result
-- Team A - 3 home games, total home goals 9, avg_home_goals = 3
-- Team X - 3 home games, total home goals 3, avg = 1

-- query with test data
SELECT
    season,
    home_team,
    COUNT(*) AS matches_played_at_home,
    ROUND(
        AVG(home_goals),
        1
    ) AS avg_home_goals

FROM matches_test
WHERE season = '2223'
GROUP BY season, home_team
ORDER BY avg_home_goals DESC;


-- test output

-- season  home_team  matches_played_at_home  avg_home_goals
-- ------  ---------  ----------------------  --------------
-- 2223    TEAMA      3                       3.0           
-- 2223    TEAMX      3                       1.0    