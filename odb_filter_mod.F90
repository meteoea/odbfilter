module odb_filter_mod
  use odb_module
  implicit none

private

public :: odb_filter_start, odb_filter_end

contains

!----------------------------------------------------------------------------
subroutine odb_filter_start(odb, filter, vars, vals, nb_obs)

  implicit none
  integer(4)                    , intent(out)   :: odb
  character(len=32)             , intent(inout) :: filter
  character(len=32), allocatable, intent(inout) :: vars(:)
  real(8), allocatable          , intent(inout) :: vals(:)
  integer(4)                    , intent(out)   :: nb_obs
  integer(4) :: npools,rc, ivar
  character(len=64) cvar

  call odb_env()
  rc = ODB_init()
  call getarg(1,filter)
  nb_obs=1

  select case (filter)   
    case ('timeslot') 
      allocate(vars(1),vals(1))
      call getarg(2,cvar)
      read(unit=cvar,fmt='(I3)') ivar
      vals(1)=real(ivar)
      vars(1)="$tslot"

    case ('type') 
      allocate(vars(1),vals(1))
      call getarg(2,cvar)
      read(unit=cvar,fmt='(I3)') ivar
      vals(1)=real(ivar)
      vars(1)="$otype"
    case ('deletetype') 
      allocate(vars(1),vals(1))
      call getarg(2,cvar)
      read(unit=cvar,fmt='(I3)') ivar
      vals(1)=real(ivar)
      vars(1)="$otype"

    case ('varno')
      allocate(vars(2),vals(2))
      call getarg(2,cvar)
      read(unit=cvar,fmt='(I3)') ivar
      vals(1)=real(ivar)
      vars(1)="$otype"
      call getarg(3,cvar)
      read(unit=cvar,fmt='(I3)') ivar
      vals(2)=real(ivar)
      vars(2)="$vno"

    case ('deletevarno')
      allocate(vars(2),vals(2))
      call getarg(2,cvar)
      read(unit=cvar,fmt='(I3)') ivar
      vals(1)=real(ivar)
      vars(1)="$otype"
      call getarg(3,cvar)
      read(unit=cvar,fmt='(I3)') ivar
      vals(2)=real(ivar)
      vars(2)="$vno"

    case ('wind')
      allocate(vars(4),vals(4))
      call getarg(2,cvar)
      read(unit=cvar,fmt='(I3)') ivar
      vals(1)=real(ivar)
      vars(1)="$otype"
      call getarg(3,cvar)
      read(unit=cvar,fmt='(I3)') ivar
      vals(2)=real(ivar)
      vars(2)="$vno_u"
      vals(3)=vals(2)+1
      vars(3)="$vno_v"
      call getarg(4,cvar)
      read(unit=cvar,fmt='(I3)') ivar
      vals(4)=real(ivar)
      vars(4)="$tslot"

    case ('singleobs')
      allocate(vars(3),vals(3))
      call getarg(2,cvar)
      read(unit=cvar,fmt='(I3)') ivar
      vals(1)=real(ivar)
      vars(1)="$otype"
      call getarg(3,cvar)
      read(unit=cvar,fmt='(I3)') ivar
      vals(2)=real(ivar)
      vars(2)="$vno"
      call getarg(4,cvar)
      read(unit=cvar,fmt='(I3)') ivar
      vals(3)=real(ivar)
      vars(3)="$tslot"
      if ( iargc() == 5 ) then
        call getarg(5,cvar)
        read(unit=cvar,fmt='(I3)') nb_obs
      endif


    case ('scat')
      allocate(vars(1),vals(1))
      call getarg(2,cvar)
      read(unit=cvar,fmt='(I3)') ivar
      vals(1)=real(ivar)
      vars(1)="$tslot"
      if ( iargc() == 3 ) then
        call getarg(3,cvar)
        read(unit=cvar,fmt='(I3)') nb_obs
      endif

    case ('singlewind')
      allocate(vars(4),vals(4))
      call getarg(2,cvar)
      read(unit=cvar,fmt='(I3)') ivar
      vals(1)=real(ivar)
      vars(1)="$otype"
      call getarg(3,cvar)
      read(unit=cvar,fmt='(I3)') ivar
      vals(2)=real(ivar)
      vars(2)="$vno_u"
      vals(3)=vals(2)+1
      vars(3)="$vno_v"
      call getarg(4,cvar)
      read(unit=cvar,fmt='(I3)') ivar
      vals(4)=real(ivar)
      vars(4)="$tslot"
      if ( iargc() == 5 ) then
        call getarg(5,cvar)
        read(unit=cvar,fmt='(I3)') nb_obs
      endif

    case ('sensor')
      allocate(vars(2),vals(2))
      call getarg(2,cvar)
      read(unit=cvar,fmt='(I3)') ivar
      vals(1)=real(ivar)
      vars(1)="$otype"
      call getarg(3,cvar)
      read(unit=cvar,fmt='(I3)') ivar
      vals(2)=real(ivar)
      vars(2)="$vno"

  end select

  odb = ODB_open("CCMA","READWRITE",npools)

