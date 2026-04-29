//
//-- ODB/SQL file 'select_obstype_wind.sql'
//
//

UPDATED;

SET $otype = 0;
SET $vno_u = 0;
SET $vno_v = 0;
SET $tslot = 0;

CREATE VIEW select_obstype_wind AS   
  SELECT obsvalue,datum_status.active UPDATED,             // r/o
  FROM   hdr, body, timeslot_index
  WHERE  obstype=$otype 
    AND timeslot=$tslot 
    AND vertco_reference_1 > 98000.0
    AND vertco_reference_1 < 102700.0
    AND varno in ($vno_u , $vno_v)
;
