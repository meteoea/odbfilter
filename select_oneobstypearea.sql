//
//-- ODB/SQL file 'select_oneobstypearea.sql'
//
//

UPDATED;

SET $otype = 0;
SET $varno = 0;
SET $lonmin = 0;
SET $lonmax = 0;
SET $latmin = 0;
SET $latmax = 0;
SET $presmin = 0;
SET $presmax = 0;

CREATE VIEW select_oneobstypearea AS   
  SELECT obsvalue,datum_status.active UPDATED,             // r/o
  FROM   hdr, body, index
  WHERE  obstype=$otype and varno=$varno and lon@hdr>$lonmin and lon@hdr<$lonmax and lat@hdr>$latmin and lat@hdr<$latmax and vertco_reference_1>$presmin and vertco_reference_1<$presmax
;

