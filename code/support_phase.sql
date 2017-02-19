CREATE OR REPLACE FUNCTION public.support_phase()
  RETURNS void AS
$BODY$
DECLARE
minimum_support integer;
BEGIN
minimum_support := 2;
DELETE FROM F;
INSERT
INTO F (itemsetID, pos, item)
SELECT c.itemsetID, c.pos, c.item
FROM C AS c, (SELECT itemsetID, COUNT(DISTINCT tid) AS support
FROM (
SELECT c1.itemsetID, t1.tid
FROM C AS c1, T AS t1
WHERE NOT EXISTS (
SELECT *
FROM C AS c2
WHERE NOT EXISTS (
SELECT *
FROM T AS t2
WHERE NOT (c1.itemsetID = c2.itemsetID) OR
(t2.tid = t1.tid AND
t2.item = c2.item)))
) AS Contains
GROUP BY itemsetID
HAVING COUNT(DISTINCT tid) >= minimum_support) AS s
WHERE c.itemsetID = s.itemsetID;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.support_phase()
  OWNER TO postgres;