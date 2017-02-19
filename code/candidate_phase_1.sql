CREATE OR REPLACE FUNCTION public.candidate_phase_1()
  RETURNS void AS
$BODY$
DECLARE
k integer;
BEGIN
k := 2;
DELETE FROM PP;
INSERT INTO PP (itemset_old1, itemset_old2, itemset_new)
SELECT itemset1, itemset2, gen_random_uuid()
FROM (
SELECT DISTINCT a1.itemsetID AS itemset1, a2.itemsetID AS itemset2
FROM F AS a1, F AS a2
WHERE NOT EXISTS (
SELECT * FROM F AS b1, F AS b2
WHERE ((b1.itemsetID = a1.itemsetID) AND
(b2.itemsetID = a2.itemsetID) AND
(b1.pos < k-1) AND
(b1.pos = b2.pos)) AND
NOT (b2.item = b1.item)
) AND
EXISTS (
SELECT b1.item, b2.item
FROM F AS b1, F AS b2
WHERE (b1.itemsetID = a1.itemsetID) AND
(b2.itemsetID = a2.itemsetID) AND
(b1.pos = k-1) AND
(b1.pos = b2.pos) AND
(b1.item < b2.item)
)
AND
-- Skip item at position p = 1.
EXISTS (
SELECT a3.itemsetID
FROM F AS a3
WHERE NOT EXISTS (
SELECT b1.item, b2.item
FROM F AS b1, F AS b2
WHERE NOT (
-- Condition 1: 1 <= i < p
( NOT (
(b1.itemsetID = a1.itemsetID) AND
(b2.itemsetID = a3.itemsetID) AND
(1 <= b2.pos) AND (b2.pos < 1) AND
(b1.pos = b2.pos)
) OR
(b1.item = b2.item)
) AND
-- Condition 2: p <= i < k-1
( NOT (
(b1.itemsetID = a1.itemsetID) AND
(b2.itemsetID = a3.itemsetID) AND
(1 <= b2.pos) AND (b2.pos < k-1) AND
(b1.pos = b2.pos + 1)
) OR
(b1.item = b2.item)
) AND
-- Condition 3: i = k-1
( NOT (
(b1.itemsetID = a2.itemsetID) AND
(b2.itemsetID = a3.itemsetID) AND
(b2.pos = k-1) AND
(b1.pos = b2.pos)
) OR
(b1.item = b2.item)
)
)
)
)
) AS tmp;

DELETE FROM C;
INSERT INTO C (itemsetID, pos, item)
SELECT p.itemset_new, f.pos, f.item
FROM F AS f, PP AS p
WHERE f.itemsetID = p.itemset_old1
UNION
SELECT p.itemset_new, k, f.item
FROM F AS f, PP AS p
WHERE f.itemsetID = p.itemset_old2 AND
f.pos = k-1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.candidate_phase_1()
  OWNER TO postgres;