WITH elite_group AS (
    -- 🏆 TRUE ELITE: Konsisten high performer minimal 3 tahun
    SELECT employee_id
    FROM performance_yearly
    WHERE rating = 5
    GROUP BY employee_id
    HAVING COUNT(*) >= 3
),
performance_cohorts AS (
    -- 🎯 STRATEGIC GROUPING: Elite vs Others
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
        AND p.year = 2024  -- ✅ CONFIRMED BEST YEAR
)
SELECT 
    pc.performance_group,
    COUNT(DISTINCT pc.employee_id) as employee_count,
    
    -- 🧠 COGNITIVE ABILITIES (Apakah elite lebih pintar?)
    ROUND(AVG(pp.iq)::numeric, 2) as avg_iq,
    ROUND(AVG(pp.pauli)::numeric, 2) as avg_pauli,
    ROUND(AVG(pp.faxtor)::numeric, 2) as avg_faxtor,
    
    -- 💼 COMPETENCIES (Apakah elite lebih kompeten?)
    ROUND(AVG(cy.score::numeric)::numeric, 2) as avg_competency_score,
    
    -- 🌟 BEHAVIORAL STRENGTHS (Apakah elite punya strengths berbeda?)
    COUNT(DISTINCT s.theme) as avg_strengths_count,
    
    -- ⏳ EXPERIENCE (Apakah elite lebih berpengalaman?)
    ROUND(AVG(e.years_of_service_months)::numeric, 2) as avg_tenure_months,
    
    -- 🎓 EDUCATION (Apakah elite lebih berpendidikan?)
    MODE() WITHIN GROUP (ORDER BY ed.name) as common_education,
    
    -- 🔮 PSYCHOMETRIC PROFILES (Apakah elite punya personality berbeda?)
    MODE() WITHIN GROUP (ORDER BY pp.disc) as common_disc,
    MODE() WITHIN GROUP (ORDER BY pp.mbti) as common_mbti

FROM performance_cohorts pc
LEFT JOIN employees e ON pc.employee_id = e.employee_id
LEFT JOIN profiles_psych pp ON pc.employee_id = pp.employee_id
LEFT JOIN competencies_yearly cy ON pc.employee_id = cy.employee_id AND cy.year = 2024
LEFT JOIN strengths s ON pc.employee_id = s.employee_id
LEFT JOIN dim_education ed ON e.education_id = ed.education_id
WHERE pc.performance_group IS NOT NULL
GROUP BY pc.performance_group
ORDER BY 
    CASE pc.performance_group
        WHEN 'Elite Performer' THEN 1
        WHEN 'Single Year High Performer' THEN 2
        WHEN 'Average Performer' THEN 3
        WHEN 'Low Performer' THEN 4
    END;
