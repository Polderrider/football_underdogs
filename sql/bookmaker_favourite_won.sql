
-- return matches where the bookmaker's favourite won (ie lower betting odds than the other team)

-- subquery finds favourite
-- returns one row per match when favourite equals match result

WITH fav AS (
    SELECT
        match_date,
        home_team,
        away_team,
        result,
        CASE
            WHEN b365_home < b365_away THEN 'H'
            WHEN b365_away < b365_home THEN 'A'
            ELSE 'D'
        END AS favourite
    FROM matches
)
SELECT
    match_date,
    home_team,
    away_team,
    favourite,
    result,
    CASE
        WHEN favourite = result THEN 'Y'
        ELSE 'N'
    END AS favourite_won
FROM fav
WHERE favourite_won = 'Y'
ORDER BY match_date;