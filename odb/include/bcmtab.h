      INTEGER         NTABBTR,NTABBS ,NTABBRV,
     1                NTABBDW,NTABDTR,NTABDST,
     2                NTABDL ,NTABDSQ,NTABP
      COMMON /BCMTAB/ NTABBTR(JTAB),NTABBS (JTAB),NTABBRV(JTAB),
     1                NTABBDW(JTAB),NTABDTR(JTAB),NTABDST(JTAB),
     2                NTABDL (JTAB),NTABDSQ(JTAB*20),NTABP(64,255)
C
C             NTABBTR    - TABLE B,  TABLE REFERENCE              ARRAY
C             NTABBS     - TABLE B,  SCALE                        ARRAY
C             NTABBRF    - TABLE B,  REFERENCE VALUE              ARRAY
C             NTABBDW    - TABLE B,  DATA WIDTH                   ARRAY
C             NTABDTR    - TABLE D,  TABLE REFERENCE              ARRAY
C             NTABDST    - TABLE D,  STARTING POINTERS            ARRAY
C             NTABDL     - TABLE D,  LENGTHS                      ARRAY
C             NTABDSQ    - TABLE D,  LIST OF SEQUENCE DESCRIPTORS ARRAY
C
C
