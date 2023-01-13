--6 the join operation
-- Modify it to show the matchid and player name for all goals scored by Germany. To identify German players, check for: teamid = 'GER'
SELECT matchid, player FROM goal 
  WHERE teamid= 'GER'

-- Show id, stadium, team1, team2 for just game 1012
SELECT id,stadium,team1,team2
  FROM game
 WHERE id = 1012

-- Modify it to show the player, teamid, stadium and mdate for every German goal.
SELECT player,teamid, stadium, mdate
  FROM game JOIN goal ON (id=matchid) where teamid= 'GER'

--Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'
SELECT team1, team2, player
  FROM game JOIN goal ON (id=matchid) where player like 'Mario%'

-- Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10
SELECT player, teamid, coach, gtime
FROM goal
JOIN eteam ON (goal.teamid = eteam.id)
WHERE gtime <= 10

-- List the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.
SELECT mdate, teamname
FROM game
JOIN eteam ON (game.team1 = eteam.id)
WHERE coach = 'Fernando Santos'

-- List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'
SELECT player
FROM goal
JOIN game ON (goal.matchid = game.id)
WHERE stadium = 'National Stadium, Warsaw'

-- Instead show the name of all players who scored a goal against Germany.
SELECT DISTINCT player
FROM game
JOIN goal ON goal.matchid = game.id
WHERE (team1 = 'GER' OR team2 = 'GER')
AND teamid <> 'GER'

-- Show teamname and the total number of goals scored.
SELECT teamname, COUNT(player) goals_scored
FROM eteam JOIN goal ON eteam.id = goal.teamid
GROUP BY teamname

-- Show the stadium and the number of goals scored in each stadium.
SELECT stadium, COUNT(player) goals_scored
FROM game
JOIN goal ON game.id = goal.matchid
GROUP BY stadium

-- For every match involving 'POL', show the matchid, date and the number of goals scored.
SELECT matchid,mdate,COUNT(teamid)
  FROM game JOIN goal ON matchid = id 
 WHERE (team1 = 'POL' OR team2 = 'POL')
GROUP BY matchid,mdate

-- For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'
SELECT matchid,mdate,COUNT(teamid)
  FROM game JOIN goal ON matchid = id 
 WHERE (teamid='GER')
GROUP BY matchid,mdate

-- List every match with the goals scored by each team as shown. This will use "CASE WHEN" which has not been explained in any previous exercises.
SELECT mdate,
  team1,
  SUM(CASE WHEN teamid=team1 THEN 1 ELSE 0 END) score1,
  team2,
  SUM(CASE WHEN teamid=team2 THEN 1 ELSE 0 END) score2
  FROM game LEFT JOIN goal ON matchid = id 
GROUP BY mdate,matchid,team1,team2

--7 More JOIN operations
-- List the films where the yr is 1962 [Show id, title]
SELECT id, title
 FROM movie
 WHERE yr=1962

-- Give year of 'Citizen Kane'.
SELECT yr
FROM movie
WHERE title = 'Citizen Kane'

-- List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.
SELECT id, title, yr
FROM movie
WHERE title LIKE '%star trek%'
ORDER BY yr

-- What id number does the actor 'Glenn Close' have?
SELECT id
FROM actor
WHERE name = 'Glenn Close'

-- What is the id of the film 'Casablanca'
SELECT id
FROM movie
WHERE title = 'Casablanca'

-- Obtain the cast list for 'Casablanca'.
SELECT name
FROM actor, casting
WHERE id=actorid AND movieid = (SELECT id FROM movie WHERE title = 'Casablanca')

-- Obtain the cast list for the film 'Alien'
SELECT name
FROM actor
  JOIN casting ON (id=actorid AND movieid = (SELECT id FROM movie WHERE title = 'Alien'))

-- List the films in which 'Harrison Ford' has appeared
SELECT title
FROM movie
  JOIN casting ON (id=movieid AND actorid = (SELECT id FROM actor WHERE name = 'Harrison Ford'))

-- List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]
SELECT title
FROM movie
    JOIN casting ON (id=movieid AND actorid = (SELECT id FROM actor WHERE name = 'Harrison Ford') AND ord != 1)

-- List the films together with the leading star for all 1962 films.
SELECT title, name
FROM movie JOIN casting ON (id=movieid)
JOIN actor ON (actor.id = actorid)
WHERE ord=1 AND  yr = 1962

-- Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies.
SELECT yr, COUNT(title)

FROM movie AS m

JOIN casting AS c

ON (c.movieid = m.id)

JOIN actor AS a

ON (a.id = c.actorid)

WHERE a.name = 'Rock Hudson'

GROUP BY m.yr

HAVING COUNT(m.title) > 2

-- List the film title and the leading actor for all of the films 'Julie Andrews' played in.
SELECT title, name 
FROM 
   movie  JOIN casting ON movie.id=movieid
          JOIN actor   ON actorid=actor.id
WHERE ord = 1 AND movieid IN ( SELECT movieid 
                               FROM casting JOIN actor
                               ON actorid = actor.id
                               WHERE name = 'Julie Andrews') 

-- Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles.
SELECT name
FROM actor JOIN casting
ON id = actorid
AND ord = 1
GROUP BY name
HAVING COUNT(name) >= 15;

-- List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
SELECT title, COUNT(actorid) AS actors FROM movie
JOIN casting ON id = movieid
WHERE yr = 1978
GROUP BY title
ORDER BY actors DESC, title

-- List all the people who have worked with 'Art Garfunkel'.
SELECT DISTINCT name
FROM actor JOIN casting ON id=actorid
WHERE movieid IN (SELECT movieid FROM casting JOIN actor ON (actorid=id AND name='Art Garfunkel')) AND name != 'Art Garfunkel'
GROUP BY name