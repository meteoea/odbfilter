//
//-- ODB/SQL file 'select_timeslot.sql'
//
//

UPDATED;

SET $tslot = 0;

CREATE VIEW select_timeslot AS   
  SELECT obsvalue,datum_status.active UPDATED,             // r/o
  FROM   hdr, body, index
  WHERE  timeslot=$tslot
;
