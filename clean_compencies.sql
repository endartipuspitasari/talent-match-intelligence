-- Untuk numeric columns, NULL adalah satu-satunya "blank"
DELETE FROM competencies_yearly 
WHERE score IS NULL 
   OR score::numeric NOT BETWEEN 1 AND 5;  -- langsung numeric comparison
   