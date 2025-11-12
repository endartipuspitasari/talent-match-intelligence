-- STEP 1: Strategic Decision Making
SELECT 
    year,
    COUNT(*) as total_employees,
    AVG(rating) as avg_rating,
    COUNT(CASE WHEN rating = 5 THEN 1 END) as high_performers
FROM performance_yearly
GROUP BY year
ORDER BY year;
