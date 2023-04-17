USE seminar3;

SELECT * FROM staff ORDER BY salary;

SELECT * FROM staff ORDER BY salary DESC;

SELECT salary FROM staff
ORDER BY salary DESC
LIMIT 5;

SELECT COUNT(id) AS worker_count
FROM staff
WHERE post = "Рабочий" AND age > 24 AND age <= 49;

SELECT COUNT(DISTINCT post) AS post_count
FROM staff;

SELECT post FROM staff
GROUP BY post
HAVING AVG(age) < 30;

SELECT post, SUM(salary) AS salary_counter
FROM staff
GROUP BY post;
