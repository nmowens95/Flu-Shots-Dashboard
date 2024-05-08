/*
Objectives:
1) Total % of patients getting flu shots based on:
	a. Age
	b. Race
	c. County (Map)
	d. Overall
2) Running total of flu shots over the course of 2022
3) Total number of flu shots give in 2022
4) List of patients that show whether or not they recieved the flu shots

Other requirements
- Patient is alive
- Patient is at least 6 months (age it is recommended to start flu shot)

*/


-- Created a CTE to query off of to include alive patients and those of age
WITH active_patients AS (
	SELECT DISTINCT patient
	FROM encounters AS e
	JOIN patients AS p
		ON e.patient = p.id
	WHERE start BETWEEN '2020-01-01 00:00:00'
		AND '2022-12-31 23:59:59'
		AND p.deathdate IS null
		AND EXTRACT(MONTH FROM age('2022-12-31', p.birthdate)) >= 6 -- Evaluate age in months
),

-- Created a CTE to query off of to include flu shot data and specific time stamps
flu_shot_2022 AS (
SELECT
	patient,
	MIN(date) AS first_flu_shot_2022
FROM immunizations
WHERE code = 5302
 AND date BETWEEN '2022-01-01 00:00:00'
 	AND '2022-12-31 23:59:59'
GROUP BY patient)

SELECT
	p.birthdate,
	p.race,
	p.county,
	p.id,
	p.first,
	p.last,
	flu.first_flu_shot_2022,
	flu.patient, -- show patients that did and did not get flu shot
	CASE WHEN  flu.patient IS NOT null THEN 1 ELSE 0 END AS flu_shot_2022 -- able to take total of flu shots
FROM patients AS p
LEFT JOIN flu_shot_2022 as flu
	ON p.id = flu.patient
WHERE 1=1 -- (Placeholder) Use subquery to reference CTE active_patients
	AND p.id IN (
		SELECT patient
		FROM active_patients
	)