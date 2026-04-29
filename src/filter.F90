! filter.F90 - ODB filter main program
!
! This program filters observations from ODB databases (CCMA/ECMA).
! It supports multiple filter types (timeslot, obstype, varno, etc.)
! and can select, delete, or modify observations based on SQL queries.
!
! Usage: odb_filter <filter_type> [arguments...]
!
! Filter types:
!   timeslot, type, deletetype, amsua, varno, deletevarno, wind,
!   singleobs, obstype_sensor, tslot, onestatid, oneobstypearea,
!   oneobs_gpssol, oneobs_radar, oneobscanal, etc.

program odb_filter

  use odb_module
  use odb_filter_mod

  implicit none

  integer(4) :: odb,rc,nra,ncols,nrows,nall,nb_obs,iobs,istep,nb_wind
  integer(4) :: ipart,istart,istop,iseqno
  real(8),allocatable :: x0(:,:),x1(:,:), x2(:,:)
  character(len=32), allocatable :: vars(:)
  real(8), allocatable :: vals(:)
  character(len=32) :: filter
  character(len=64) cvar

#define rmdi   -2147483647  ! Real Missing Data Indicator

! Initialize ODB and parse command line arguments
  nrows=0
  ncols=0
  call odb_filter_start(odb, filter, vars, vals, nb_obs)

  ! Main filter logic - dispatch based on filter type
  select case (filter)   

! Filter by timeslot: select observations for a specific time slot
    case ('timeslot')
      rc=ODB_select(odb,"select_timeslot",nrows,ncols,nra=nra,setvars=vars(1:1),values=vals(1:1))
      allocate(x0(nra,0:ncols))
      rc=ODB_get(odb,"select_timeslot",x0,nrows,ncols=ncols)

      rc=ODB_select(odb,"select_all",nrows,ncols,nra=nra)
      allocate(x1(nra,0:ncols))
      rc=ODB_get(odb,"select_all",x1,nrows,ncols=ncols)
      x1(1:nra,1)=rmdi
      x1(1:nra,2)=0
      rc=ODB_put(odb,"select_all",x1,nrows,ncols=ncols)
      nall=nrows

      rc=ODB_select(odb,"select_timeslot",nrows,ncols,nra=nra,setvars=vars(1:1),values=vals(1:1))
      allocate(x2(nra,0:ncols))
      rc=ODB_get(odb,"select_timeslot",x2,nrows,ncols=ncols)
      x2(1:nra,1)=x0(1:nra,1)
      x2(1:nra,2)=1
      rc=ODB_put(odb,"select_timeslot",x2,nrows,ncols=ncols)
      print *, "Nb obs selected: ",nrows," out of: ",nall

! Filter by observation type (obstype)
    case ('type') 
      rc=ODB_select(odb,"select_obstype",nrows,ncols,nra=nra,setvars=vars(1:1),values=vals(1:1))
      allocate(x0(nra,0:ncols))
      rc=ODB_get(odb,"select_obstype",x0,nrows,ncols=ncols)

      rc=ODB_select(odb,"select_all",nrows,ncols,nra=nra)
      allocate(x1(nra,0:ncols))
      rc=ODB_get(odb,"select_all",x1,nrows,ncols=ncols)
      x1(1:nra,1)=rmdi
      x1(1:nra,2)=0
      rc=ODB_put(odb,"select_all",x1,nrows,ncols=ncols)
      nall=nrows

      rc=ODB_select(odb,"select_obstype",nrows,ncols,nra=nra,setvars=vars(1:1),values=vals(1:1))
      allocate(x2(nra,0:ncols))
      rc=ODB_get(odb,"select_obstype",x2,nrows,ncols=ncols)
      x2(1:nra,1)=x0(1:nra,1)
      x2(1:nra,2)=1
      rc=ODB_put(odb,"select_obstype",x2,nrows,ncols=ncols)
      print *, "Nb obs selected: ",nrows," out of: ",nall

! Delete observations of a specific type
    case ('deletetype') 
      rc=ODB_select(odb,"select_obstype",nrows,ncols,nra=nra,setvars=vars(1:1),values=vals(1:1))
      allocate(x2(nra,0:ncols))
      rc=ODB_get(odb,"select_obstype",x2,nrows,ncols=ncols)
      x2(1:nra,1)=rmdi
      x2(1:nra,2)=0
      rc=ODB_put(odb,"select_obstype",x2,nrows,ncols=ncols)
