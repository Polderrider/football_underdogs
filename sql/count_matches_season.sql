
-- counts total matches in a season
-- one row 

SELECT 
    season,
    COUNT(*) AS match_count
FROM matches
WHERE season = '2223';



-- output

-- match_count
-- -----------
-- 380 