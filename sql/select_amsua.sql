//
//-- ODB/SQL file 'select_amsua.sql'
//
//

UPDATED;

CREATE VIEW select_amsua AS   
  SELECT obsvalue,datum_status.active UPDATED,             // r/o
  FROM   hdr, body, index
  WHERE  obstype=7 and varno=119 and sensor=3 
    and vertco_reference_1=13 and degrees(lat) > 10.0
;
