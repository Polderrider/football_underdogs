-- TEAM NAME MATCH COUNT

-- count total matches for a team name per season
-- returns one row per team per season



SELECT
    season,
    "Arsenal" AS team,
    COUNT(result) AS "matches_played"
FROM matches
WHERE home_team = "Arsenal"
  OR away_team = "Arsenal"
GROUP BY season;

-- season  team     matches_played
-- ------  -------  --------------
-- 2223    Arsenal  38            
-- 2324    Arsenal  38  