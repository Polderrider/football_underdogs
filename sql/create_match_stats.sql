-- creates long version of matches (wide) data
-- splites out home/away side; add points

DROP TABLE IF EXISTS team_match_stats; 

CREATE TABLE team_match_stats AS
SELECT
    id AS match_id,
    season,
    league,
    match_date,
    home_team AS team,
    away_team AS opponent,
    'HOME' AS side,
    result,
    home_goals AS goals_for,
    away_goals AS goals_against,
    CASE
        WHEN result = 'H' THEN 3
        WHEN result = 'D' THEN 1
        ELSE 0
    END AS points,
    b365_home,
    b365_draw,
    b365_away

FROM matches

UNION ALL

SELECT
    id AS match_id,
    season,
    league,
    match_date,
    away_team AS team,
    home_team AS opponent,
    'AWAY' AS side,
    result,
    away_goals AS goals_for,
    home_goals AS goals_against,
    CASE
        WHEN result = 'A' THEN 3
        WHEN result = 'D' THEN 1
        ELSE 0
    END AS points,
    b365_home,
    b365_draw,
    b365_away

FROM matches;