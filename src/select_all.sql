//
//-- ODB/SQL file 'select_all.sql'
//
//

UPDATED;

CREATE VIEW select_all AS   
  SELECT obsvalue,datum_status.active UPDATED,             // r/o
  FROM   hdr, body
;
