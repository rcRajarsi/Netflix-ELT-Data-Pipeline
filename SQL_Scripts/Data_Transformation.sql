SELECT * FROM netflix_raw 


--HANDLING FOREIGN CHARACTERS (by using nvarchar instead of varchar)
SELECT * FROM netflix_raw WHERE show_id = 's5023'

SELECT * FROM netflix_raw ORDER BY title


--REMOVING DUPLICATES

--selecting a column for primary key
SELECT show_id,COUNT(show_id) 
FROM netflix_raw 
GROUP BY show_id
HAVING COUNT(*) > 1

--checking for duplicate movies and tv shows
SELECT * FROM netflix_raw 
WHERE CONCAT(title,type) IN
(
	SELECT CONCAT(title,type)
	FROM netflix_raw
	GROUP BY CONCAT(title,type)
	HAVING COUNT(*) > 1
)
ORDER BY title

--removing duplicate movies and tv shows (no. of rows will decrease)
WITH CTE AS 
(
	SELECT * ,ROW_NUMBER() OVER(PARTITION BY title, type ORDER BY show_id) AS rn 
	FROM netflix_raw 
)
SELECT * FROM CTE WHERE rn = 1


--NEW TABLE FOR DIRECTOR, LISTED IN, COUNTRY, CAST
SELECT show_id, TRIM(VALUE) AS director 
INTO netflix_directors
FROM netflix_raw
CROSS APPLY STRING_SPLIT(director,',')

SELECT * FROM netflix_directors

SELECT show_id, TRIM(VALUE) AS CAST 
INTO netflix_cast
FROM netflix_raw
CROSS APPLY STRING_SPLIT(CAST,',')

SELECT * FROM netflix_cast

SELECT show_id, TRIM(VALUE) AS country 
INTO netflix_country
FROM netflix_raw
CROSS APPLY STRING_SPLIT(country,',')

SELECT * FROM netflix_country

SELECT show_id, TRIM(VALUE) AS genre 
INTO netflix_genre
FROM netflix_raw
CROSS APPLY STRING_SPLIT(listed_in,',')

SELECT * FROM netflix_genre


-- DATA TYPE CONVERSION FOR DATE ADDED AND HANDLING NULL DURATION VALUE
WITH CTE AS 
(
	SELECT * ,ROW_NUMBER() OVER(PARTITION BY title, type ORDER BY show_id) AS rn 
	FROM netflix_raw 
)
SELECT show_id, type, title, CAST(date_added as DATE) as date_added, release_year, rating,
CASE WHEN duration IS NULL THEN rating ELSE duration END AS duration, description
FROM CTE WHERE rn = 1


--POPULATE MISSING VALUES IN COUNTRY, DURATION COLUMNS
INSERT INTO netflix_country
SELECT show_id,m.country 
FROM netflix_raw nr
inner join
(
	SELECT director, country FROM netflix_country nc 
	inner join 
	netflix_directors nd ON nc.show_id = nd.show_id
	GROUP BY director, country
)m ON nr.director = m.director
WHERE nr.country IS NULL

SELECT * FROM netflix_raw WHERE director = 'Ahishor Solomon'

SELECT director, country FROM netflix_country nc 
inner join 
netflix_directors nd ON nc.show_id = nd.show_id
GROUP BY director, country

SELECT * FROM netflix_raw WHERE duration IS NULL

--CREATING FINAL TABLE
WITH CTE AS 
(
	SELECT * ,ROW_NUMBER() OVER(PARTITION BY title, type ORDER BY show_id) AS rn 
	FROM netflix_raw 
)
SELECT show_id, type, title, CAST(date_added as DATE) as date_added, release_year, rating,
CASE WHEN duration IS NULL THEN rating ELSE duration END AS duration, description
INTO netflix
FROM CTE WHERE rn = 1

SELECT * FROM netflix