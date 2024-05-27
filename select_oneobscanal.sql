//
//-- ODB/SQL file 'select_oneobscanal.sql'
//
//

UPDATED;

SET $otype = 0;
SET $vertco = 0;

CREATE VIEW select_oneobscanal AS   
  SELECT obsvalue,datum_status.active UPDATED,             // r/o
  FROM   hdr, body
  WHERE  obstype=$otype and vertco_reference_1=$vertco and fg_depar@body>3 
;
