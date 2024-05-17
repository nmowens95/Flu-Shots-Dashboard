# <h1 align="center">Flu Shots Dashboard</h1>
![flu shots dash](https://github.com/nmowens95/Flu-Shots-Dashboard/assets/126295718/1a086a0e-e2fc-4889-b6c4-5eb3be02a329)
</br>


NOTE: This data is fake data that is supposed to be located around the state of Massachusets
- The data was obtained and uploaded into a PostgreSQL database, transformed and then visualized in Power BI.
  
<img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/postgresql/postgresql-original.svg" height="60" alt="PostgreSQL"/> <img width="25"/>
<img src="https://github.com/nmowens95/nmowens95/assets/126295718/e26519e6-9bec-477e-8eb9-8f3770f2dbe9" height="60" alt="Power BI"/> <img width="25"/>

## <h2 align="center">Key Objectives</h2>
1) Total % of patients getting flu shots based on:
- Age 
- Race
- County (Map)
- Overall
2) Monthly total of shots over the course of 2022
3) Total number of flu shots give in 2022
4) List of patients that show whether or not they recieved the flu shots

Other requirements
- Patient is alive
- Patient is at least 6 months (age recommended to start the flu shot)

## <h2 align="center">SQL Code For Report</h2>
View SQL Code File --> [Click Here](https://github.com/nmowens95/Flu-Shots-Dashboard/blob/main/sql_scripts/flu_shot_script.sql)
```bash
WITH active_patients AS (
	SELECT DISTINCT patient
	FROM encounters AS e
	JOIN patients AS p
		ON e.patient = p.id
	WHERE start BETWEEN '2020-01-01 00:00:00'
		AND '2022-12-31 23:59:59'
		AND p.deathdate IS null
		AND EXTRACT(MONTH FROM age('2022-12-31', p.birthdate)) >= 6
),

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
	flu.patient,
	CASE WHEN  flu.patient IS NOT null THEN 1 ELSE 0 END AS flu_shot_2022
FROM patients AS p
LEFT JOIN flu_shot_2022 as flu
	ON p.id = flu.patient
WHERE 1=1
	AND p.id IN (
		SELECT patient
		FROM active_patients
	)
```

## <h2 align="center">Analysis</h2>
- The elderly population within all age categories showed the highest result in compliance of getting the flu shot.
- Within age groups of 18 to 34 and 35 to 49 all ethnicites especially White and Other categories had low compliance.
- Flu shots peak around April (Spring time) and continuously decline the rest of the year.

## <h2 align="center">Suggestions</h2>
- We should push for colleges to advocate or set up workshops to get the flu shot as well as businesses to target the younger populations.
- There may be a need for campaigning to help push the agenda in places like Hampshire county and Duke county where the compliance rates are below 60% for the white and other category ethnicites.
- Flu shots are generally most effective and advocated to be given around the Spring, thus there should be a greater education for people to get their shot earlier in the year by their doctors with the possible help from campaigning.
