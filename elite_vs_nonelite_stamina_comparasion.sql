-- Bandingkan ELITE vs OTHER HIGH STAMINA employees
WITH high_stamina_employees AS (
    SELECT pp.employee_id
    FROM profiles_psych pp
    WHERE pp.pauli >= 70
),
elite_vs_other_stamina AS (
    SELECT 
        CASE 
            WHEN eg.employee_id IS NOT NULL THEN 'Elite High Stamina'
            ELSE 'Non-Elite High Stamina'
        END as group_type,
        COUNT(DISTINCT hse.employee_id) as employee_count,
        -- Cognitive
        AVG(pp.iq) as avg_iq,
        AVG(pp.pauli) as avg_pauli,
        AVG(pp.faxtor) as avg_faxtor,
        -- Behavioral
        MODE() WITHIN GROUP (ORDER BY pp.disc) as common_disc,
        MODE() WITHIN GROUP (ORDER BY pp.mbti) as common_mbti,
        -- Experience
        AVG(e.years_of_service_months) as avg_tenure,
        -- Performance Consistency
        COUNT(DISTINCT py.year) as avg_active_years
    FROM high_stamina_employees hse
    LEFT JOIN (
        SELECT employee_id 
        FROM performance_yearly 
        WHERE rating = 5 
        GROUP BY employee_id 
        HAVING COUNT(*) >= 3
    ) eg ON hse.employee_id = eg.employee_id
    LEFT JOIN profiles_psych pp ON hse.employee_id = pp.employee_id
    LEFT JOIN employees e ON hse.employee_id = e.employee_id
    LEFT JOIN performance_yearly py ON hse.employee_id = py.employee_id
    GROUP BY CASE WHEN eg.employee_id IS NOT NULL THEN 'Elite High Stamina' ELSE 'Non-Elite High Stamina' END
)
SELECT * FROM elite_vs_other_stamina;