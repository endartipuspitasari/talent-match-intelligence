-- Hapus baris yang ada null values
DELETE FROM papi_scores 
WHERE employee_id IS NULL
   OR scale_code IS NULL
   OR score IS NULL;
   