//
//-- ODB/SQL file 'select_for_debug.sql'
//
//

UPDATED;

CREATE VIEW select_for_debug AS   
  SELECT hires@update_2,datum_status.active UPDATED,             // r/o
  FROM   hdr, body,update_2
;
