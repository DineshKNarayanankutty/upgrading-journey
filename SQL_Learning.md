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


employees
| emp_id | name    | department | salary | manager_id | hire_date  |
| ------ | ------- | ---------- | -----: | ---------: | ---------- |
| 1      | Alice   | IT         |  70000 |          5 | 2022-01-10 |
| 2      | Bob     | HR         |  50000 |          6 | 2021-03-15 |
| 3      | Charlie | IT         |  80000 |          5 | 2020-06-20 |
| 4      | David   | Finance    |  60000 |          7 | 2023-02-11 |
| 5      | Eve     | IT         | 100000 |       NULL | 2018-08-01 |
| 6      | Frank   | HR         |  90000 |       NULL | 2017-09-12 |
| 7      | Grace   | Finance    |  95000 |       NULL | 2016-05-30 |
| 8      | Helen   | IT         |  75000 |          5 | 2024-01-18 |

projects
| project_id | project_name      | department | budget |
| ---------- | ----------------- | ---------- | -----: |
| 101        | AI Platform       | IT         | 500000 |
| 102        | HR Portal         | HR         | 150000 |
| 103        | Finance Dashboard | Finance    | 300000 |
| 104        | Cloud Migration   | IT         | 700000 |

Q1. (Easy)

Display the names and salaries of all employees.

```
SELECT name, salary 
FROM employees;
```

Q2. (Easy)

Find all employees whose salary is greater than 75,000.

```
SELECT name, salary 
FROM employees
WHERE salary > 75000;
```

Q3. (Easy)

Display all employees sorted by salary in descending order.

```
SELECT name, salary
FROM employees
ORDER BY salary DESC;
```

Q4. (Easy-Medium)

Find the total number of employees in each department.

```
SELECT department, COUNT(*) AS Total_number_of_employees 
FROM employees
GROUP BY department;
```

Q5. (Medium)

Find departments whose average salary is greater than 80,000.

```
SELECT department, AVG(salary) AS Average_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 80000;
```

Q6. (Medium)

Display each employee's name, department, and their project name.

```
SELECT employees.name,
       employees.department,
       projects.project_name
FROM employees
JOIN projects
ON employees.department = projects.department;
```

Q7. (Medium)

Find employees who earn more than the average salary of all employees.

```
SELECT name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);
```

Q8. (Hard)

Find the second highest salary.

```
SELECT name, salary
FROM employees
WHERE salary = (
    SELECT MAX(salary)
    FROM employees
    WHERE salary < (
        SELECT MAX(salary)
        FROM employees
    )
);
```
