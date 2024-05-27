//
//-- ODB/SQL file 'select_obstype.sql'
//
//

UPDATED;

SET $otype = 0;

CREATE VIEW select_obstype AS   
  SELECT obsvalue,datum_status.active UPDATED,             // r/o
  FROM   hdr, body
  WHERE  obstype=$otype
;