end subroutine odb_filter_start
!----------------------------------------------------------------------------



!----------------------------------------------------------------------------
subroutine odb_filter_end(odb,ok)

  implicit none
  integer(4), intent(in) :: odb,ok

  integer(4) :: npools,rc,nra,ncols,nrows
  real(8),allocatable :: x0(:,:), x1(:,:), x2(:,:)

  ! UPDATE HDR SET REPORT_STATUS.ACTIVE=0
  rc=ODB_select(odb,"hdr_set_passive",nrows,ncols,nra=nra)
  allocate(x0(nra,0:ncols))
  rc=ODB_get(odb,"hdr_set_passive",x0,nrows,ncols=ncols)
  x0(1:nra,1:1)=0
  rc=ODB_put(odb,"hdr_set_passive",x0,nrows,ncols=ncols)
  deallocate(x0)

  ! UPDATE HDR,BODY SET REPORT_STATUS.ACTIVE=1 WHERE DATUM_STATUS.ACTIVE=1
  rc=ODB_select(odb,"update_hdr_status",nrows,ncols,nra=nra)
  allocate(x0(nra,0:ncols))
  rc=ODB_get(odb,"update_hdr_status",x0,nrows,ncols=ncols)
  x0(1:nra,1:1)=1
  rc=ODB_put(odb,"update_hdr_status",x0,nrows,ncols=ncols)
  deallocate(x0)

  if (ok == 0) then
    print*, "CCMA unchanged"       
    rc = ODB_close(odb, .false.)
  else
    rc = ODB_close(odb, .true.)
  endif
  rc = ODB_end()
end subroutine odb_filter_end
!----------------------------------------------------------------------------

!----------------------------------------------------------------------------
subroutine odb_env

  implicit none

  call codb_putenv("ODB_CONSIDER_TABLES=* except /bufr/")
  call codb_putenv("ODB_SRCPATH_CCMA=CCMA")
  call codb_putenv("ODB_DATAPATH_CCMA=CCMA")
  call codb_putenv("ODB_SRCPATH_CCMA=CCMA")
  call codb_putenv("ODB_DATAPATH_CCMA=CCMA")
  call codb_putenv("TO_ODB_ECMWF=0")
  call codb_putenv("TO_ODB_SWAPOUT=0")
  call codb_putenv("ODB_DEBUG=0")
  call codb_putenv("ODB_CTX_DEBUG=0")
  call codb_putenv("ODB_REPRODUCIBLE_SEQNO=4")
  call codb_putenv("ODB_STATIC_LINKING=1")
  call codb_putenv("ODB_IO_METHOD=1")
  call codb_putenv("ODB_CMA=CCMA")
  call codb_putenv("IOASSIGN=CCMA/IOASSIGN")

end subroutine odb_env
!----------------------------------------------------------------------------


end module odb_filter_mod
