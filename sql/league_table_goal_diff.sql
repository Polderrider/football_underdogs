

-- displays a simple league table by goal difference for season 2223.

-- Return: season, team, goals_for, goals_against, goal_difference
-- Include both home and away matches.


WITH goal_stats AS (    
    SELECT
        season,
        home_team AS team,
        COUNT(*) AS matches_played,
        SUM(home_goals) AS goals_for,
        SUM(away_goals) AS goals_against
    FROM matches
    GROUP BY season, home_team

    UNION ALL

    SELECT
       season,
        away_team AS team,
        COUNT(*) AS matches_played,
        SUM(away_goals) AS goals_for,
        SUM(home_goals) AS goals_against
    FROM matches
    GROUP BY season, away_team
)
SELECT
    season,
    team,
    SUM(matches_played) AS matches,
    SUM(goals_for) AS goals_for,
    SUM(goals_against) AS goals_against,
    SUM(goals_for) - SUM(goals_against) AS goal_difference   
    
FROM goal_stats
WHERE season = '2223'
GROUP BY season, team
ORDER BY goal_difference DESC;

-- query additional
-- ROUND(
--         1.0 * SUM(goals_for) / SUM(matches_played),
--         2
--     ) AS goals_scored_per_match,
--     ROUND(
--         1.0 * SUM(goals_against) / SUM(matches_played),
--         2
--     ) AS goals_conceded_per_match

-- query outputs table

-- season  team                     matches  goals_for  goals_against  goal_difference
-- ------  -----------------------  -------  ---------  -------------  ---------------
-- 2223    Manchester City          38       94         33             61             
-- 2223    Arsenal                  38       88         43             45             
-- 2223    Newcastle United         38       68         33             35             
-- 2223    Liverpool                38       75         47             28             
-- 2223    Brighton                 38       72         53             19             
-- 2223    Manchester United        38       58         43             15             
-- 2223    Brentford FC             38       58         46             12             
-- 2223    Tottenham Hotspur        38       70         63             7              
-- 2223    Aston Villa              38       51         46             5              
-- 2223    Fulham                   38       55         53             2              
-- 2223    Chelsea                  38       38         47             -9             
-- 2223    Crystal Palace           38       40         49             -9             
-- 2223    West Ham United          38       42         55             -13            
-- 2223    Leicester City           38       51         68             -17            
-- 2223    Everton                  38       34         57             -23            
-- 2223    Wolverhampton Wanderers  38       31         58             -27            
-- 2223    Leeds United             38       48         78             -30            
-- 2223    Nottingham Forest        38       38         68             -30            
-- 2223    Bournemouth              38       37         71             -34            
-- 2223    Southampton FC           38       36         73             -37  