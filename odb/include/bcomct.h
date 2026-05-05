      INTEGER        NREF   ,NSTART ,NLEN,
     1               NCODNUM,NSTARTC,
     2               NLENC
      COMMON /BCOMCT/ NREF(JCTAB)   ,NSTART(JCTAB) ,NLEN(JCTAB),
     1               NCODNUM(JCTST),NSTARTC(JCTST),
     2               NLENC(JCTST)
C
C             NREF      - TABLE C REFERENCE
C             NSTART    - STARTING POINTERS TO ARRAY NCODNUM
C             NLEN      - LENGTHS
C             NCODNUM   - CODE/FLAG TABLE NUMBER
C             NSTARTC   - STARTING POINTERS TO ARRAY CTEXT
C             NLENC     - LENGTHS
