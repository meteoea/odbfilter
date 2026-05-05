
!*    STATEMENT FUNCTIONS

!        JAN HASELER     ECMWF     19/3/92

!***********************************************************************

!     THIS IS WHAT WE USED
!     IBITS(KVAR,KBP,KOCC) = AND(SHIFTR(KVAR,KBP),KOCC)

!     EXTRACT KOCC BITS FROM KVAR, STARTING AT BIT KBP

!     NOW WE USING IBITS FUNCTION FOR LIB.

!***********************************************************************

!     THIS IS WHAT WE USED
!     INSERT(KVAR,KVAL,KBP) = KVAR .OR. SHIFTL(KVAL,KBP)

!     INSERT KVAL INTO KVAR AT BIT KBP

!     WE CHANGED SHIFTL T0 ISHFT AND .OR. TO IOR

!***********************************************************************

!     THIS IS WHAT WE USED
!     ISET0(KVAR,KBP) = KVAR .AND. COMPL( SHIFTL( 1B,KBP))

!     SET 0 INTO BIT POSITION KBP

!     NOW WE ARE GOING TO USE IBCLR

!***********************************************************************
!     ICN2FL(PCONF) = MIN(3, (92 - MIN(92, INT(PCONF+EPSMAC)))/23 )

!     CONVERT CONFIDENCE LEVEL PCONF TO FLAG VALUE
!     WHERE FLAG = 0 FOR 100 >= PCONF > 69
!           FLAG = 1 FOR  69 >= PCONF > 46
!           FLAG = 2 FOR  45 >= PCONF > 23
!           FLAG = 3 FOR  23 >= PCONF
!***********************************************************************
!     WIND COMPONENTS

!     UCOM(PDD,PFF)= -PFF * SIN(PDD*RADIANS)
!     VCOM(PDD,PFF)= -PFF * COS(PDD*RADIANS)
!***********************************************************************
!     RELATIVE HUMIDITY

!     SVP(PC1,PC3,PC4,PT,PTMELT)=PC1*EXP(PC3*(PT-PTMELT)/(PT-PC4))
!***********************************************************************

!     IBITS(KVAR,KBP,KOCC)  = AND(SHIFTR(KVAR,KBP),KOCC)
!     INSERT(KVAR,KVAL,KBP) = KVAR .OR. SHIFTL(KVAL,KBP)
INTEGER(KIND=JPIM) :: INSERT
INSERT(KVAR,KVAL,KBP) = IOR(KVAR,ISHFT(KVAL,KBP))
!     ISET0(KVAR,KBP) = KVAR .AND. COMPL( SHIFTL( 1B,KBP))
INTEGER(KIND=JPIM) :: ICN2FL
ICN2FL(PCONF) = MIN(3, (92 - MIN(92, INT(PCONF+EPSMAC)))/23 )
REAL(KIND=JPRD) :: UCOM
UCOM(PDD,PFF)= -PFF * SIN(PDD*RADIANS)
REAL(KIND=JPRD) :: VCOM
VCOM(PDD,PFF)= -PFF * COS(PDD*RADIANS)

REAL(KIND=JPRD) :: FOEALFA
FOEALFA (PTARG) = MIN(1.0_JPRD,((MAX(RTICE,MIN(RTWAT,PTARG))-RTICE)&
 &/(RTWAT-RTICE))**2)



REAL(KIND=JPRD) :: FOEEWM
FOEEWM ( PTARG ) = R2ES *&
     &(FOEALFA(PTARG)*EXP(R3LES*(PTARG-RTT)/(PTARG-R4LES))+&
  &(1.0_JPRD-FOEALFA(PTARG))*EXP(R3IES*(PTARG-RTT)/(PTARG-R4IES)))

REAL(KIND=JPRD) :: FOEEWMO
FOEEWMO( PTARG ) = R2ES*EXP(R3LES*(PTARG-RTT)/(PTARG-R4LES))



!-----------------------------------------------------------------------


