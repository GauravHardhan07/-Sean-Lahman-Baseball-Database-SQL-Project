
SELECT * FROM schools;
SELECT * FROM school_details;

-- ----- In each decade, how many schools were there that produced MLB players?
SELECT ROUND(yearID,-1)as decade,COUNT(DISTINCT schoolID)as num_schools
FROM schools
GROUP BY decade
ORDER BY decade;

-- ----- What are the names of the top 5 schools that produced the most players?
SELECT s.schoolID,sd.name_full,count(DISTINCT s.playerID) as player_count
FROM schools s LEFT JOIN school_details sd
ON s.schoolID=sd.schoolID
GROUP BY s.schoolID,sd.name_full
ORDER BY player_count DESC
LIMIT 5;

-- ----- For each decade, what were the names of the top 3 schools that produced the most players?
WITH top_3 as (SELECT ROUND(yearID,-1) as decade, 
			   s.schoolID,
			   sd.name_full, 
               count(DISTINCT s.playerID) as player_count,
               ROW_NUMBER()OVER(PARTITION BY ROUND(yearID,-1) ORDER BY count(DISTINCT playerID) DESC) as rank_num
               FROM schools s LEFT JOIN school_details sd
               ON s.schoolID=sd.schoolID
               GROUP BY decade,s.schoolID,sd.name_full
			   ORDER BY decade )

SELECT decade,schoolID,name_full,player_count,rank_num
FROM top_3
WHERE rank_num <=3;
