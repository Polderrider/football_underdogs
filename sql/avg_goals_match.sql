
-- returns the average number of goals per match

WITH underdog_goals AS (
    SELECT 
    season,
    home_team AS team,
    SUM(home_goals + away_goals) AS total_goals,
    COUNT(*) AS total_matches,
    SUM(CASE WHEN b365_home > b365_away THEN home_goals + away_goals ELSE 0 END) AS underdog_match_goals,
    SUM(CASE WHEN b365_home > b365_away THEN 1 ELSE 0 END) AS underdog_matches

    FROM matches
    GROUP BY season, team

    UNION ALL

    SELECT 
    season,
    away_team AS team,
    SUM(home_goals + away_goals) AS total_goals,
    COUNT(*) AS total_matches,
    SUM(CASE WHEN b365_away > b365_home THEN home_goals + away_goals ELSE 0 END) AS underdog_match_goals,
    SUM(CASE WHEN b365_away > b365_home THEN 1 ELSE 0 END) AS underdog_matches

    FROM matches
    GROUP BY season, team
)
SELECT
    season,
    ROUND(
        1.0 * SUM(total_goals) / SUM(total_matches), 
        4
    ) AS avg_goals_per_match,
    ROUND(
        1.0 * SUM(underdog_match_goals) / SUM(underdog_matches), 
        4
    ) AS avg_goals_per_underdog_match

FROM underdog_goals
GROUP BY season
ORDER BY season;


-- output

-- season  avg_goals
-- ------  ---------
-- 2223    2.85     
-- 2324    3.28 


-- season  avg_goals   underdog_match_avg_goals    underdog_scored_goals_avg
-- ------  ---------
-- 1819    2.82     
