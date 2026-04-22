-- underdog winrate

-- underdog in match is team with the lowest odds

-- id, league, season,     match_date,     home_team,   away_team, home_goals, away_goals, result, b365_home, b365_draw, b365_away
-- (1, 'EO', '2223', '     2022-01-10', '  TEAMA', '   TEAMD',         1,          0,          'H', 1.2,           2.4,        5.0),          -- result home team goals for 1

-- TEAM A is home team with home odds of 1.2
-- TEAM B is away team with away odds of 5.0    therefore team b is the underdog

-- identify underdog wins
-- count all matches in a seasonINCORRECT. denominator is count matches when underdog.
-- underdog win rate is total underdog wins / match count

-- output
--      season      underdog_win_rate
--      ------      -----------------
--      2223            10.1
--      2224            11.2


-- data is wide (not long) format, the row repesents a match for both home and away team, possible to 
-- introduce separate rows to mode home team's match and another row to model the away team's match, as each one can be an underdog and therefore need to note the win for either one

-- WITH cte AS (
--     SELECT              -- inner select aggregates data to single row unless GROUP BY is used
--         season,
--         home_team AS team,
--         SUM(CASE WHEN b365_home > b365_away  THEN 1 ELSE 0 END) as underdog_match_count,
--         SUM(CASE WHEN b365_home > b365_away AND result = 'H' THEN 1 ELSE 0 END) AS underdog_win
--     FROM matches
--     GROUP BY season, home_team      -- do not GROUP BY with an alias (eg team) because doesn't exist in some db engines etc

--     UNION ALL

--     SELECT             
--         season,
--         away_team AS team,
--         SUM(CASE WHEN b365_away > b365_home  THEN 1 ELSE 0 END) as underdog_match_count,
--         SUM(CASE WHEN b365_away > b365_home AND result = 'A' THEN 1 ELSE 0 END) AS underdog_win
--     FROM matches
--     GROUP BY season, away_team      -- do not GROUP BY with an alias (eg team) because doesn't exist in some db engines etc
-- )
-- SELECT
--     season,
--     team,
--     SUM(underdog_match_count) AS underdog_match_count,
--     SUM(underdog_win) AS underdog_win,
--     ROUND(
--         100 *
--         SUM(underdog_win) /  SUM(underdog_match_count),
--         1
--     ) AS win_rate
-- FROM cte
-- WHERE season = '2223'
-- GROUP BY season, team
-- HAVING SUM(underdog_match_count) > 0
-- ORDER BY win_rate DESC


-- Mental model
-- UNION ALL stacks partial results

-- If each branch produces fragments of the final answer, then final aggregation is needed.

-- home stats
-- +
-- away stats
-- =
-- final team stats

-- -- That requires SUM()
-- Why your instinct feels tempting

-- Because each inner SELECT already uses SUM().

-- True — but those are only:

-- home totals
-- away totals

-- not final totals.

-- They are intermediate aggregates.

WITH cte AS (
    SELECT
        id,
        season,
        home_team AS team,
        away_team AS opponent,
        result,
        b365_home,
        b365_away,
        CASE WHEN b365_home > b365_away THEN 1 ELSE 0 END AS underdog_match_count,
        CASE WHEN b365_home > b365_away AND result = 'H' THEN 1 ELSE 0 END AS underdog_win
    FROM matches

    UNION ALL

    SELECT
        id,
        season,
        away_team AS team,
        home_team AS opponent,
        result,
        b365_home,
        b365_away,
        CASE WHEN b365_away > b365_home THEN 1 ELSE 0 END AS underdog_match_count,
        CASE WHEN b365_away > b365_home AND result = 'A' THEN 1 ELSE 0 END AS underdog_win
    FROM matches
)
SELECT
    id,
    season,
    team,
    opponent,
    result,
    b365_home,
    b365_away,
    underdog_match_count,
    underdog_win
FROM cte
WHERE season = '2223'
  AND team = 'Chelsea'
ORDER BY id;