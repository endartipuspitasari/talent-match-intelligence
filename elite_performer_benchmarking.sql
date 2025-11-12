-- Steps2: Find elite performers for benchmarking
SELECT employee_id, fullname 
FROM employees 
WHERE employee_id IN (
    SELECT employee_id 
    FROM performance_yearly 
    WHERE rating = 5 
    GROUP BY employee_id 
    HAVING COUNT(*) >= 3
) LIMIT 5;