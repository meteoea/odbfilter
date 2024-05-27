//
//-- ODB/SQL file 'select_wind_obstype_varno_tslot.sql'
//
//

UPDATED;

SET $otype = 0;
SET $vno_u = 0;
SET $vno_v = 0;
SET $tslot = 0;

CREATE VIEW select_wind_obstype_varno_tslot AS   
  SELECT obsvalue,datum_status.active UPDATED,             // r/o
  FROM   hdr, body, index
  WHERE  obstype=$otype and varno in ($vno_u , $vno_v) and timeslot=$tslot order by statid,lat,lon,date,time
;
