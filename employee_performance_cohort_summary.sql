WITH elite_group AS (
    SELECT employee_id
    FROM performance_yearly
    WHERE rating = 5
    GROUP BY employee_id
    HAVING COUNT(*) >= 3  -- Elite: konsisten 3+ tahun
),
performance_cohorts AS (
    SELECT 
        e.employee_id,
        CASE 
            WHEN eg.employee_id IS NOT NULL THEN 'Elite Performer'
            WHEN p.rating = 5 THEN 'Single Year High Performer'
            WHEN p.rating <= 2 THEN 'Low Performer' 
            ELSE 'Average Performer'
        END as performance_group
    FROM employees e
    LEFT JOIN elite_group eg ON e.employee_id = eg.employee_id
    LEFT JOIN performance_yearly p ON e.employee_id = p.employee_id 
        AND p.year = 2024  -- ✅ CONFIRMED: 2024 YEAR OF CHOICE
)
SELECT 
    pc.performance_group,
    COUNT(DISTINCT pc.employee_id) as employee_count,
    
    -- Cognitive Abilities
    ROUND(AVG(pp.iq)::numeric, 2) as avg_iq,
    ROUND(AVG(pp.pauli)::numeric, 2) as avg_pauli,
    ROUND(AVG(pp.faxtor)::numeric, 2) as avg_faxtor,
    
    -- Competencies
    ROUND(AVG(cy.score::numeric)::numeric, 2) as avg_competency_score,
    
    -- Behavioral (Strengths)
    COUNT(DISTINCT s.theme) as avg_strengths_count,
    
    -- Experience & Demographics
    ROUND(AVG(e.years_of_service_months)::numeric, 2) as avg_tenure_months

FROM performance_cohorts pc
LEFT JOIN employees e ON pc.employee_id = e.employee_id
LEFT JOIN profiles_psych pp ON pc.employee_id = pp.employee_id
LEFT JOIN competencies_yearly cy ON pc.employee_id = cy.employee_id AND cy.year = 2024
LEFT JOIN strengths s ON pc.employee_id = s.employee_id
WHERE pc.performance_group IS NOT NULL
GROUP BY pc.performance_group
ORDER BY 
    CASE pc.performance_group
        WHEN 'Elite Performer' THEN 1
        WHEN 'Single Year High Performer' THEN 2
        WHEN 'Average Performer' THEN 3
        WHEN 'Low Performer' THEN 4
    END;