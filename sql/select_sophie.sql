//
//-- ODB/SQL file 'select_sophie.sql'
//
//

UPDATED;

SET $otype = 0;

CREATE VIEW select_sophie AS   
  SELECT obsvalue,datum_status.active UPDATED,             // r/o
  FROM   hdr, body
  WHERE  obstype=1 and (varno=58 or varno=39)
;
