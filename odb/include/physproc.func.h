
!     The necessary condition for "myproc" being a "round-robin" owner
!     process for a virtual process "pe":

!     if (mod(pe-1,nproc) + 1 == myproc) then ...

!        or a short hand notation

!     if (physproc(pe) == myproc) then 

!     The use requires nproc i.e. at least "USE yomparallel, only : nproc"


INTEGER(KIND=JPIM) :: physproc, pe
physproc(pe) = mod(pe-1,nproc) + 1
