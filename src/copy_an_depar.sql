//
//-- ODB/SQL file 'copy_an_depar.sql'
//
//

UPDATED;


CREATE VIEW copy_an_depar AS   
  SELECT an_depar,hires UPDATED,             // r/o
  FROM   hdr, body, update_2
;
