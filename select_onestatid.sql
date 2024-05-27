//
//-- ODB/SQL file 'select_onestatid.sql'
//
//

UPDATED;

SET $statid = 0;

CREATE VIEW select_onestatid AS   
  SELECT obsvalue,datum_status.active UPDATED,             // r/o
  FROM   hdr, body, index
  WHERE  statid=$statid
;
