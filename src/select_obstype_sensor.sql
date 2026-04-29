//
//-- ODB/SQL file 'select_obstype_sensor.sql'
//
//

UPDATED;

SET $otype = 0;
SET $vno = 0;

CREATE VIEW select_obstype_sensor AS   
  SELECT obsvalue,datum_status.active UPDATED,             // r/o
  FROM   hdr, body
  WHERE  obstype=$otype and sensor=$vno
;
