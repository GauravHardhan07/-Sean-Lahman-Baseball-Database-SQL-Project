SELECT * FROM salaries;
-- ----Return the top 20% of teams in terms of average annual spending

WITH tol_sp as(SELECT teamID,yearID,SUM(salary) as total_spend
               FROM salaries
               GROUP BY teamID,yearID
			   ORDER BY teamID,yearID),
         SP as(SELECT teamID,AVG(total_spend) as avg_spend,
			   NTILE(5)OVER(ORDER BY AVG(total_spend) DESC) as spend_pct
			   FROM tol_sp
			   GROUP BY teamID)
SELECT teamID,ROUND(avg_spend/1000000) as in_Millions
FROM SP 
WHERE spend_pct=1;


-- ----For each team, show the cumulative sum of spending over the years
WITH cum_salary as (SELECT teamID,yearID,SUM(salary) total_spend
                    FROM salaries
                    GROUP BY teamID,yearID
                    ORDER BY teamID,yearID)
SELECT teamID,yearID,
ROUND(SUM(total_spend)OVER(PARTITION BY teamID ORDER BY yearID)/1000000) as cumm_sum
FROM cum_salary;

-- ----Return the first year that each team's cumulative spending surpassed 1 billion

WITH cum_salary as (SELECT teamID,yearID,SUM(salary) total_spend
                    FROM salaries
                    GROUP BY teamID,yearID
                    ORDER BY teamID,yearID),
	 cum_spend as (SELECT teamID,yearID,
				   ROUND(SUM(total_spend)OVER(PARTITION BY teamID ORDER BY yearID)/1000000000) as cumm_sum
                   FROM cum_salary)
SELECT yearID,teamID,cumm_sum
FROM cum_spend
WHERE cumm_sum >1;