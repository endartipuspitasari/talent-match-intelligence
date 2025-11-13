-- Apa yang correlated dengan high Pauli scores?
SELECT 
    CASE 
        WHEN pauli >= 70 THEN 'High Stamina'
        WHEN pauli BETWEEN 60 AND 69 THEN 'Medium Stamina' 
        ELSE 'Low Stamina'
    END as stamina_group,
    COUNT(*) as employee_count,
    AVG(iq) as avg_iq,
    AVG(years_of_service_months) as avg_tenure,
    AVG(faxtor) as avg_faxtor
FROM profiles_psych pp
JOIN employees e ON pp.employee_id = e.employee_id
GROUP BY stamina_group
ORDER BY avg_tenure DESC;