print *, "Nb obs deleted: ",nrows

! Filter wind observations (u/v components) by type, varno, and timeslot
    case ('wind')
      call getarg(5,cvar)
      read(unit=cvar,fmt='(I3)') ipart

      rc=ODB_select(odb,"select_obstype_wind",nrows,ncols,nra=nra,setvars=vars(1:4),values=vals(1:4))
      allocate(x0(nra,0:ncols))
      rc=ODB_get(odb,"select_obstype_wind",x0,nrows,ncols=ncols)

      rc=ODB_select(odb,"select_all",nrows,ncols,nra=nra)
      allocate(x1(nra,0:ncols))
      rc=ODB_get(odb,"select_all",x1,nrows,ncols=ncols)
      x1(1:nra,1)=rmdi
      x1(1:nra,2)=0
      rc=ODB_put(odb,"select_all",x1,nrows,ncols=ncols)
      nall=nrows

      rc=ODB_select(odb,"select_obstype_wind",nrows,ncols,nra=nra,setvars=vars(1:4),values=vals(1:4))
      allocate(x2(nra,0:ncols))
      rc=ODB_get(odb,"select_obstype_wind",x2,nrows,ncols=ncols)
      istep= ceiling(real(nra,kind=8)/20)*2
      istart=(ipart-1)*istep+1
      istop=ipart*istep
      istop=min(istop,nra)
      x2(istart:istop,1)=x0(istart:istop,1)
      x2(istart:istop,2)=1
      rc=ODB_put(odb,"select_obstype_wind",x2,nrows,ncols=ncols)
      print *, "Nb obs selected: ",(istop-istart+1)," out of: ",nall

    case ('singleobs')
      rc=ODB_select(odb,"select_obstype_varno_tslot",nrows,ncols,nra=nra,setvars=vars(1:2),values=vals(1:2))
      allocate(x0(nra,0:ncols))
      rc=ODB_get(odb,"select_obstype_varno_tslot",x0,nrows,ncols=ncols)

      rc=ODB_select(odb,"select_all",nrows,ncols,nra=nra)
      allocate(x1(nra,0:ncols))
      rc=ODB_get(odb,"select_all",x1,nrows,ncols=ncols)
      x1(1:nra,1)=rmdi
      x1(1:nra,2)=0
      rc=ODB_put(odb,"select_all",x1,nrows,ncols=ncols)
      nall=nrows

      rc=ODB_select(odb,"select_obstype_varno_tslot",nrows,ncols,nra=nra,setvars=vars(1:2),values=vals(1:2))
      allocate(x2(nra,0:ncols))
      rc=ODB_get(odb,"select_obstype_varno_tslot",x2,nrows,ncols=ncols)
      istep=nrows/(nb_obs+1)+1
      do iobs=istep,nrows,istep
        x2(iobs:iobs,1)=x0(iobs:iobs,1)
        x2(iobs:iobs,2)=1
      enddo
      rc=ODB_put(odb,"select_obstype_varno_tslot",x2,nrows,ncols=ncols)
      print *, "Nb obs selected: ",nb_obs," out of: ",nrows

    case ('singlewind')
      rc=ODB_select(odb,"select_wind_obstype_varno_tslot",nrows,ncols,nra=nra,setvars=vars(1:4),values=vals(1:4))
      allocate(x0(nra,0:ncols))
      rc=ODB_get(odb,"select_wind_obstype_varno_tslot",x0,nrows,ncols=ncols)

      rc=ODB_select(odb,"select_all",nrows,ncols,nra=nra)
      allocate(x1(nra,0:ncols))
      rc=ODB_get(odb,"select_all",x1,nrows,ncols=ncols)
      x1(1:nra,1)=rmdi
      x1(1:nra,2)=0
      rc=ODB_put(odb,"select_all",x1,nrows,ncols=ncols)
      nall=nrows

      rc=ODB_select(odb,"select_wind_obstype_varno_tslot",nrows,ncols,nra=nra,setvars=vars(1:4),values=vals(1:4))
      allocate(x2(nra,0:ncols))
      rc=ODB_get(odb,"select_wind_obstype_varno_tslot",x2,nrows,ncols=ncols)
      nb_wind=nrows/2
      istep=nb_wind/(nb_obs+1)
      do iobs=istep,nb_wind,istep
        x2(2*iobs-1:2*iobs,1)=x0(2*iobs-1:2*iobs,1)
        x2(2*iobs-1:2*iobs,2)=1
      enddo
      rc=ODB_put(odb,"select_wind_obstype_varno_tslot",x2,nrows,ncols=ncols)
      print *, "Nb obs selected: ",nb_obs," out of: ",nrows

