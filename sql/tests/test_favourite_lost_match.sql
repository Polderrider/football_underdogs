
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
(3, 'EO', '2223', '2022-01-10', 'TEAMX', 'TEAMZ', 0, 1, 'H', 1.6, 2.4, 4.0),          -- result favourite did not win
(4, 'EO', '2223', '2022-01-10', 'TEAMX', 'TEAMY', 3, 2, 'H', 4.0, 2.4, 1.6);          -- result favourite did win 

-- match 1: A home team is favourite, lost match
-- match 4: Y away team is favourite, lost match

-- query with test data
WITH fav AS (
    SELECT
        season,
        match_date,
        home_team,
        away_team,
        result,
        CASE
            WHEN b365_home < b365_away THEN 'H'
            WHEN b365_away < b365_home THEN 'A'
            ELSE NULL
        END AS favourite_side
    FROM matches_test
)
SELECT
    season,
    match_date,
    home_team,
    away_team,
    result,         -- 'H'= home win, 'A'=away win
    favourite_side
FROM fav
WHERE favourite_side IS NOT NULL
  AND favourite_side != result;

-- EXPECTED OUTCOME

-- season  match_date  home_team  away_team  result  favourite_side
-- ------  ----------  ---------  ---------  ------  --------------
-- 2223    2022-01-10  TEAMA      TEAMB      A       H             
-- 2223    2022-01-10  TEAMX      TEAMY      H       A   
