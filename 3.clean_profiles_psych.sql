DELETE FROM profiles_psych 
WHERE employee_id IS NULL
   OR iq IS NULL
   OR pauli IS NULL
   OR faxtor IS NULL
   OR mbti IS NULL
   OR disc IS NULL;
   
