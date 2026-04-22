
-- Show the 10 matches with the highest total goals.


-- query
SELECT
    season,
    match_date,
    home_team,
    away_team,
    home_goals,
    away_goals,
    (home_goals + away_goals) AS match_goals 

FROM matches
ORDER BY match_goals DESC       
LIMIT 10;

-- note: more deterninistic: ORDER BY match_goals DESC, match_date ASC


-- OUTPUT
-- season  match_date  home_team          away_team          home_goals  away_goals  match_goals
-- ------  ----------  -----------------  -----------------  ----------  ----------  -----------
-- 2223    2022-08-27  Liverpool          Bournemouth        9           0           9          
-- 2223    2022-10-02  Manchester City    Manchester United  6           3           9          
-- 2223    2022-09-17  Tottenham Hotspur  Leicester City     6           2           8          
-- 2223    2023-05-08  Fulham             Leicester City     5           3           8          
-- 2223    2023-05-28  Southampton FC     Liverpool          4           4           8          
-- 2324    2023-09-24                     Newcastle United   0           8           8          
-- 2324    2023-11-12  Chelsea            Manchester City    4           4           8          
-- 2324    2024-02-03  Newcastle United                      4           4           8          
-- 2223    2022-09-03  Brentford FC       Leeds United       5           2           7          
-- 2223    2022-09-04  Brighton           Leicester City     5           2           7