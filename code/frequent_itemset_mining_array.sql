CREATE OR REPLACE FUNCTION public.frequent_itemset_mining_array()
  RETURNS void AS
$BODY$
BEGIN
perform support_phase_array();
perform candidate_phase_1();
perform support_phase_array();
perform candidate_phase_2();
perform support_phase_array();
--perform candidate_phase_3();
--perform support_phase();
DROP TABLE IF EXISTS F_Final;
CREATE TABLE F_Final AS select distinct a.itemsetid, (select array(select b.item from f b
where b.itemsetid = a.itemsetid))as items from f a;
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
ALTER FUNCTION public.frequent_itemset_mining_array()
  OWNER TO postgres;