! Filter scatterometer observations by timeslot
    case ('scat')
      rc=ODB_select(odb,"select_scat_tslot",nrows,ncols,nra=nra,setvars=vars(1:1),values=vals(1:1))
      allocate(x0(nra,0:ncols))
      rc=ODB_get(odb,"select_scat_tslot",x0,nrows,ncols=ncols)

      rc=ODB_select(odb,"select_all",nrows,ncols,nra=nra)
      allocate(x1(nra,0:ncols))
      rc=ODB_get(odb,"select_all",x1,nrows,ncols=ncols)
      x1(1:nra,1)=rmdi
      x1(1:nra,2)=0
      rc=ODB_put(odb,"select_all",x1,nrows,ncols=ncols)
      nall=nrows

      rc=ODB_select(odb,"select_scat_tslot",nrows,ncols,nra=nra,setvars=vars(1:1),values=vals(1:1))
      allocate(x2(nra,0:ncols))
      rc=ODB_get(odb,"select_scat_tslot",x2,nrows,ncols=ncols)
      nb_wind=nrows/2
      istep=nb_wind/(nb_obs+1)
      iseqno=x2(istep,3)
      do iobs=istep-5,istep+5
        if (x2(iobs,3)==iseqno) then
          x2(iobs,1)=x0(iobs,1)
          x2(iobs,2)=1
        endif
      enddo
      rc=ODB_put(odb,"select_scat_tslot",x2,nrows,ncols=ncols)
      print *, "Nb obs selected: ",nb_obs," out of: ",nrows

! Filter by observation type and sensor number
    case ('sensor')
      rc=ODB_select(odb,"select_obstype_sensor",nrows,ncols,nra=nra,setvars=vars(1:2),values=vals(1:2))
      allocate(x0(nra,0:ncols))
      rc=ODB_get(odb,"select_obstype_sensor",x0,nrows,ncols=ncols)

      rc=ODB_select(odb,"select_all",nrows,ncols,nra=nra)
      allocate(x1(nra,0:ncols))
      rc=ODB_get(odb,"select_all",x1,nrows,ncols=ncols)
      x1(1:nra,1)=rmdi
      x1(1:nra,2)=0
      rc=ODB_put(odb,"select_all",x1,nrows,ncols=ncols)
      nall=nrows

      rc=ODB_select(odb,"select_obstype_sensor",nrows,ncols,nra=nra,setvars=vars(1:2),values=vals(1:2))
      allocate(x2(nra,0:ncols))
      rc=ODB_get(odb,"select_obstype_sensor",x2,nrows,ncols=ncols)
      x2(1:nra,1)=x0(1:nra,1)
      x2(1:nra,2)=1
      rc=ODB_put(odb,"select_obstype_sensor",x2,nrows,ncols=ncols)
      print *, "Nb obs selected: ",nrows," out of: ",nall

    case ('fg_depar') 
      rc=ODB_select(odb,"copy_fg_depar",nrows,ncols,nra=nra)
      allocate(x2(nra,0:ncols))
      rc=ODB_get(odb,"copy_fg_depar",x2,nrows,ncols=ncols)
      x2(1:nra,2)=x2(1:nra,1)
      rc=ODB_put(odb,"copy_fg_depar",x2,nrows,ncols=ncols)
      nall=nrows
      print *, "Nb obs changed: ",nrows," out of: ",nall

