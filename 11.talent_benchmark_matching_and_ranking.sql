-- MODULAR SQL MATCHING ALGORITHM
WITH benchmark_employees AS (
    SELECT UNNEST(selected_talent_ids) as employee_id
    FROM talent_benchmarks
    WHERE job_vacancy_id = 1  -- Pakai benchmark pertama
),
benchmark_baselines AS (
    -- Calculate benchmark averages dari elite performers
    SELECT 
        AVG(pp.pauli) as benchmark_pauli,
        AVG(pp.faxtor) as benchmark_faxtor,
        AVG(e.years_of_service_months) as benchmark_tenure,
        MODE() WITHIN GROUP (ORDER BY pp.disc) as benchmark_disc,
        MODE() WITHIN GROUP (ORDER BY pp.mbti) as benchmark_mbti
    FROM benchmark_employees be
    JOIN employees e ON be.employee_id = e.employee_id
    JOIN profiles_psych pp ON be.employee_id = pp.employee_id
),
tv_match_rates AS (
    -- Calculate match rates untuk setiap Talent Variable
    SELECT 
        e.employee_id,
        
        -- Pauli Match Rate (Higher is better)
        CASE 
            WHEN pp.pauli IS NOT NULL AND bb.benchmark_pauli > 0 
            THEN (pp.pauli / bb.benchmark_pauli) * 100
            ELSE 0 
        END as pauli_match_rate,
        
        -- Faxtor Match Rate (LOWER is better - INVERTED)
        CASE 
            WHEN pp.faxtor IS NOT NULL AND bb.benchmark_faxtor > 0
            THEN ((2 * bb.benchmark_faxtor - pp.faxtor) / bb.benchmark_faxtor) * 100
            ELSE 0
        END as faxtor_match_rate,
        
        -- Tenure Match Rate
        CASE 
            WHEN e.years_of_service_months IS NOT NULL AND bb.benchmark_tenure > 0
            THEN (e.years_of_service_months / bb.benchmark_tenure) * 100
            ELSE 0
        END as tenure_match_rate,
        
        -- DISC Match Rate (Exact match = 100%, No match = 0%)
        CASE 
            WHEN pp.disc = bb.benchmark_disc THEN 100
            ELSE 0
        END as disc_match_rate,
        
        -- MBTI Match Rate
        CASE 
            WHEN pp.mbti = bb.benchmark_mbti THEN 100
            ELSE 0
        END as mbti_match_rate
        
    FROM employees e
    CROSS JOIN benchmark_baselines bb
    LEFT JOIN profiles_psych pp ON e.employee_id = pp.employee_id
    WHERE e.employee_id NOT IN (SELECT employee_id FROM benchmark_employees)  -- Exclude benchmarks
),
final_match_scores AS (
    -- Apply weights dan calculate final score
    SELECT 
        employee_id,
        -- Apply weights dari Success Formula
        (pauli_match_rate * 0.25) +
        (faxtor_match_rate * 0.20) + 
        (tenure_match_rate * 0.20) +
        (disc_match_rate * 0.075) +  -- 7.5% untuk DISC
        (mbti_match_rate * 0.075)    -- 7.5% untuk MBTI
        as final_match_rate,
        
        -- Individual components untuk analysis
        pauli_match_rate,
        faxtor_match_rate, 
        tenure_match_rate,
        disc_match_rate,
        mbti_match_rate
        
    FROM tv_match_rates
)
-- FINAL OUTPUT: Ranked Talent List
SELECT 
    e.employee_id,
    e.fullname,
    d.name as directorate,
    p.name as position,
    g.name as grade,
    ROUND(fms.final_match_rate, 2) as match_score,
    ROUND(fms.pauli_match_rate, 2) as pauli_score,
    ROUND(fms.faxtor_match_rate, 2) as faxtor_score,
    ROUND(fms.tenure_match_rate, 2) as tenure_score,
    pp.disc,
    pp.mbti
FROM final_match_scores fms
JOIN employees e ON fms.employee_id = e.employee_id
LEFT JOIN dim_directorates d ON e.directorate_id = d.directorate_id
LEFT JOIN dim_positions p ON e.position_id = p.position_id
LEFT JOIN dim_grades g ON e.grade_id = g.grade_id
LEFT JOIN profiles_psych pp ON e.employee_id = pp.employee_id
ORDER BY match_score DESC
LIMIT 20;  -- Top 20 matches
