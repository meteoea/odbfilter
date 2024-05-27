//
//-- ODB/SQL file 'copy_fg_depar.sql'
//
//

UPDATED;


CREATE VIEW copy_fg_depar AS   
  SELECT fg_depar,hires UPDATED,             // r/o
  FROM   hdr, body, update_1
;
