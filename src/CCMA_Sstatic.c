/*
 * CCMA_Sstatic.c - CCMA schema static initializer
 * 
 * Registers all SQL view functions for the CCMA (Current Cycle Model Analysis)
 * database schema. ODB uses this to set up the function pointers for
 * each view defined in the SQL files.
 */

#define ODB_GENCODE 0
#include "CCMA.h"

/* Initialize static function pointers for all CCMA views */
PUBLIC void CCMA_static_init() {
ODB_ANCHOR(CCMA);
/* Register all SQL views for CCMA schema */
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
ODB_ANCHOR_VIEW(CCMA, select_oneobs_radar );
ODB_ANCHOR_VIEW(CCMA, select_oneobs_gpssol );
ODB_ANCHOR_VIEW(CCMA, select_onestatid );
ODB_ANCHOR_VIEW(CCMA, select_oneobstypearea );
ODB_ANCHOR_VIEW(CCMA, select_oneobscanal );
ODB_ANCHOR_VIEW(CCMA, select_sophie );
ODB_ANCHOR_VIEW(CCMA, select_fg_actual_depar );
}

