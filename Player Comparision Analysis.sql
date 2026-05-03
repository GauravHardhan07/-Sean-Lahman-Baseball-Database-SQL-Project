-- ---Which players have the same birthday?
SELECT * FROM players;

WITH bn as (SELECT CAST(CONCAT(birthyear,'-',birthmonth,'-',birthday)as DATE) as birthdate,
			       nameGiven
		    FROM players)
SELECT birthdate,GROUP_CONCAT(nameGiven SEPARATOR ',') AS players
FROM bn
WHERE YEAR(birthdate) BETWEEN 1980 AND 1990
GROUP BY birthdate
ORDER BY birthdate;
            
-- ----Create a summary table that shows for each team, what percent of players bat right, left and both.

SELECT * FROM salaries;
SELECT * FROM players;

SELECT s.teamID,COUNT(s.playerID) as num_players,
ROUND(SUM(CASE WHEN bats='R' THEN 1 ELSE 0 END )/COUNT(s.playerID)*100,2) as 'Right Batsman',
ROUND(SUM(CASE WHEN bats='L' THEN 1 ELSE 0 END )/COUNT(s.playerID)*100,2)  as 'Left Batsman',
ROUND(SUM(CASE WHEN bats='B' THEN 1 ELSE 0 END )/COUNT(s.playerID)*100,2)  as 'BothArm Batsman'
FROM players p
LEFT JOIN salaries s
ON p.playerID=s.playerID
GROUP BY s.teamID;

-- ----How have average height and weight at debut game changed over the years, and what's the decade-over-decade difference?
WITH stats as (SELECT ROUND(YEAR(debut),-1) as decade,
               AVG(weight) as avg_weight ,
               AVG(height) as avg_height
               FROM players
               GROUP BY decade
               ORDER BY decade)

SELECT decade,
       avg_height - LAG(avg_height) OVER (ORDER BY decade) AS diff_height,
	   avg_weight - LAG(avg_weight) OVER (ORDER BY decade) AS diff_weight
FROM  stats
WHERE decade IS NOT NULL;

