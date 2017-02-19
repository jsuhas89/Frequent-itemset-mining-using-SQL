CREATE OR REPLACE FUNCTION public.frequent_itemset_mining()
  RETURNS void AS
$BODY$
BEGIN
perform support_phase();
perform candidate_phase_1();
perform support_phase();
perform candidate_phase_2();
perform support_phase();
--perform candidate_phase_3();
--perform support_phase();
delete from c;
insert into c values(gen_random_uuid(), 1, 'A');
insert into c values(gen_random_uuid(), 1, 'B');
insert into c values(gen_random_uuid(), 1, 'C');
insert into c values(gen_random_uuid(), 1, 'D');
insert into c values(gen_random_uuid(), 1, 'E');
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.frequent_itemset_mining()
  OWNER TO postgres;