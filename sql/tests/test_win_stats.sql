
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

-- add dummy data
-- each season has 1 W, 1 D, 1 L. total 3 games.

INSERT INTO matches_test (
    id, league, season, match_date, home_team, away_team, home_goals, away_goals, result, b365_home, b365_draw, b365_away
) VALUES
(1, 'EO', '2223', '2022-01-10', 'TEAMA', 'TEAMB', 2, 0, 'H', 5.2, 2.4, 1.0),          
(2, 'EO', '2223', '2022-01-10', 'TEAMC', 'TEAMD', 0, 3, 'A', 5.2, 2.4, 1.0),          
(3, 'EO', '2223', '2022-01-10', 'TEAME', 'TEAMF', 0, 2, 'D', 1.2, 2.4, 5.0),          
(4, 'EO', '2224', '2022-01-10', 'TEAMG', 'TEAMH', 4, 1, 'H', 1.2, 2.4, 5.0),          
(5, 'EO', '2224', '2022-01-10', 'TEAMI', 'TEAMJ', 5, 5, 'A', 1.2, 2.4, 1.2),   
(6, 'EO', '2224', '2022-01-10', 'TEAMI', 'TEAMJ', 5, 5, 'D', 1.2, 2.4, 1.2);          


with counts as(
SELECT 
    season,
    league,
    COUNT(*) AS total_matches,
    SUM(CASE WHEN result == "H" THEN 1 END) AS total_home_wins,
    SUM(CASE WHEN result == "A" THEN 1 END) AS total_away_wins,
    SUM(CASE WHEN result == "D" THEN 1 END) AS total_draws
FROM matches_test
GROUP BY season
)
    SELECT
        season,
        league,
        total_matches,
        ROUND(
            100.0 * total_home_wins / total_matches,
            1
        )  AS "home_wins_%",
        ROUND(
            100.0 * total_away_wins / total_matches,
            1
        )  AS "away_wins_%",
        ROUND(
            100.0 * total_draws / total_matches,
            1
        )  AS "draws_%"
    
FROM counts
GROUP BY season;


-- EXPECTED OUTCOME

-- season  league  total_matches  home_wins_%  away_wins_%  draws_%
-- ------  ------  -------------  -----------  -----------  -------
-- 2223    E0      3                33.3            33.3     33.3        
-- 2324    E0      3                33.3            33.3     33.3     