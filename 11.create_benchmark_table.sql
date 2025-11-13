-- Steps1
CREATE TABLE IF NOT EXISTS talent_benchmarks (
    job_vacancy_id SERIAL PRIMARY KEY,
    role_name TEXT NOT NULL,
    job_level TEXT,
    role_purpose TEXT,
    selected_talent_ids INTEGER[],
    weights_config JSONB,
    created_at TIMESTAMP DEFAULT NOW()
);
