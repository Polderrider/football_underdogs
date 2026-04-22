-- Q14
-- For each season, count how many matches were:
                -- home win
                -- away win
                -- draw

-- Return one row per season.

--          home_win    away_win    draw
-- 2223
-- 2324

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
(1, 'EO', '2223', '2022-01-10', 'TEAMA', 'TEAMB', 0, 1, 'A', 1.2, 2.4, 5.0),          -- result favourite did not win
(2, 'EO', '2223', '2022-01-10', 'TEAMA', 'TEAMC', 3, 2, 'H', 1.2, 2.4, 5.0),          -- result favourite did win 
(3, 'EO', '2324', '2022-01-10', 'TEAMX', 'TEAMZ', 0, 1, 'A', 1.6, 2.4, 4.0),          -- result favourite did not win
(4, 'EO', '2324', '2022-01-10', 'TEAMX', 'TEAMY', 3, 2, 'H', 1.6, 2.4, 4.0),         -- result favourite did win 
(5, 'EO', '2324', '2022-01-10', 'TEAMX', 'TEAMY', 3, 3, 'D', 1.6, 2.4, 4.0);          -- result favourite did win 

--          home_win    away_win    draw
-- 2223     1           1           0
-- 2324     1           1           1


