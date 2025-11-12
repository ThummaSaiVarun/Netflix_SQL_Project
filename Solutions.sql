--1) Count the Number of Movies vs TV Shows
SELECT
  type,
  COUNT(*) AS cnt
FROM netflix
GROUP BY type;

--2) Most Common Rating for Movies and TV Shows
WITH RatingCounts AS (
  SELECT
    type,
    rating,
    COUNT(*) AS rating_count
  FROM netflix
  GROUP BY type, rating
),
RankedRatings AS (
  SELECT
    type,
    rating,
    rating_count,
    RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rk
  FROM RatingCounts
)
SELECT
  type,
  rating AS most_frequent_rating
FROM RankedRatings
WHERE rk = 1;

--3) List All Movies Released in a Specific Year (e.g., 2020)
SELECT *
FROM netflix
WHERE release_year = 2020;

--4) Top 5 Countries with the Most Content
SELECT TOP 5
  TRIM(value) AS country,
  COUNT(*) AS total_content
FROM netflix
CROSS APPLY STRING_SPLIT(country, ',')
WHERE value IS NOT NULL AND LTRIM(RTRIM(value)) <> ''
GROUP BY TRIM(value)
ORDER BY total_content DESC;

--5) Identify the Longest Movie (by minutes)
SELECT TOP 1 *
FROM netflix
WHERE type = 'Movie'
ORDER BY TRY_CAST(LEFT(duration, CHARINDEX(' ', duration + ' ') - 1) AS INT) DESC;

--6) Find Content Added in the Last 5 Years
SELECT *
FROM netflix
WHERE date_added >= DATEADD(YEAR, -5, CAST(GETDATE() AS DATE));

--7) All Movies/TV Shows by Director 'Rajiv Chilaka'
SELECT *
FROM netflix
CROSS APPLY STRING_SPLIT(director, ',') AS d
WHERE LTRIM(RTRIM(d.value)) = 'Rajiv Chilaka';

--8) TV Shows with More Than 5 Seasons
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND TRY_CAST(LEFT(duration, CHARINDEX(' ', duration + ' ') - 1) AS INT) > 5;

--9) Count Content Items per Genre
SELECT
  TRIM(value) AS genre,
  COUNT(*) AS total_content
FROM netflix
CROSS APPLY STRING_SPLIT(listed_in, ',')
WHERE value IS NOT NULL AND LTRIM(RTRIM(value)) <> ''
GROUP BY TRIM(value)
ORDER BY total_content DESC;

--10) For India — yearly releases and top 5 years by percent of India’s total
WITH IndiaReleases AS (
  SELECT
    release_year,
    COUNT(show_id) AS total_release
  FROM netflix
  WHERE country LIKE '%India%' 
  GROUP BY release_year
),
IndiaTotal AS (
  SELECT COUNT(show_id) AS total_india FROM netflix WHERE country LIKE '%India%'
)
SELECT TOP 5
  ir.release_year,
  ir.total_release,
  ROUND(CAST(ir.total_release AS float) / CAST(it.total_india AS float) * 100, 2) AS pct_of_india_total
FROM IndiaReleases ir
CROSS JOIN IndiaTotal it
ORDER BY pct_of_india_total DESC;

--11) List All Movies that are Documentaries
SELECT *
FROM netflix
WHERE listed_in LIKE '%Documentaries%';

--12) Find All Content Without a Director
SELECT *
FROM netflix
WHERE director IS NULL OR LTRIM(RTRIM(director)) = '';

--13) How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
SELECT COUNT(*) AS films_count
FROM netflix
WHERE [cast] LIKE '%Salman Khan%'
  AND release_year > (YEAR(GETDATE()) - 10);

--14) Top 10 Actors Appearing Most in Indian Movies
SELECT TOP 10
  TRIM(value) AS actor,
  COUNT(*) AS appearances
FROM netflix
CROSS APPLY STRING_SPLIT(cast, ',')
WHERE country LIKE '%India%' AND LTRIM(RTRIM(value)) <> ''
GROUP BY TRIM(value)
ORDER BY appearances DESC;

--15) Categorize Content Based on 'kill' / 'violence' Keywords
SELECT
  category,
  COUNT(*) AS content_count
FROM (
  SELECT
    CASE
      WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad'
      ELSE 'Good'
    END AS category
  FROM netflix
) AS t
GROUP BY category;

SELECT * FROM netflix