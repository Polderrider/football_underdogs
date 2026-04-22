
-- finds teams that outperformed bookmaker expectations e.g. a team with higher odds (underdog) won the game.
-- calulates underdog win rate per team

-- data: wide format (home_team & away_team share a single row). use UNION ALL to create long format dataset assigning one row each to home team and away team
-- test: sql/tests/test_outperforming_bookmaker_odds.sql


WITH underdog_stats AS (
    SELECT 
    season,
    home_team AS team,
    SUM(CASE WHEN b365_home > b365_away THEN 1 ELSE 0 END) AS underdog_match_count,
    SUM(CASE WHEN b365_home > b365_away AND result = 'H' THEN 1 ELSE 0 END) AS underdog_win_count
    FROM matches
    GROUP BY season, team

    UNION ALL

    SELECT 
    season,
    away_team AS team,
    SUM(CASE WHEN b365_away > b365_home THEN 1 ELSE 0 END) AS underdog_match_count,
    SUM(CASE WHEN b365_away > b365_home AND result = 'A' THEN 1 ELSE 0 END) AS underdog_win_count
    FROM matches
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



-- underdog per match

-- WITH cte AS (
--     SELECT
--         id,
--         season,
--         'HOME' AS side,
--         home_team AS team,
--         away_team AS opponent,
--         b365_home,
--         b365_away,
--         CASE WHEN b365_home > b365_away THEN 1 ELSE 0 END AS is_underdog,
--         CASE WHEN b365_home > b365_away AND result = 'H' THEN 1 ELSE 0 END AS underdog_win
--     FROM matches

--     UNION ALL

--     SELECT
--         id,
--         season,
--         'AWAY' AS side,
--         away_team AS team,
--         home_team AS opponent,
--         b365_home,
--         b365_away,
--         CASE WHEN b365_away > b365_home THEN 1 ELSE 0 END AS is_underdog,
--         CASE WHEN b365_away > b365_home AND result = 'A' THEN 1 ELSE 0 END AS underdog_win
--     FROM matches
-- )
-- SELECT
--     id,
--     season,
--     side,
--     team,
--     opponent,
--     b365_home,
--     b365_away,
--     is_underdog,
--     underdog_win
-- FROM cte
-- WHERE season = '2223'
--   AND team = 'Arsenal'              
--   AND is_underdog = 1
-- ORDER BY id;