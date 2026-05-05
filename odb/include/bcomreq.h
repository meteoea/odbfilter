      INTEGER NREQ,NRQL,NRQ
      REAL    RQVAL
      COMMON /BCOMREQI/ NREQ(2),NRQL,NRQ(JELEM)
      COMMON /BCOMREQR/ RQVAL(JELEM)
C
C             *NREQ*    -  FLAG
C                          BIT NUMBER     MEANING
C
C                              1        - 0 NO BIT MAP DELIVERED TO USER
C                                         1    BIT MAP DELIVERED TO USER
C                              2        - 0 NO PARTIAL EXPANSION
C                                         1    PARTIAL EXPANSION
C                              3        - 0 NO Q/C REQUIRED
C                                       - 1    Q/C REQUIRED
C                              4        - 0 NO STATISTICS REQUIRED
C                                       - 1    STATISTICS
C                              5        - 0 NO DIFFRENCE STATISTICS
C                                       - 1    DIFFERENCE STATISTICS
C                              6        - 0 NO SUBSTITUTED VALUES
C                                       - 1    SUBSTITUTED VALUES
C             *NRQL*    -  NUMBER OF REQUESTED ELEMENTS
C             *NRQ*     -  LIST OF REQUESTED TABLE B REFERENCE
C             *RQVAL*   -  LIST OF VALUES SIGNIFYING REQUESTED ELEMENT
C                          (SAY PRESSURE  AT 50000 PA)
C
C
