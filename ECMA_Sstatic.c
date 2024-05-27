#define ODB_GENCODE 0
#include "ECMA.h"

PUBLIC void ECMA_static_init() {
ODB_ANCHOR(ECMA);
ODB_ANCHOR_VIEW(ECMA, hdr_set_passive );
ODB_ANCHOR_VIEW(ECMA, select_all );
ODB_ANCHOR_VIEW(ECMA, select_obstype_sensor );
ODB_ANCHOR_VIEW(ECMA, select_obstype );
ODB_ANCHOR_VIEW(ECMA, select_obstype_varno );
ODB_ANCHOR_VIEW(ECMA, select_obstype_wind );
ODB_ANCHOR_VIEW(ECMA, select_obstype_varno_tslot );
ODB_ANCHOR_VIEW(ECMA, select_wind_obstype_varno_tslot );
ODB_ANCHOR_VIEW(ECMA, select_scat_tslot );
ODB_ANCHOR_VIEW(ECMA, update_hdr_status );
ODB_ANCHOR_VIEW(ECMA, copy_fg_depar );
ODB_ANCHOR_VIEW(ECMA, copy_an_depar );
ODB_ANCHOR_VIEW(ECMA, select_for_debug );
ODB_ANCHOR_VIEW(ECMA, delete_passive );
ODB_ANCHOR_VIEW(ECMA, select_amsua );
ODB_ANCHOR_VIEW(ECMA, select_timeslot );
}

