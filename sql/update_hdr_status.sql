//
//-- ODB/SQL file 'update_hdr_status.sql'
//
//

UPDATED;

CREATE VIEW update_hdr_status AS   
  SELECT report_status.active UPDATED,             // r/o
  FROM   hdr, body
  WHERE  datum_status.active=1
;