! Copy analysis departures to column 2
    case ('an_depar') 
      rc=ODB_select(odb,"copy_an_depar",nrows,ncols,nra=nra)
      allocate(x2(nra,0:ncols))
      rc=ODB_get(odb,"copy_an_depar",x2,nrows,ncols=ncols)
      x2(1:nra,2)=x2(1:nra,1)
      rc=ODB_put(odb,"copy_an_depar",x2,nrows,ncols=ncols)
      nall=nrows
      print *, "Nb obs changed: ",nrows," out of: ",nall

    case ('delete_passive') 
      rc=ODB_select(odb,"delete_passive",nrows,ncols,nra=nra)
      allocate(x0(nra,0:ncols))
      rc=ODB_get(odb,"delete_passive",x0,nrows,ncols=ncols)
      x0(1:nra,1:1)=0
      rc=ODB_put(odb,"delete_passive",x0,nrows,ncols=ncols)
      print *, "Nb obs deleted: ",nrows

! Debug filter: select observations for debugging (currently deletes all)
    case ('debug')
      !rc=ODB_select(odb,"select_for_debug",nrows,ncols,nra=nra)
      !allocate(x0(nra,0:ncols))
      !rc=ODB_get(odb,"select_for_debug",x0,nrows,ncols=ncols)

      !rc=ODB_select(odb,"select_all",nrows,ncols,nra=nra)
      !allocate(x1(nra,0:ncols))
      !rc=ODB_get(odb,"select_all",x1,nrows,ncols=ncols)
      !x1(1:nra,1)=rmdi
      !x1(1:nra,2)=0
      !rc=ODB_put(odb,"select_all",x1,nrows,ncols=ncols)
      !nall=nrows

      !rc=ODB_select(odb,"select_for_debug",nrows,ncols,nra=nra)
      !allocate(x2(nra,0:ncols))
      !rc=ODB_get(odb,"select_for_debug",x2,nrows,ncols=ncols)
      !istep=nrows/(nb_obs+1)
      !x2(istep,1)=x0(istep,1)
      !x2(istep,2)=1
      !rc=ODB_put(odb,"select_for_debug",x2,nrows,ncols=ncols)
      !print *, "Nb obs selected: ",nb_obs," out of: ",nrows

      rc=ODB_select(odb,"select_for_debug",nrows,ncols,nra=nra)
      allocate(x2(nra,0:ncols))
      rc=ODB_get(odb,"select_for_debug",x2,nrows,ncols=ncols)
      x2(istep,1)=rmdi
      x2(istep,2)=0
      rc=ODB_put(odb,"select_for_debug",x2,nrows,ncols=ncols)
print *, "Nb obs selected: ",nrows

! Filter single radar observation by station ID, type, varno, etc.
    case ('singleradar')
      rc=ODB_select(odb,"select_oneobs_radar",nrows,ncols,nra=nra,setvars=vars(1:6),values=vals(1:6))
      allocate(x0(nra,0:ncols))
      rc=ODB_get(odb,"select_oneobs_radar",x0,nrows,ncols=ncols)

      rc=ODB_select(odb,"select_all",nrows,ncols,nra=nra)
      allocate(x1(nra,0:ncols))
      rc=ODB_get(odb,"select_all",x1,nrows,ncols=ncols)
      x1(1:nra,1)=rmdi
      x1(1:nra,2)=0
      rc=ODB_put(odb,"select_all",x1,nrows,ncols=ncols)
      nall=nrows

      rc=ODB_select(odb,"select_oneobs_radar",nrows,ncols,nra=nra,setvars=vars(1:6),values=vals(1:6))
      allocate(x2(nra,0:ncols))
      rc=ODB_get(odb,"select_oneobs_radar",x2,nrows,ncols=ncols)
      print*,'nb_obs ',nb_obs,' nb_rows ',nrows
      !istep=nrows/(nb_obs+1)+1
      istep=1
      do iobs=istep,nrows,istep
        x2(iobs:iobs,1)=x0(iobs:iobs,1)
        x2(iobs:iobs,2)=1
      enddo
      rc=ODB_put(odb,"select_oneobs_radar",x2,nrows,ncols=ncols)
      print *, "Nb obs selected: ",nb_obs," out of: ",nrows

