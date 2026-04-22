
-- Find matches where the bookmaker favourite did not win.

-- bookmaker favourite = team with lowest odds

-- query 
WITH fav AS (
    SELECT
        season,
        match_date,
        home_team,
        away_team,
        result,
        CASE
            WHEN b365_home < b365_away THEN 'H'
            WHEN b365_away < b365_home THEN 'A'
            ELSE NULL
        END AS favourite_side
    FROM matches
)
SELECT
    season,
    match_date,
    home_team,
    away_team,
    result,
    favourite_side                  -- 'H'= home win, 'A'=away win
FROM fav
WHERE favourite_side IS NOT NULL
  AND favourite_side != result;


-- output

-- season  match_date  home_team                away_team                result  favourite_side
-- ------  ----------  -----------------------  -----------------------  ------  --------------
-- 2223    2022-08-06  Fulham                   Liverpool                D       A             
-- 2223    2022-08-06  Bournemouth              Aston Villa              H       A             
-- 2223    2022-08-07  Leicester City           Brentford FC             D       H             
-- 2223    2022-08-07  Manchester United        Brighton                 A       H             
-- 2223    2022-08-13  Brighton                 Newcastle United         D       H             
-- 2223    2022-08-13  Southampton FC           Leeds United             D       H             
-- 2223    2022-08-13  Wolverhampton Wanderers  Fulham                   D       H             
-- 2223    2022-08-13  Brentford FC             Manchester United        H       A             
-- 2223    2022-08-14  Nottingham Forest        West Ham United          H       A             
-- 2223    2022-08-14  Chelsea                  Tottenham Hotspur        D       H   
