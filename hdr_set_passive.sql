//
//-- ODB/SQL file 'hdr_set_passive.sql'
//
//

UPDATED;

CREATE VIEW hdr_set_passive AS   
  SELECT report_status.active UPDATED,             // r/o
  FROM   hdr
;