! Filter single GPS sol observation by type, varno, timeslot
    case ('singlegpssol')
        write(*,*) vals
        write(*,*) vars
      rc=ODB_select(odb,"select_oneobs_gpssol",nrows,ncols,nra=nra,setvars=vars(1:4),values=vals(1:4))
      allocate(x0(nra,0:ncols))
      rc=ODB_get(odb,"select_oneobs_gpssol",x0,nrows,ncols=ncols)
      
      rc=ODB_select(odb,"select_all",nrows,ncols,nra=nra)
      allocate(x1(nra,0:ncols))
      rc=ODB_get(odb,"select_all",x1,nrows,ncols=ncols)
      x1(1:nra,1)=rmdi
      x1(1:nra,2)=0
      rc=ODB_put(odb,"select_all",x1,nrows,ncols=ncols)
      nall=nrows
      
      rc=ODB_select(odb,"select_oneobs_gpssol",nrows,ncols,nra=nra,setvars=vars(1:4),values=vals(1:4))
      allocate(x2(nra,0:ncols))
      rc=ODB_get(odb,"select_oneobs_gpssol",x2,nrows,ncols=ncols)
      istep=nrows/(nb_obs+1)+1
      do iobs=istep,nrows,istep
        x2(iobs:iobs,1)=x0(iobs:iobs,1)
        x2(iobs:iobs,2)=1
      enddo
      rc=ODB_put(odb,"select_oneobs_gpssol",x2,nrows,ncols=ncols)
      print *, "Nb obs selected: ",nb_obs," out of: ",rows

! Filter by single station ID
    case ('singlestatid')
        rc=ODB_select(odb,"select_onestatid",nrows,ncols,nra=nra,setvars=vars(1:1),values=vals(1:1))
        allocate(x0(nra,0:ncols))
        rc=ODB_get(odb,"select_onestatid",x0,nrows,ncols=ncols)

        rc=ODB_select(odb,"select_all",nrows,ncols,nra=nra)
        allocate(x1(nra,0:ncols))
        rc=ODB_get(odb,"select_all",x1,nrows,ncols=ncols)
        x1(1:nra,1)=rmdi
        x1(1:nra,2)=0
        rc=ODB_put(odb,"select_all",x1,nrows,ncols=ncols)
        nall=nrows

        rc=ODB_select(odb,"select_onestatid",nrows,ncols,nra=nra,setvars=vars(1:1),values=vals(1:1))
        allocate(x2(nra,0:ncols))
        rc=ODB_get(odb,"select_onestatid",x2,nrows,ncols=ncols)
        print*,x2
        x2(1:nra,1)=x0(1:nra,1)
        x2(1:nra,2)=1
        print*,x2
        rc=ODB_put(odb,"select_onestatid",x2,nrows,ncols=ncols)
        print *, "Nb obs selected: ",nrows," out of: ",nall


    case ('singleobsarea')
        rc=ODB_select(odb,"select_oneobstypearea",nrows,ncols,nra=nra,setvars=vars(1:8),values=vals(1:8))
        allocate(x0(nra,0:ncols))
        rc=ODB_get(odb,"select_oneobstypearea",x0,nrows,ncols=ncols)
        print*, nrows,"x0",x0

        rc=ODB_select(odb,"select_all",nrows,ncols,nra=nra)
        allocate(x1(nra,0:ncols))
        rc=ODB_get(odb,"select_all",x1,nrows,ncols=ncols)
        x1(1:nra,1)=rmdi
        x1(1:nra,2)=0
        rc=ODB_put(odb,"select_all",x1,nrows,ncols=ncols)
        nall=nrows

        rc=ODB_select(odb,"select_oneobstypearea",nrows,ncols,nra=nra,setvars=vars(1:8),values=vals(1:8))
        allocate(x2(nra,0:ncols))
        rc=ODB_get(odb,"select_oneobstypearea",x2,nrows,ncols=ncols)
        x2(1,1)=x0(1,1)
        x2(1,2)=1
        x2(2:nra,1)=rmdi
        x2(2:nra,2)=0
        rc=ODB_put(odb,"select_oneobstypearea",x2,nrows,ncols=ncols)
        print *, "Nb obs selected: ",nrows," out of: ",nall

