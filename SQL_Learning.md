```
SELECT Title FROM movies;
```
```
SELECT title, director FROM movies;
```
```
SELECT * FROM Movies;
```
```
SELECT * FROM movies
WHERE id = 6;
```
```
SELECT * FROM movies
WHERE year
BETWEEN 2000 AND 2010;
```
```
SELECT * FROM movies
WHERE year
NOT BETWEEN 2000 AND 2010;
```

```
SELECT * FROM movies
WHERE id <=5;
```
```
SELECT * FROM movies
WHERE title LIKE "%toy%";
```
```
SELECT * FROM movies
WHERE director NOT LIKE "%john%";
```
```
SELECT * FROM movies
WHERE title LIKE "WALL-_";
```
```
SELECT DISTINCT director FROM movies
ORDER BY director ASC;
```
```
SELECT tile FROM movies
ORDER BY year DSEC
LIMIT 4;
```
```
SELECT tile FROM movies
ORDER BY title ASC
LIMIT 5 OFFSET 5;
```
