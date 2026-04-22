
-- returns the average number of total goals per match


SELECT
    season,
    ROUND(
        AVG(home_goals + away_goals), 
        2
    ) AS avg_goals
FROM matches
GROUP BY season
ORDER BY season;


-- output

-- season  avg_goals
-- ------  ---------
-- 2223    2.85     
-- 2324    3.28 