! Filter single observation by channel (canal)
    case ('singleobscanal')
        rc=ODB_select(odb,"select_oneobscanal",nrows,ncols,nra=nra,setvars=vars(1:2),values=vals(1:2))
        allocate(x0(nra,0:ncols))
        print*, "ncols = ",ncols
        rc=ODB_get(odb,"select_oneobscanal",x0,nrows,ncols=ncols)
        print*, nrows,"x0",x0

        rc=ODB_select(odb,"select_all",nrows,ncols,nra=nra)
        allocate(x1(nra,0:ncols))
        rc=ODB_get(odb,"select_all",x1,nrows,ncols=ncols)
        x1(1:nra,1)=rmdi
        x1(1:nra,2)=0
        rc=ODB_put(odb,"select_all",x1,nrows,ncols=ncols)
        nall=nrows

        rc=ODB_select(odb,"select_oneobscanal",nrows,ncols,nra=nra,setvars=vars(1:2),values=vals(1:2))
        allocate(x2(nra,0:ncols))
        rc=ODB_get(odb,"select_oneobscanal",x2,nrows,ncols=ncols)
        !x2=x0
        print*, nrows,"x2 avant ",x2
        x2(1,1)=x0(1,1)
        x2(1,2)=1
        if (nra>=2) then
          x2(2:nra,1)=rmdi
          x2(2:nra,2)=0
        endif
        print*, nrows,"x2",x2
        !istep=nrows/(nb_obs+1)+1
        !do iobs=istep,nrows,istep
        !  x2(iobs:iobs,1)=x0(iobs:iobs,1)
        !  x2(iobs:iobs,2)=1
        !enddo

        rc=ODB_put(odb,"select_oneobscanal",x2,nrows,ncols=ncols)
        print *, "Nb obs selected: ",nrows," out of: ",nall

! Filter observations for Sophie (specific selection)
    case ('sophie')
      rc=ODB_select(odb,"select_sophie",nrows,ncols,nra=nra)
      allocate(x0(nra,0:ncols))
      rc=ODB_get(odb,"select_sophie",x0,nrows,ncols=ncols)

      rc=ODB_select(odb,"select_all",nrows,ncols,nra=nra)
      allocate(x1(nra,0:ncols))
      rc=ODB_get(odb,"select_all",x1,nrows,ncols=ncols)
      x1(1:nra,1)=rmdi
      x1(1:nra,2)=0
      rc=ODB_put(odb,"select_all",x1,nrows,ncols=ncols)
      nall=nrows

      rc=ODB_select(odb,"select_sophie",nrows,ncols,nra=nra)
      allocate(x2(nra,0:ncols))
      rc=ODB_get(odb,"select_sophie",x2,nrows,ncols=ncols)
      x2(1:nra,1)=x0(1:nra,1)
      x2(1:nra,2)=1
      rc=ODB_put(odb,"select_sophie",x2,nrows,ncols=ncols)
      print *, "Nb obs selected: ",nrows," out of: ",nall

    case ('copy_fg_in_actual_depar')
      rc=ODB_select(odb,"select_fg_actual_depar",nrows,ncols,nra=nra)
      allocate(x2(nra,0:ncols))
      rc=ODB_get(odb,"select_fg_actual_depar",x2,nrows,ncols=ncols)
      x2(1:nra,2)=x2(1:nra,1)
      rc=ODB_put(odb,"select_fg_actual_depar",x2,nrows,ncols=ncols)
      print *, "Nb obs copied: ",nra

! Copy first guess departure into actual departure column
   case ('copy_fg_in_actual_depar')
     rc=ODB_select(odb,"select_fg_actual_depar",nrows,ncols,nra=nra)
     allocate(x2(nra,0:ncols))
     rc=ODB_get(odb,"select_fg_actual_depar",x2,nrows,ncols=ncols)
     x2(1:nra,2)=x2(1:nra,1)
     rc=ODB_put(odb,"select_fg_actual_depar",x2,nrows,ncols=ncols)
     print *, "Nb obs copied: ",nra

! Unknown filter type - show usage
   case default
      print*, "Invalid filter, usage:"       
      print*, "  odb_filter type <obstype>" 
      print*, "  odb_filter varno <obstype> <varno>"
      print*, "  odb_filter wind <obstype> <varno_u>"
      print*, "  odb_filter singleobs <obstype> <varno> <timeslot>"
      print*, "  odb_filter singlewind <obstype> <varno_u> <timeslot>"
      print*, "  odb_filter sensor <obstype> <sensor>"
      print*, "  odb_filter singleradar <obstype> <varno> <ident> <distance> <elev> <azimut>"
      print*, "  odb_filter singlegpssol <obstype> <codetype> <lon (en radians)> <lat (en radians)>"
   end select
   
  call odb_filter_end(odb, nrows)
 
end program odb_filter

