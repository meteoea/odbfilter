//
//-- ODB/SQL file 'select_onsobs_gpssol.sql'
//
//

UPDATED;

SET $otype = 0;
SET $ctype = 0;
SET $lon = 0;
SET $lat = 0;

CREATE VIEW select_oneobs_gpssol AS   
  SELECT obsvalue,datum_status.active UPDATED,             // r/o
  FROM   hdr, body
  WHERE  datum_status.passive=0 and obstype=$otype and codetype=$ctype and lon>$lon-0.001 and lon<$lon+0.001 and lat>$lat-0.001 and lat<$lat+0.001
;
