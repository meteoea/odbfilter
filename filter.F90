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

#define rmdi   -2147483647

  nrows=0
  call odb_filter_start(odb, filter, vars, vals, nb_obs)

  select case (filter)   
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

    case ('deletetype') 
      rc=ODB_select(odb,"select_obstype",nrows,ncols,nra=nra,setvars=vars(1:1),values=vals(1:1))
      allocate(x2(nra,0:ncols))
      rc=ODB_get(odb,"select_obstype",x2,nrows,ncols=ncols)
      x2(1:nra,1)=rmdi
      x2(1:nra,2)=0
      rc=ODB_put(odb,"select_obstype",x2,nrows,ncols=ncols)
      print *, "Nb obs deleted: ",nrows

    case ('amsua') 
      rc=ODB_select(odb,"select_amsua",nrows,ncols,nra=nra)
      allocate(x0(nra,0:ncols))
      rc=ODB_get(odb,"select_amsua",x0,nrows,ncols=ncols)

      rc=ODB_select(odb,"select_all",nrows,ncols,nra=nra)
      allocate(x1(nra,0:ncols))
      rc=ODB_get(odb,"select_all",x1,nrows,ncols=ncols)
      x1(1:nra,1)=rmdi
      x1(1:nra,2)=0
      rc=ODB_put(odb,"select_all",x1,nrows,ncols=ncols)
      nall=nrows

      rc=ODB_select(odb,"select_amsua",nrows,ncols,nra=nra)
      allocate(x2(nra,0:ncols))
      rc=ODB_get(odb,"select_amsua",x2,nrows,ncols=ncols)
      x2(1:nra,1)=x0(1:nra,1)
      x2(1:nra,2)=1
      rc=ODB_put(odb,"select_amsua",x2,nrows,ncols=ncols)
      print *, "Nb obs selected: ",nrows," out of: ",nall


    case ('varno')
      rc=ODB_select(odb,"select_obstype_varno",nrows,ncols,nra=nra,setvars=vars(1:2),values=vals(1:2))
      allocate(x0(nra,0:ncols))
      rc=ODB_get(odb,"select_obstype_varno",x0,nrows,ncols=ncols)

      rc=ODB_select(odb,"select_all",nrows,ncols,nra=nra)
      allocate(x1(nra,0:ncols))
      rc=ODB_get(odb,"select_all",x1,nrows,ncols=ncols)
      x1(1:nra,1)=rmdi
      x1(1:nra,2)=0
      rc=ODB_put(odb,"select_all",x1,nrows,ncols=ncols)
      nall=nrows

      rc=ODB_select(odb,"select_obstype_varno",nrows,ncols,nra=nra,setvars=vars(1:2),values=vals(1:2))
      allocate(x2(nra,0:ncols))
      rc=ODB_get(odb,"select_obstype_varno",x2,nrows,ncols=ncols)
      x2(1:nra,1)=x0(1:nra,1)
      x2(1:nra,2)=1
      rc=ODB_put(odb,"select_obstype_varno",x2,nrows,ncols=ncols)
      print *, "Nb obs selected: ",nrows," out of: ",nall

    case ('deletevarno')
      rc=ODB_select(odb,"select_obstype_varno",nrows,ncols,nra=nra,setvars=vars(1:2),values=vals(1:2))
      allocate(x2(nra,0:ncols))
      rc=ODB_get(odb,"select_obstype_varno",x2,nrows,ncols=ncols)
      x2(1:nra,1)=rmdi
      x2(1:nra,2)=0
      rc=ODB_put(odb,"select_obstype_varno",x2,nrows,ncols=ncols)


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

      rc=ODB_select(odb,"select_obstype_varno_tslot",nrows,ncols,nra=nra,setvars=vars(1:3),values=vals(1:3))
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

    case default
      print*, "Invalid filter, usage:"       
      print*, "  odb_filter type <obstype>" 
      print*, "  odb_filter varno <obstype> <varno>"
      print*, "  odb_filter wind <obstype> <varno_u>"
      print*, "  odb_filter singleobs <obstype> <varno> <timeslot>"
      print*, "  odb_filter singlewind <obstype> <varno_u> <timeslot>"
      print*, "  odb_filter sensor <obstype> <sensor>"
   end select
   
  call odb_filter_end(odb, nrows)
 
end program odb_filter

