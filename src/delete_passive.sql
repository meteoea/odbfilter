//
//-- ODB/SQL file 'delete_passive.sql'
//
//

UPDATED;

CREATE VIEW delete_passive AS
  SELECT datum_status.active UPDATED,             // r/o
  FROM hdr,body 
  WHERE datum_status.passive = 1
;
