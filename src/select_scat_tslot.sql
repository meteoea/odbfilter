//
//-- ODB/SQL file 'select_scat_tslot.sql'
//
//

UPDATED;

SET $tslot = 0;

CREATE VIEW select_scat_tslot AS   
  SELECT obsvalue,datum_status.active,seqno UPDATED,             // r/o
  FROM   hdr, body, index
  WHERE  obstype=9 
    AND  varno IN (124 , 125) 
    AND  timeslot=$tslot ORDER BY seqno
;

