//
//-- ODB/SQL file 'select_obstype_varno.sql'
//
//

UPDATED;

SET $otype = 0;
SET $vno = 0;

CREATE VIEW select_obstype_varno AS   
  SELECT obsvalue,datum_status.active UPDATED,             // r/o
  FROM   hdr, body
  WHERE  obstype=$otype and varno=$vno
;
