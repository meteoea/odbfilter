#define ODB_GENCODE 0
#include "CCMA.h"

PUBLIC void CCMA_static_init() {
ODB_ANCHOR(CCMA);
ODB_ANCHOR_VIEW(CCMA, hdr_set_passive );
ODB_ANCHOR_VIEW(CCMA, select_all );
ODB_ANCHOR_VIEW(CCMA, select_obstype_sensor );
ODB_ANCHOR_VIEW(CCMA, select_obstype );
ODB_ANCHOR_VIEW(CCMA, select_obstype_varno );
ODB_ANCHOR_VIEW(CCMA, select_obstype_wind );
ODB_ANCHOR_VIEW(CCMA, select_obstype_varno_tslot );
ODB_ANCHOR_VIEW(CCMA, select_wind_obstype_varno_tslot );
ODB_ANCHOR_VIEW(CCMA, select_scat_tslot );
ODB_ANCHOR_VIEW(CCMA, update_hdr_status );
ODB_ANCHOR_VIEW(CCMA, copy_fg_depar );
ODB_ANCHOR_VIEW(CCMA, copy_an_depar );
ODB_ANCHOR_VIEW(CCMA, select_for_debug );
ODB_ANCHOR_VIEW(CCMA, delete_passive );
ODB_ANCHOR_VIEW(CCMA, select_amsua );
ODB_ANCHOR_VIEW(CCMA, select_timeslot );
}

