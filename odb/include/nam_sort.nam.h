
! SORT_DATA,           ! .TRUE. [def.] if sorting is to be performed
! COLLECT_NODE,        ! -1 [def.] if data is to be collected into a single node
! WRITE_IFS,           ! .FALSE. [def.] if IFS-file is to be written
! WRITE_MAP,           ! .FALSE. [def.] if obs distr. coast map written
! IFS_FILE,            ! Name of the communication file between sorting & IFS (output)
! MAP_FILE,            ! Name of the coast map Postscript (output)
! PS_MACROS            ! Name of the coast line INPUT-files (PS-macros)

namelist /NAM_SORT/&
    &SORT_DATA,           &
    &COLLECT_NODE,        &
    &WRITE_IFS,           &
    &WRITE_MAP,           &
    &IFS_FILE,            &
    &MAP_FILE,            &
    &PS_MACROS            


