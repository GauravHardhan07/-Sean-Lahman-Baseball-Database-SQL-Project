-- ---For each player, calculate their age at their first (debut) game, their last game, and their career length (all in years). Sort from longest career to shortest career.
SELECT * FROM players;
SELECT nameGiven,(YEAR(debut)-birthyear) as debut_age,
(YEAR(finalGame)-birthyear) as last_game_age,
TIMESTAMPDIFF(year,debut,finalGame) as career_length
FROM players
ORDER BY career_length DESC;

-- ---What team did each player play on for their starting and ending years?
SELECT playerID,nameGiven,debut,finalGame FROM players;
SELECT yearID,playerID,teamID from salaries;

SELECT p.nameGiven,
s.yearID as starting_year,s.teamID as starting_team,
e.yearID as ending_year,e.teamID as ending_team
FROM players p INNER JOIN salaries s 
							ON p.playerID=s.playerID
							AND YEAR(p.debut)=s.yearID
			   INNER JOIN salaries e 
							ON p.playerID=e.playerID
							AND YEAR(p.finalGame)=e.yearID;


-- ---How many players started and ended on the same team and also played for over a decade?
WITH same_player as(SELECT p.nameGiven,p.debut,p.finalGame,
		     s.yearID as starting_year,s.teamID as starting_team,
             e.yearID as ending_year,e.teamID as ending_team
             FROM players p INNER JOIN salaries s 
							ON p.playerID=s.playerID
							AND YEAR(p.debut)=s.yearID
			 INNER JOIN salaries e 
							ON p.playerID=e.playerID
							AND YEAR(p.finalGame)=e.yearID),
                            
ts as(SELECT nameGiven,TIMESTAMPDIFF(year,debut,finalGame) as career_length,
      starting_team,ending_team
	  FROM same_player)
SELECT nameGiven,career_length FROM ts
WHERE starting_team=ending_team AND career_length >10;
