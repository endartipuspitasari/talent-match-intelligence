-- HAPUS hanya data yang benar-benar invalid
delete from performance_yearly
where
  rating is null
  or rating not between 1 and 5;

-- Ini akan hapus 0, 6, 99, tapi SAVE 1-5
