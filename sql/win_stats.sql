
-- calculates home win %, draw %, away win % per league/season
-- return one row with three percentages
-- test: see sql/tests/test_win_stats.sql replace FROM matches


with counts as(
SELECT 
    season,
    league,
    COUNT(*) AS total_matches,
    SUM(CASE WHEN result == "H" THEN 1 END) AS total_home_wins,
    SUM(CASE WHEN result == "A" THEN 1 END) AS total_away_wins,
    SUM(CASE WHEN result == "D" THEN 1 END) AS total_draws
FROM matches
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

-- output

-- season  league  total_matches  home_wins_%  away_wins_%  draws_%
-- ------  ------  -------------  -----------  -----------  -------
-- 2223    E0      380            48.4         28.7         22.9   
-- 2324    E0      380            46.1         32.4         21.6     