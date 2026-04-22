-- Q14
-- For each season, count how many matches were:
                -- home win
                -- away win
                -- draw

-- Return one row per season.

--          home_win    away_win    draw
-- 2223     1           1           0
-- 2324     1           1           1


-- test row claddifvationis correct 
-- SELECT
--     season,
--     SUM(CASE WHEN result = 'H' THEN 1 END) AS home_win,
--     SUM(CASE WHEN result = 'A' THEN 1 END) AS away_win,
--     SUM(CASE WHEN result = 'D' THEN 1 END) AS draw

-- FROM matches_test
-- GROUP BY season
-- ORDER BY match_date

-- expected
--          home_win    away_win    draw
-- 2223     1           1           0
-- 2324     1           1           1

-- output
--          home_win    away_win    draw
-- 2223     1           1                       no zero
-- 2324     1           1           1

-- test metrics equal season total
-- WITH game_total as (
--     SELECT
--         season,
--         SUM(CASE WHEN result = 'H' THEN 1 END) AS home_win,
--         SUM(CASE WHEN result = 'A' THEN 1 END) AS away_win,
--         SUM(CASE WHEN result = 'D' THEN 1 END) AS draw

--     FROM matches
--     GROUP BY season
--     ORDER BY match_date
-- )
-- SELECT 
--     season,
--     home_win,
--     away_win,
--     draw,
--     (home_win + away_win + draw) AS total_games_in_season_380

-- FROM game_total
-- GROUP BY season;


-- query
SELECT
    season,
    SUM(CASE WHEN result = 'H' THEN 1 END) AS home_win,
    SUM(CASE WHEN result = 'A' THEN 1 END) AS away_win,
    SUM(CASE WHEN result = 'D' THEN 1 END) AS draw

FROM matches
GROUP BY season
ORDER BY match_date

-- season  home_win  away_win  draw
-- ------  --------  --------  ----
-- 2223    184       109       87  
-- 2324    175       123       82  