-- Creates a league table by goal difference for season 2223.

-- shows home/away goals score/conceded rate

--   team   season  location  matches  goals_for  goals_against  goal_difference  goals_scored_per_match  goals_conceded_per_match
-- ------  --------- -------  ---------  -------------  ---------------  ----------------------  ------------------------
-- team a   2223        home       19       94         33             61               2.47                    0.87   
-- team a   2223        away       19       94         33             61               2.47                    0.87   
-- team b   2223        home       19       94         33             61               2.47                    0.87   
-- team b   2323        away       19       94         33             61               2.47                    0.87   


SELECT
    team,
    opponent,
    side,
    result
FROM team_match_stats
WHERE team = 'Fulham'
    AND opponent = 'Liverpool'
    AND season = '2223';


