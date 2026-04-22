DROP TABLE IF EXISTS matches_test;

CREATE TABLE matches_test (
    id INTEGER PRIMARY KEY,
    league TEXT,
    season TEXT,
    match_date TEXT,
    home_team TEXT,
    away_team TEXT,
    result TEXT,
    b365_home REAL,
    b365_draw REAL,
    b365_away REAL
);


INSERT INTO matches_test (
    id, league, season, match_date, home_team, away_team, result,
    b365_home, b365_draw, b365_away
) VALUES
-- 1. Home underdog wins
(1, 'E0', '2223', '2022-08-01', 'TeamA', 'TeamB', 'H', 4.0, 3.5, 1.8),

-- 2. Away underdog wins
(2, 'E0', '2223', '2022-08-02', 'TeamC', 'TeamD', 'A', 1.7, 3.6, 5.0),

-- 3. Home underdog loses
(3, 'E0', '2223', '2022-08-03', 'TeamE', 'TeamF', 'A', 3.8, 3.4, 1.9),

-- 4. Away underdog loses
(4, 'E0', '2223', '2022-08-04', 'TeamG', 'TeamH', 'H', 1.6, 3.8, 5.5),

-- 5. Equal odds edge case
(5, 'E0', '2223', '2022-08-05', 'TeamI', 'TeamJ', 'D', 2.5, 3.2, 2.5);