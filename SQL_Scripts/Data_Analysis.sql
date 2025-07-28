SELECT * FROM netflix


--ANALYZING DATA FROM FINAL NETFLIX TABLE


/*1.  For each director count the no. of movies and tv shows created by them in separate columns 
for directors who have created tv shows and movies both */

SELECT nd.director, 
COUNT(CASE WHEN n.type = 'Movie' THEN n.show_id end) AS no_of_movies,
COUNT(CASE WHEN n.type = 'TV show' THEN n.show_id end) AS no_of_tvshows
FROM netflix n
INNER JOIN
netflix_directors nd ON n.show_id = nd.show_id
GROUP BY nd.director
HAVING COUNT(DISTINCT n.type) > 1


--2. Countries with highst no. of comedy movies

SELECT TOP 1 nc.country, COUNT(DISTINCT nc.show_id) AS no_of_comedy_movies FROM netflix_country nc
INNER JOIN 
netflix_genre ng ON nc.show_id = ng.show_id
INNER JOIN 
netflix n ON nc.show_id = ng.show_id
WHERE ng.genre LIKE 'comedies' AND n.type = 'Movie'
GROUP BY nc.country
ORDER BY no_of_comedy_movies DESC


--3. For each year (as per date_added to netflix), which director has maximum no. of movies released

WITH CTE AS
(
	SELECT nd.director, YEAR(n.date_added) AS date_year, COUNT(n.show_id) AS no_of_movies_released 
	FROM netflix n
	INNER JOIN netflix_directors nd ON n.show_id = nd.show_id
	WHERE n.type = 'Movie'
	GROUP BY YEAR(n.date_added), nd.director
),
CTE2 AS
(
	SELECT *, ROW_NUMBER() OVER (PARTITION BY date_year ORDER BY no_of_movies_released DESC, director) AS rn
	FROM CTE 
)
SELECT * FROM CTE2 WHERE rn = 1


-- 4. Average duration of movies in in each genre

SELECT ng.genre, AVG(CAST(REPLACE(n.duration, ' min', '') AS INT)) AS avg_duration FROM netflix n
INNER JOIN netflix_genre ng ON n.show_id = ng.show_id
WHERE n.type = 'Movie'
GROUP BY ng.genre 


-- 5. Directors who have created both horror and comedy movies
--    (display director name along with number of comedy and horror movies directed by them)

SELECT nd.director, 
COUNT(DISTINCT CASE WHEN ng.genre = 'Comedies' THEN n.show_id end) AS comedy_movies, 
COUNT(DISTINCT CASE WHEN ng.genre = 'Horror Movies' THEN n.show_id end) AS horror_movies
FROM netflix n
INNER JOIN netflix_genre ng ON n.show_id = ng.show_id 
INNER JOIN netflix_directors nd ON n.show_id = nd.show_id
WHERE n.type = 'Movie' AND ng.genre IN ('Comedies','Horror Movies') 
GROUP BY nd.director
HAVING COUNT(DISTINCT ng.genre) = 2