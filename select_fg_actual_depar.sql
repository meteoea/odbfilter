//
//-- ODB/SQL file 'select_fg_actual_depar.sql'
//
//

UPDATED;

CREATE VIEW select_fg_actual_depar AS   
  SELECT fg_depar,actual_depar UPDATED,             // r/o
  FROM   body
;
