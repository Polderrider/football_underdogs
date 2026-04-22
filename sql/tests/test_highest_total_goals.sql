


-- create test data
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
(1, 'EO', '2223', '2022-01-10', 'A', 'B', 2, 0, 'H', 5.2, 2.4, 1.0),          -- result home underdog wins
(2, 'EO', '2223', '2022-01-10', 'A', 'C', 0, 3, 'A', 5.2, 2.4, 1.0),          -- result home underdog loss
(3, 'EO', '2223', '2022-01-10', 'B', 'D', 1, 2, 'A', 1.2, 2.4, 5.0),          -- result away underdog wins
(4, 'EO', '2223', '2022-01-10', 'D', 'C', 4, 1, 'H', 1.2, 2.4, 5.0),          -- result away underdog loss
(5, 'EO', '2223', '2022-01-10', 'A', 'D', 5, 5, 'D', 1.2, 2.4, 1.2);          -- result draw & no underdog(equal odds)
-- total goals in 5 matches = 23
-- team A goals = 2,0,5 = 7
-- team B goals = 0,1 = 1
-- team C goals = 3,1 = 4
-- team D goals = 2,4,5 = 11

-- query test data
SELECT
    season,
    match_date,
    home_team,
    away_team,
    home_goals,
    away_goals,
    (home_goals + away_goals) AS match_goals 

FROM matches_test
ORDER BY match_goals DESC       
LIMIT 10;

-- EXPECTED OUTCOME
-- season  match_date  home_team  away_team  home_goals  away_goals  match_goals
-- ------  ----------  ---------  ---------  ----------  ----------  -----------
-- 2223    2022-01-10  A          D          5           5           10         
-- 2223    2022-01-10  D          C          4           1           5          
-- 2223    2022-01-10  A          C          0           3           3          
-- 2223    2022-01-10  B          D          1           2           3          
-- 2223    2022-01-10  A          B          2           0           2  
   




