//
//-- ODB/SQL file 'select_oneobs_radar.sql'
//
//

UPDATED;

SET $otype = 0;
SET $vno = 0;
SET $ident = 0;
SET $distance = 0;
SET $elev = 0;
SET $azimut = 0;

CREATE VIEW select_oneobs_radar AS   
  SELECT obsvalue,datum_status.active UPDATED,             // r/o
  FROM   hdr, body, radar_body, radar_station, index
  WHERE  obstype=$otype and varno=$vno and ident=$ident and distance>$distance-0.01 and distance<$distance+0.01 and elevation>$elev-0.01 and  elevation<$elev+0.01 and azimuth>$azimut-0.01 and azimuth<$azimut+0.01
;
