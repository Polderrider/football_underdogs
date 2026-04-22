
-- For season 2223, show each team’s average home goals scored.

-- query
SELECT
    season,
    home_team,
    COUNT(*) AS matches_played_at_home,
    ROUND(
        AVG(home_goals),
        1
    ) AS avg_home_goals

FROM matches
WHERE season = '2223'
GROUP BY season, home_team
ORDER BY avg_home_goals DESC;


-- output

-- season  home_team                matches_played_at_home  avg_home_goals
-- ------  -----------------------  ----------------------  --------------
-- 2223    Manchester City          19                      3.2           
-- 2223    Arsenal                  19                      2.8           
-- 2223    Liverpool                19                      2.4           
-- 2223    Brighton                 19                      1.9           
-- 2223    Manchester United        19                      1.9           
-- 2223    Newcastle United         19                      1.9           
-- 2223    Tottenham Hotspur        19                      1.9           
-- 2223    Brentford FC             19                      1.8           
-- 2223    Aston Villa              19                      1.7           
-- 2223    Fulham                   19                      1.6           
-- 2223    Leeds United             19                      1.4           
-- 2223    Nottingham Forest        19                      1.4           
-- 2223    West Ham United          19                      1.4           
-- 2223    Leicester City           19                      1.2           
-- 2223    Bournemouth              19                      1.1           
-- 2223    Chelsea                  19                      1.1           
-- 2223    Crystal Palace           19                      1.1           
-- 2223    Southampton FC           19                      1.0           
-- 2223    Wolverhampton Wanderers  19                      1.0           
-- 2223    Everton                  19                      0.8  


-- avg home goals per selected team

-- SELECT
--     id,
--     season,
--     home_team,
--     home_goals,
--     away_team,
--     away_goals,
--     COUNT(*) AS matches_played_at_home,
--     ROUND(
--         AVG(home_goals),
--         1
--     ) AS avg_home_goals

-- FROM matches
-- WHERE season = '2223'
--     AND home_team = 'Everton'
-- GROUP BY id
-- ORDER BY avg_home_goals DESC;
