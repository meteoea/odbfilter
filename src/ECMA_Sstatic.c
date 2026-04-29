/*
 * ECMA_Sstatic.c - ECMA schema static initializer
 * 
 * Registers all SQL view functions for the ECMA (Earlier Cycle Model Analysis)
 * database schema. ODB uses this to set up the function pointers for
 * each view defined in the SQL files.
 */

#define ODB_GENCODE 0
#include "ECMA.h"

/* Initialize static function pointers for all ECMA views */
PUBLIC void ECMA_static_init() {
ODB_ANCHOR(ECMA);
/* Register all SQL views for ECMA schema */
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
ODB_ANCHOR_VIEW(ECMA, select_oneobs_radar );
ODB_ANCHOR_VIEW(ECMA, select_oneobs_gpssol );
ODB_ANCHOR_VIEW(ECMA, select_onestatid );
ODB_ANCHOR_VIEW(ECMA, select_oneobstypearea );
ODB_ANCHOR_VIEW(ECMA, select_oneobscanal );
ODB_ANCHOR_VIEW(ECMA, select_sophie );
}

