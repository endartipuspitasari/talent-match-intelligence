-- RUN INI: Ubah column type ke TEXT[]
ALTER TABLE talent_benchmarks 
ALTER COLUMN selected_talent_ids TYPE TEXT[];

-- RUN INI: Cek table structure setelah di-ubah
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'talent_benchmarks' 
AND column_name = 'selected_talent_ids';

-- RUN INI: Insert benchmark data (SAMA dengan sebelumnya)
INSERT INTO talent_benchmarks (
    role_name, 
    job_level, 
    role_purpose, 
    selected_talent_ids,
    weights_config
) VALUES (
    'Data Analyst',
    'Senior', 
    'Turn business questions into data-driven insights and build analytical solutions',
    ARRAY['EMP100418', 'EMP100758', 'EMP100350'],
    '{"pauli": 0.25, "faxtor": 0.20, "tenure": 0.20, "disc": 0.075, "mbti": 0.075}'
);

-- Cek data yang sudah di-insert
SELECT * FROM talent_benchmarks;