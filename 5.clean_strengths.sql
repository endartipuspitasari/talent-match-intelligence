-- Hapus baris yang ada null/empty values
DELETE FROM strengths 
WHERE employee_id IS NULL
   OR rank IS NULL
   OR theme IS NULL 
   OR theme = '';
   
