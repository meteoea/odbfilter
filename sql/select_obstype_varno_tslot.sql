//
//-- ODB/SQL file 'select_obstype_varno_tslot.sql'
//
//

UPDATED;

SET $otype = 0;
SET $vno = 0;

CREATE VIEW select_obstype_varno_tslot AS   
  SELECT obsvalue,datum_status.active UPDATED,             // r/o
  FROM   hdr, body,index
  WHERE  obstype=$otype and varno=$vno
;
