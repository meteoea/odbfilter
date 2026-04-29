#define IS_a_VIEW 1
/* Compilation options used :

	 -c
	 -I/home/gmap/mrpe/arbogaste/pack/cy49t1_op1.07.IMPIIFC2018DP.x/src/main/odb/ddl.CCMA
	 -lCCMA
	 -DCCMA
	 -w
	 -lCCMA
	 -DCCMA
	 -w
	 -Abody=(surfbody_feedback,errstat,update_1,update_2,update_3,update_4,fcdiagnostic_body_1,fcdiagnostic_body_2,fcdiagnostic_body_3,fcdiagnostic_body_4,fcdiagnostic_body_5,fcdiagnostic_body_6,fcdiagnostic_body_7,fcdiagnostic_body_8,fcdiagnostic_body_9,fcdiagnostic_body_10,fcdiagnostic_body_11,fcdiagnostic_body_12,fcdiagnostic_body_13,fcdiagnostic_body_14,fcdiagnostic_body_15,fcdiagnostic_body_16,fcdiagnostic_body_17,fcdiagnostic_body_18,fcdiagnostic_body_19,fcdiagnostic_body_20,conv_body,scatt_body,ssmi_body,gbrad_body,radar_body,resat_averaging_kernel,auxiliary_body,allsky_body,radiance_body,gnssro_body,raingg_body,clrad_body,claerlid_body,superob,enkf_1,enkf_2,enkf_3,enkf_4,enkf_5,enkf_6,enkf_7,enkf_8,enkf_9,enkf_10,enkf_11,enkf_12,enkf_13,enkf_14,enkf_15,enkf_16,enkf_17,enkf_18,enkf_19,enkf_20,enkf_21,enkf_22,enkf_23,enkf_24,enkf_25,enkf_26,enkf_27,enkf_28,enkf_29,enkf_30,enkf_31,enkf_32,enkf_33,enkf_34,enkf_35,enkf_36,enkf_37,enkf_38,enkf_39,enkf_40,enkf_41,enkf_42,enkf_43,enkf_44,enkf_45,enkf_46,enkf_47,enkf_48,enkf_49,enkf_50,enkf_51,enkf_52,enkf_53,enkf_54,enkf_55,enkf_56,enkf_57,enkf_58,enkf_59,enkf_60,enkf_61,enkf_62,enkf_63,enkf_64,enkf_65,enkf_66,enkf_67,enkf_68,enkf_69,enkf_70,enkf_71,enkf_72,enkf_73,enkf_74,enkf_75,enkf_76,enkf_77,enkf_78,enkf_79,enkf_80,enkf_81,enkf_82,enkf_83,enkf_84,enkf_85,enkf_86,enkf_87,enkf_88,enkf_89,enkf_90,enkf_91,enkf_92,enkf_93,enkf_94,enkf_95,enkf_96,enkf_97,enkf_98,enkf_99,enkf_100,enkf_101,enkf_102,enkf_103,enkf_104,enkf_105,enkf_106,enkf_107,enkf_108,enkf_109,enkf_110,enkf_111,enkf_112,enkf_113,enkf_114,enkf_115,enkf_116,enkf_117,enkf_118,enkf_119,enkf_120,enda_1,enda_2,enda_3,enda_4,enda_5,enda_6,enda_7,enda_8,enda_9,enda_10,enda_11,enda_12,enda_13,enda_14,enda_15,enda_16,enda_17,enda_18,enda_19,enda_20,enda_21,enda_22,enda_23,enda_24,enda_25,enda_26,enda_27,enda_28,enda_29,enda_30,enda_31,enda_32,enda_33,enda_34,enda_35,enda_36,enda_37,enda_38,enda_39,enda_40,enda_41,enda_42,enda_43,enda_44,enda_45,enda_46,enda_47,enda_48,enda_49,enda_50,enda_51,enda_52,enda_53,enda_54,enda_55,enda_56,enda_57,enda_58,enda_59,enda_60,enda_61,enda_62,enda_63,enda_64,enda_65,enda_66,enda_67,enda_68,enda_69,enda_70,enda_71,enda_72,enda_73,enda_74,enda_75,enda_76,enda_77,enda_78,enda_79,enda_80,enda_81,enda_82,enda_83,enda_84,enda_85,enda_86,enda_87,enda_88,enda_89,enda_90,enda_91,enda_92,enda_93,enda_94,enda_95,enda_96,enda_97,enda_98,enda_99,enda_100,surfbody_feedback_1,surfbody_feedback_2,surfbody_feedback_3,surfbody_feedback_4,surfbody_feedback_5,surfbody_feedback_6,surfbody_feedback_7,surfbody_feedback_8,surfbody_feedback_9,surfbody_feedback_10,surfbody_feedback_11,surfbody_feedback_12,surfbody_feedback_13,surfbody_feedback_14,surfbody_feedback_15,surfbody_feedback_16,surfbody_feedback_17,surfbody_feedback_18,surfbody_feedback_19,surfbody_feedback_20,surfbody_feedback_21,surfbody_feedback_22,surfbody_feedback_23,surfbody_feedback_24,surfbody_feedback_25,surfbody_feedback_26,surfbody_feedback_27,surfbody_feedback_28,surfbody_feedback_29,surfbody_feedback_30,surfbody_feedback_31,surfbody_feedback_32,surfbody_feedback_33,surfbody_feedback_34,surfbody_feedback_35,surfbody_feedback_36,surfbody_feedback_37,surfbody_feedback_38,surfbody_feedback_39,surfbody_feedback_40,surfbody_feedback_41,surfbody_feedback_42,surfbody_feedback_43,surfbody_feedback_44,surfbody_feedback_45,surfbody_feedback_46,surfbody_feedback_47,surfbody_feedback_48,surfbody_feedback_49,surfbody_feedback_50,surfbody_feedback_51,surfbody_feedback_52,surfbody_feedback_53,surfbody_feedback_54,surfbody_feedback_55,surfbody_feedback_56,surfbody_feedback_57,surfbody_feedback_58,surfbody_feedback_59,surfbody_feedback_60,surfbody_feedback_61,surfbody_feedback_62,surfbody_feedback_63,surfbody_feedback_64,surfbody_feedback_65,surfbody_feedback_66,surfbody_feedback_67,surfbody_feedback_68,surfbody_feedback_69,surfbody_feedback_70,surfbody_feedback_71,surfbody_feedback_72,surfbody_feedback_73,surfbody_feedback_74,surfbody_feedback_75,surfbody_feedback_76,surfbody_feedback_77,surfbody_feedback_78,surfbody_feedback_79,surfbody_feedback_80,surfbody_feedback_81,surfbody_feedback_82,surfbody_feedback_83,surfbody_feedback_84,surfbody_feedback_85,surfbody_feedback_86,surfbody_feedback_87,surfbody_feedback_88,surfbody_feedback_89,surfbody_feedback_90,surfbody_feedback_91,surfbody_feedback_92,surfbody_feedback_93,surfbody_feedback_94,surfbody_feedback_95,surfbody_feedback_96,surfbody_feedback_97,surfbody_feedback_98,surfbody_feedback_99,surfbody_feedback_100)
	 -Ahdr=fcdiagnostic
	 -1index=hdr
	 -1hdr=(auxiliary,ensemble,sat,modsurf,gbrad,raingg,conv,clrad,claerlid)
	 -1sat=(radiance,ssmi,scatt,satob,resat,limb,radar,radar_station,smos,gnssro,aeolus_hdr)
	 -1radiance=(allsky,cloud_sink,collocated_imager_information)

*/

#include "CCMA.h"


static const char *Sql[] = {
  "//",
  "//-- ODB/SQL file 'select_oneobs_radar.sql'",
  "//",
  "//",
  "",
  "UPDATED;",
  "",
  "SET $otype = 0;",
  "SET $vno = 0;",
  "SET $ident = 0;",
  "SET $distance = 0;",
  "SET $elev = 0;",
  "SET $azimut = 0;",
  "",
  "CREATE VIEW select_oneobs_radar AS   ",
  "  SELECT obsvalue,datum_status.active UPDATED,             // r/o",
  "  FROM   hdr, body, radar_body, radar_station, index",
  "  WHERE  obstype=$otype and varno=$vno and ident=$ident and distance>$distance-0.01 and distance<$distance+0.01 and elevation>$elev-0.01 and  elevation<$elev+0.01 and azimuth>$azimut-0.01 and azimuth<$azimut+0.01",
  ";",
  ";",
  "",
  NULL
};



#define ODB_CONSIDER_TABLES "/index/hdr/sat/radar_station/radar/radar_body/body/"

#define HDR_Obstype_all_EXPR(i) T_hdrXobstype[i] /* 'pk1int:obstype@hdr' */
#define BODY_Varno_all_EXPR(i) T_bodyXvarno[i] /* 'pk1int:varno@body' */
#define RADAR_STATION_Ident_all_EXPR(i) T_radar_stationXident[i] /* 'pk1int:ident@radar_station' */
#define RADAR_BODY_Distance_all_EXPR(i) T_radar_bodyXdistance[i] /* 'pk9real:distance@radar_body' */
#define RADAR_BODY_Elevation_all_EXPR(i) T_radar_bodyXelevation[i] /* 'pk9real:elevation@radar_body' */
#define RADAR_BODY_Azimuth_all_EXPR(i) T_radar_bodyXazimuth[i] /* 'pk9real:azimuth@radar_body' */


PRIVATE double USD_otype_CCMA = 0; /* $otype */
PRIVATE double USD_vno_CCMA = 0; /* $vno */
PRIVATE double USD_ident_CCMA = 0; /* $ident */
PRIVATE double USD_distance_CCMA = 0; /* $distance */
PRIVATE double USD_elev_CCMA = 0; /* $elev */
PRIVATE double USD_azimut_CCMA = 0; /* $azimut */


#if !defined(K0_lo_var) && !defined(K0_lo_const)
#define K0_lo 0
#endif
#define index_ROW ((double)(K0 + 1))
#define hdr_ROW ((double)(K1 + 1))
#define sat_ROW ((double)(K2 + 1))
#define radar_station_ROW ((double)(K3 + 1))
#define radar_ROW ((double)(K4 + 1))
#define radar_body_ROW ((double)(K5 + 1))
#define body_ROW ((double)(K6 + 1))

/* *************** VIEW "select_oneobs_radar" *************** */

typedef struct {
  int Handle;
  int PoolNo;
  ODB_Funcs *Funcs;
  int Ncols;
  int Nrows;
  int  USD_symbols;
  int  Replicate_PE;
  int  Npes;
  int *NrowVec;
  int *NrowOffset;
  int  NSortKeys;
  int *SortKeys;
  ODBMAC_VIEW_TABLEDECL_NO_INDEX(index);
  ODBMAC_VIEW_TABLEDECL_NO_INDEX(hdr);
  ODBMAC_VIEW_TABLEDECL_NO_INDEX(sat);
  ODBMAC_VIEW_TABLEDECL_NO_INDEX(radar_station);
  ODBMAC_VIEW_TABLEDECL_NO_INDEX(radar);
  ODBMAC_VIEW_TABLEDECL_NO_INDEX(radar_body);
  ODBMAC_VIEW_TABLEDECL_WITH_INDEX(body);
  uint can_UPDATE[RNDUP_DIV(2,MAXBITS)];
} VIEW_select_oneobs_radar;

PRIVATE int nV_select_oneobs_radar_TAG = 8;
PRIVATE int nV_select_oneobs_radar_MEM = 0;

PRIVATE const ODB_Tags V_select_oneobs_radar_TAG[8] = {
  /* === SELECT-symbols (count = 2) === */
  { "pk9real:obsvalue@body", 0, 0, NULL } ,
  { "Bitfield:datum_status.active@body", 0, 0, NULL } ,
  /* === Symbols for auxiliary columns (count = 0) === */
  /* === Symbols in SELECT-expressions (count = 0) === */
  /* === WHERE-symbols (count = 6) === */
  { "pk1int:obstype@hdr", 0, 0, NULL },
  { "pk1int:varno@body", 0, 0, NULL },
  { "pk1int:ident@radar_station", 0, 0, NULL },
  { "pk9real:distance@radar_body", 0, 0, NULL },
  { "pk9real:elevation@radar_body", 0, 0, NULL },
  { "pk9real:azimuth@radar_body", 0, 0, NULL },
  /* === ORDERBY-symbols (count = 0) === */
  /* === UNIQUEBY-symbols (count = 0) === */
};

PRIVATE int nV_select_oneobs_radar_PREPTAG = 3;
PRIVATE const ODB_PrepTags V_select_oneobs_radar_PREPTAG[3] = {
  /* Prepared tags for faster codb_getnames() */
  { (preptag_name | preptag_extname), 40,
    ";obsvalue@body;datum_status.active@body;" },
  { (preptag_type | preptag_exttype), 18,
    ";pk9real;Bitfield;" },
  {  preptag_tblname, 58,
    ";@index;@hdr;@sat;@radar_station;@radar;@radar_body;"
    "@body;" },
};

PRIVATE void
Ccl_V_select_oneobs_radar(void *T)
{
  ODBMAC_CCL_V_PRE(select_oneobs_radar);
  FREEINDEX(body);
}

PRIVATE int
PrS_V_select_oneobs_radar(FILE *do_trace,
  VIEW_select_oneobs_radar *P, int it, ODB_PE_Info *PEinfo
  /* TABLE 'index' */ , int N0, unsigned int BmapIdx0[]
  /* TABLE 'hdr' */ , int N1, unsigned int BmapIdx1[]
  /* TABLE 'sat' */ , int N2, unsigned int BmapIdx2[]
  /* TABLE 'radar_station' */ , int N3, unsigned int BmapIdx3[]
  /* TABLE 'radar' */ , int N4, unsigned int BmapIdx4[]
  /* TABLE 'radar_body' */ , int N5, unsigned int BmapIdx5[]
  /* TABLE 'body' */ , int N6, unsigned int BmapIdx6[],
  const pk1int T_hdrXobstype[],
  const pk1int T_bodyXvarno[],
  const pk1int T_radar_stationXident[],
  const pk9real T_radar_bodyXdistance[],
  const pk9real T_radar_bodyXelevation[],
  const pk9real T_radar_bodyXazimuth[])
{
  double lc_USD_otype = 0;
  double lc_USD_vno = 0;
  double lc_USD_ident = 0;
  double lc_USD_distance = 0;
  double lc_USD_elev = 0;
  double lc_USD_azimut = 0;
  double *Addr = (PEinfo && P->USD_symbols > 0) ? PEinfo->addr : NULL;
  int PE, PEstart = 1;
  int PEend = PEinfo ? PEinfo->npes : PEstart;
  int NPEs = PEend - PEstart + 1;
  int K0;
#if defined(K0_lo_var)
  int K0_lo =  0;
#elif defined(K0_lo_const)
  const int K0_lo =  0;
#endif
  int K0_hi = N0;
  int Count = 0;
  linkoffset_t *Phdr_off = UseDSlong(P->T_index, CCMA, linkoffset_t, P->T_index->LINKOFFSET(hdr));
  linklen_t *Phdr_len = UseDSlong(P->T_index, CCMA, linklen_t, P->T_index->LINKLEN(hdr));
  linkoffset_t *Psat_off = UseDSlong(P->T_hdr, CCMA, linkoffset_t, P->T_hdr->LINKOFFSET(sat));
  linklen_t *Psat_len = UseDSlong(P->T_hdr, CCMA, linklen_t, P->T_hdr->LINKLEN(sat));
  linkoffset_t *Pradar_station_off = UseDSlong(P->T_sat, CCMA, linkoffset_t, P->T_sat->LINKOFFSET(radar_station));
  linklen_t *Pradar_station_len = UseDSlong(P->T_sat, CCMA, linklen_t, P->T_sat->LINKLEN(radar_station));
  linkoffset_t *Pradar_off = UseDSlong(P->T_sat, CCMA, linkoffset_t, P->T_sat->LINKOFFSET(radar));
  linklen_t *Pradar_len = UseDSlong(P->T_sat, CCMA, linklen_t, P->T_sat->LINKLEN(radar));
  linkoffset_t *Pradar_body_off = UseDSlong(P->T_radar, CCMA, linkoffset_t, P->T_radar->LINKOFFSET(radar_body));
  linklen_t *Pradar_body_len = UseDSlong(P->T_radar, CCMA, linklen_t, P->T_radar->LINKLEN(radar_body));
  linkoffset_t *Pbody_off = UseDSlong(P->T_hdr, CCMA, linkoffset_t, P->T_hdr->LINKOFFSET(body));
  linklen_t *Pbody_len = UseDSlong(P->T_hdr, CCMA, linklen_t, P->T_hdr->LINKLEN(body));
  DRHOOK_START(PrS_V_select_oneobs_radar);
  ODBMAC_PEINFO_SETUP();
  ODBMAC_LC_GETVAL(CCMA, otype, "select_oneobs_radar");
  ODBMAC_LC_GETVAL(CCMA, vno, "select_oneobs_radar");
  ODBMAC_LC_GETVAL(CCMA, ident, "select_oneobs_radar");
  ODBMAC_LC_GETVAL(CCMA, distance, "select_oneobs_radar");
  ODBMAC_LC_GETVAL(CCMA, elev, "select_oneobs_radar");
  ODBMAC_LC_GETVAL(CCMA, azimut, "select_oneobs_radar");
  for (PE=PEstart; PE<=PEend; PE++) {
    int tmpcount = 0;
    if (Addr) {
      boolean Addr_trigger = 0;
      *Addr = PE;
      ODBMAC_ADDR_TRIGGER(CCMA, PEinfo->varname, otype, "select_oneobs_radar");
      ODBMAC_ADDR_TRIGGER(CCMA, PEinfo->varname, vno, "select_oneobs_radar");
      ODBMAC_ADDR_TRIGGER(CCMA, PEinfo->varname, ident, "select_oneobs_radar");
      ODBMAC_ADDR_TRIGGER(CCMA, PEinfo->varname, distance, "select_oneobs_radar");
      ODBMAC_ADDR_TRIGGER(CCMA, PEinfo->varname, elev, "select_oneobs_radar");
      ODBMAC_ADDR_TRIGGER(CCMA, PEinfo->varname, azimut, "select_oneobs_radar");
      if (!Addr_trigger) Addr = NULL;
    }
    ODBMAC_PEINFO_SKIP();
    for (K0=K0_lo; K0<K0_hi; K0++) { /* TABLE 'index' : weight = 1.000003 */
      int K1_lo = Phdr_off[K0];
      int K1;
      K1 = K1_lo; { /* TABLE 'hdr' (due to ONELOOPER with 'index') : weight = 3.000004 */
        int K2_lo = Psat_off[K1];
        int K2;
        double tmp2 = HDR_Obstype_all_EXPR(K1);
        int cond1 = (tmp2 == lc_USD_otype);
        if (cond1 == 0) continue;
        K2 = K2_lo; { /* TABLE 'sat' (due to ONELOOPER with 'hdr') : weight = 3.001004 */
          int K3_lo = Pradar_station_off[K2];
          int K3;
          K3 = K3_lo; { /* TABLE 'radar_station' (due to ONELOOPER with 'sat') : weight = 3.002004 */
            int K4_lo = Pradar_off[K2];
            int K4;
            double tmp4 = RADAR_STATION_Ident_all_EXPR(K3);
            int cond3 = (tmp4 == lc_USD_ident);
            if (cond3 == 0) continue;
            K4 = K4_lo; { /* TABLE 'radar' (due to ONELOOPER with 'sat') : weight = 3.002004 */
              int K5_lo = Pradar_body_off[K4];
              int K5_hi = K5_lo + Pradar_body_len[K4];
              int K5;
              for (K5=K5_lo; K5<K5_hi; K5++) { /* TABLE 'radar_body' : weight = 361.000376 */
                int K6_lo = Pbody_off[K1];
                int K6;
                double tmp5 = RADAR_BODY_Distance_all_EXPR(K5);
                double tmp6 = tmp5;
                double tmp7 = RADAR_BODY_Elevation_all_EXPR(K5);
                double tmp8 = tmp7;
                double tmp9 = RADAR_BODY_Azimuth_all_EXPR(K5);
                double tmp10 = tmp9;
                int cond5 = (tmp5 > (lc_USD_distance - ((double)0.01)))
            && (tmp6 < (lc_USD_distance + ((double)0.01)))
            && (tmp7 > (lc_USD_elev - ((double)0.01)))
            && (tmp8 < (lc_USD_elev + ((double)0.01)))
            && (tmp9 > (lc_USD_azimut - ((double)0.01)))
            && (tmp10 < (lc_USD_azimut + ((double)0.01)));
                if (cond5 == 0) continue;
                K6 = K6_lo + (K5 - K5_lo); { /* TABLE 'body' (due to ALIGN with 'radar_body') : weight = 361.000382 */
                  double tmp3 = BODY_Varno_all_EXPR(K6);
                  int cond6 = (tmp3 == lc_USD_vno);
                  if (cond6 != 0)
                  { /* if-block start */
                      tmpcount++; /* TABLE 'body' : weight = 361.000382 */
                  } /* if-block end */
                } /* TABLE 'body' */
              } /* TABLE 'radar_body' */
            } /* TABLE 'radar' */
          } /* TABLE 'radar_station' */
        } /* TABLE 'sat' */
      } /* TABLE 'hdr' */
    } /* TABLE 'index' */
    ODBMAC_PEINFO_UPDATE_COUNTS();
    Count += tmpcount;
  } /* for (PE=PEstart; PE<=PEend; PE++) */
  ODBMAC_PEINFO_COPY();
  DRHOOK_END(Count);
  return Count;
}

PRIVATE int
PoS_V_select_oneobs_radar(FILE *do_trace,
  const VIEW_select_oneobs_radar *P, int it, ODB_PE_Info *PEinfo
  /* TABLE 'index' */ , int N0, const unsigned int BmapIdx0[]
  /* TABLE 'hdr' */ , int N1, const unsigned int BmapIdx1[]
  /* TABLE 'sat' */ , int N2, const unsigned int BmapIdx2[]
  /* TABLE 'radar_station' */ , int N3, const unsigned int BmapIdx3[]
  /* TABLE 'radar' */ , int N4, const unsigned int BmapIdx4[]
  /* TABLE 'radar_body' */ , int N5, const unsigned int BmapIdx5[]
  /* TABLE 'body' */ , int N6, const unsigned int BmapIdx6[], int Index_body[],
  const pk1int T_hdrXobstype[],
  const pk1int T_bodyXvarno[],
  const pk1int T_radar_stationXident[],
  const pk9real T_radar_bodyXdistance[],
  const pk9real T_radar_bodyXelevation[],
  const pk9real T_radar_bodyXazimuth[])
{
  double lc_USD_otype = 0;
  double lc_USD_vno = 0;
  double lc_USD_ident = 0;
  double lc_USD_distance = 0;
  double lc_USD_elev = 0;
  double lc_USD_azimut = 0;
  double *Addr = (PEinfo && P->USD_symbols > 0) ? PEinfo->addr : NULL;
  int PE, PEstart = 1;
  int PEend = PEinfo ? PEinfo->npes : PEstart;
  int NPEs = PEend - PEstart + 1;
  int K0;
#if defined(K0_lo_var)
  int K0_lo = 0;
#elif defined(K0_lo_const)
  const int K0_lo = 0;
#endif
  int K0_hi = N0;
  int Count = 0;
  int tmpcount = 0;
  linkoffset_t *Phdr_off = UseDSlong(P->T_index, CCMA, linkoffset_t, P->T_index->LINKOFFSET(hdr));
  linklen_t *Phdr_len = UseDSlong(P->T_index, CCMA, linklen_t, P->T_index->LINKLEN(hdr));
  linkoffset_t *Psat_off = UseDSlong(P->T_hdr, CCMA, linkoffset_t, P->T_hdr->LINKOFFSET(sat));
  linklen_t *Psat_len = UseDSlong(P->T_hdr, CCMA, linklen_t, P->T_hdr->LINKLEN(sat));
  linkoffset_t *Pradar_station_off = UseDSlong(P->T_sat, CCMA, linkoffset_t, P->T_sat->LINKOFFSET(radar_station));
  linklen_t *Pradar_station_len = UseDSlong(P->T_sat, CCMA, linklen_t, P->T_sat->LINKLEN(radar_station));
  linkoffset_t *Pradar_off = UseDSlong(P->T_sat, CCMA, linkoffset_t, P->T_sat->LINKOFFSET(radar));
  linklen_t *Pradar_len = UseDSlong(P->T_sat, CCMA, linklen_t, P->T_sat->LINKLEN(radar));
  linkoffset_t *Pradar_body_off = UseDSlong(P->T_radar, CCMA, linkoffset_t, P->T_radar->LINKOFFSET(radar_body));
  linklen_t *Pradar_body_len = UseDSlong(P->T_radar, CCMA, linklen_t, P->T_radar->LINKLEN(radar_body));
  linkoffset_t *Pbody_off = UseDSlong(P->T_hdr, CCMA, linkoffset_t, P->T_hdr->LINKOFFSET(body));
  linklen_t *Pbody_len = UseDSlong(P->T_hdr, CCMA, linklen_t, P->T_hdr->LINKLEN(body));
  DRHOOK_START(PoS_V_select_oneobs_radar);
  ODBMAC_LC_GETVAL(CCMA, otype, "select_oneobs_radar");
  ODBMAC_LC_GETVAL(CCMA, vno, "select_oneobs_radar");
  ODBMAC_LC_GETVAL(CCMA, ident, "select_oneobs_radar");
  ODBMAC_LC_GETVAL(CCMA, distance, "select_oneobs_radar");
  ODBMAC_LC_GETVAL(CCMA, elev, "select_oneobs_radar");
  ODBMAC_LC_GETVAL(CCMA, azimut, "select_oneobs_radar");
  for (PE=PEstart; PE<=PEend; PE++) {
    if (Addr) {
      boolean Addr_trigger = 0;
      *Addr = PE;
      ODBMAC_ADDR_TRIGGER(CCMA, PEinfo->varname, otype, "select_oneobs_radar");
      ODBMAC_ADDR_TRIGGER(CCMA, PEinfo->varname, vno, "select_oneobs_radar");
      ODBMAC_ADDR_TRIGGER(CCMA, PEinfo->varname, ident, "select_oneobs_radar");
      ODBMAC_ADDR_TRIGGER(CCMA, PEinfo->varname, distance, "select_oneobs_radar");
      ODBMAC_ADDR_TRIGGER(CCMA, PEinfo->varname, elev, "select_oneobs_radar");
      ODBMAC_ADDR_TRIGGER(CCMA, PEinfo->varname, azimut, "select_oneobs_radar");
      if (!Addr_trigger) Addr = NULL;
    }
    ODBMAC_PEINFO_BREAKLOOP();
    for (K0=K0_lo; K0<K0_hi; K0++) { /* TABLE 'index' : weight = 1.000003 */
      int K1_lo = Phdr_off[K0];
      int K1 = K1_lo;
      K1 = K1_lo; { /* TABLE 'hdr' (due to ONELOOPER with 'index') : weight = 3.000004 */
        int K2_lo = Psat_off[K1];
        int K2 = K2_lo;
        double tmp2 = HDR_Obstype_all_EXPR(K1);
        int cond1 = (tmp2 == lc_USD_otype);
        if (cond1 == 0) continue;
        K2 = K2_lo; { /* TABLE 'sat' (due to ONELOOPER with 'hdr') : weight = 3.001004 */
          int K3_lo = Pradar_station_off[K2];
          int K3 = K3_lo;
          K3 = K3_lo; { /* TABLE 'radar_station' (due to ONELOOPER with 'sat') : weight = 3.002004 */
            int K4_lo = Pradar_off[K2];
            int K4 = K4_lo;
            double tmp4 = RADAR_STATION_Ident_all_EXPR(K3);
            int cond3 = (tmp4 == lc_USD_ident);
            if (cond3 == 0) continue;
            K4 = K4_lo; { /* TABLE 'radar' (due to ONELOOPER with 'sat') : weight = 3.002004 */
              int K5_lo = Pradar_body_off[K4];
              int K5_hi = K5_lo + Pradar_body_len[K4];
              int K5 = K5_lo;
              for (K5=K5_lo; K5<K5_hi; K5++) { /* TABLE 'radar_body' : weight = 361.000376 */
                int K6_lo = Pbody_off[K1];
                int K6 = K6_lo;
                double tmp5 = RADAR_BODY_Distance_all_EXPR(K5);
                double tmp6 = tmp5;
                double tmp7 = RADAR_BODY_Elevation_all_EXPR(K5);
                double tmp8 = tmp7;
                double tmp9 = RADAR_BODY_Azimuth_all_EXPR(K5);
                double tmp10 = tmp9;
                int cond5 = (tmp5 > (lc_USD_distance - ((double)0.01)))
            && (tmp6 < (lc_USD_distance + ((double)0.01)))
            && (tmp7 > (lc_USD_elev - ((double)0.01)))
            && (tmp8 < (lc_USD_elev + ((double)0.01)))
            && (tmp9 > (lc_USD_azimut - ((double)0.01)))
            && (tmp10 < (lc_USD_azimut + ((double)0.01)));
                if (cond5 == 0) continue;
                K6 = K6_lo + (K5 - K5_lo); { /* TABLE 'body' (due to ALIGN with 'radar_body') : weight = 361.000382 */
                  double tmp3 = BODY_Varno_all_EXPR(K6);
                  int cond6 = (tmp3 == lc_USD_vno);
                  if (cond6 != 0)
                  { /* if-block start */
                    Index_body[tmpcount] = K6;
                    tmpcount++;
                  } /* if-block end */
                } /* TABLE 'body' */
              } /* TABLE 'radar_body' */
            } /* TABLE 'radar' */
          } /* TABLE 'radar_station' */
        } /* TABLE 'sat' */
      } /* TABLE 'hdr' */
    } /* TABLE 'index' */
  } /* for (PE=PEstart; PE<=PEend; PE++) */
  DRHOOK_END(tmpcount);
  return tmpcount;
}

PRIVATE int
Sel_V_select_oneobs_radar(void *V, ODB_PE_Info *PEinfo, int phase, void *feedback)
{
  VIEW_select_oneobs_radar *P = V;
  int CountPrS = 0;
  int CountPoS = 0;
  int Nbytes = 0;
  ODBMAC_TRACE_SELVIEW_SETUP(select_oneobs_radar, "index,hdr,sat,radar_station,radar,radar_body,body");
  int it = odb_get_thread_id();
  DRHOOK_START(Sel_V_select_oneobs_radar);
  ODBMAC_PEINFO_SELVIEW_SETUP();
  FREEINDEX(body);
  ODBMAC_TRACE_SELVIEW_PRE();
  ODBMAC_VIEW_DELAYED_LOAD(index);
  ODBMAC_VIEW_DELAYED_LOAD(hdr);
  ODBMAC_VIEW_DELAYED_LOAD(sat);
  ODBMAC_VIEW_DELAYED_LOAD(radar_station);
  ODBMAC_VIEW_DELAYED_LOAD(radar);
  ODBMAC_VIEW_DELAYED_LOAD(radar_body);
  ODBMAC_VIEW_DELAYED_LOAD(body);
  ODBMAC_TRACE_SELVIEW_0();
  ODBMAC_TRACE_SELVIEW_1();
  { /* Start of pre- & post-select block */
    const pk1int *TmpVec_2 = UseDSlong(P->T_hdr, CCMA, pk1int, P->T_hdr->obstype);
    const pk1int *TmpVec_3 = UseDSlong(P->T_body, CCMA, pk1int, P->T_body->varno);
    const pk1int *TmpVec_4 = UseDSlong(P->T_radar_station, CCMA, pk1int, P->T_radar_station->ident);
    const pk9real *TmpVec_5 = UseDSlong(P->T_radar_body, CCMA, pk9real, P->T_radar_body->distance);
    const pk9real *TmpVec_7 = UseDSlong(P->T_radar_body, CCMA, pk9real, P->T_radar_body->elevation);
    const pk9real *TmpVec_9 = UseDSlong(P->T_radar_body, CCMA, pk9real, P->T_radar_body->azimuth);
    ALLOCBITMAPINDEX(index);
    ALLOCBITMAPINDEX(hdr);
    ALLOCBITMAPINDEX(sat);
    ALLOCBITMAPINDEX(radar_station);
    ALLOCBITMAPINDEX(radar);
    ALLOCBITMAPINDEX(radar_body);
    ALLOCBITMAPINDEX(body);
    CountPrS = PrS_V_select_oneobs_radar(do_trace, P, it, PEinfo
      , P->T_index->Nrows, P->BitmapIndex_index
      , P->T_hdr->Nrows, P->BitmapIndex_hdr
      , P->T_sat->Nrows, P->BitmapIndex_sat
      , P->T_radar_station->Nrows, P->BitmapIndex_radar_station
      , P->T_radar->Nrows, P->BitmapIndex_radar
      , P->T_radar_body->Nrows, P->BitmapIndex_radar_body
      , P->T_body->Nrows, P->BitmapIndex_body,
      TmpVec_2,
      TmpVec_3,
      TmpVec_4,
      TmpVec_5,
      TmpVec_7,
      TmpVec_9);
    ODBMAC_TRACE_SELVIEW_POST();
    ALLOCINDEX(body, CountPrS);
    ODBMAC_TRACE_SELVIEW_2();
    if (CountPrS > 0) {
      CountPoS = PoS_V_select_oneobs_radar(do_trace, P, it, PEinfo
        , P->T_index->Nrows, P->BitmapIndex_index
        , P->T_hdr->Nrows, P->BitmapIndex_hdr
        , P->T_sat->Nrows, P->BitmapIndex_sat
        , P->T_radar_station->Nrows, P->BitmapIndex_radar_station
        , P->T_radar->Nrows, P->BitmapIndex_radar
        , P->T_radar_body->Nrows, P->BitmapIndex_radar_body
        , P->T_body->Nrows, P->BitmapIndex_body, P->Index_body,
        TmpVec_2,
        TmpVec_3,
        TmpVec_4,
        TmpVec_5,
        TmpVec_7,
        TmpVec_9); }
    else { CountPoS = CountPrS; }
    FREEBITMAPINDEX(index);
    FREEBITMAPINDEX(hdr);
    FREEBITMAPINDEX(sat);
    FREEBITMAPINDEX(radar_station);
    FREEBITMAPINDEX(radar);
    FREEBITMAPINDEX(radar_body);
    FREEBITMAPINDEX(body);
  } /* End of pre-& post-select block */
  ODBMAC_TRACE_SELVIEW_LAST();
  ODBMAC_ERRMSG_SELVIEW(select_oneobs_radar);
  ODB_debug_print_index(stdout, "select_oneobs_radar", P->PoolNo, CountPrS, 1
        , "body", P->Index_body, P->T_body, P->T_body->Nrows);
  P->Nrows = CountPrS;
  DRHOOK_END(CountPrS);
  return CountPrS;
}

PRIVATE int
dGet_V_select_oneobs_radar(void *V, double D[],
  int LdimD, int Nrows, int Ncols,
  int ProcID, const int Flag[], int row_offset)
{
  VIEW_select_oneobs_radar *P = V;
  int Count = MIN(Nrows, P->Nrows);
  int K1 = 0, K2 = Count;
  int Npes = P->Npes;
  FILE *do_trace = ODB_trace_fp();
  DRHOOK_START(dGet_V_select_oneobs_radar);
  ODBMAC_PEINFO_OFFSET();
  Call_GatherGet_VIEW(CCMA, d, 1, select_oneobs_radar, pk9real, K1, K2, body, D, obsvalue, DATATYPE_REAL8, 0, 0);
  Call_GatherGet_VIEW(CCMA, d, 2, select_oneobs_radar, Bitfield, K1, K2, body, D, datum_status, DATATYPE_BITFIELD, 0, 1);
  DRHOOK_END(K2-K1);
  return K2-K1;
}

PRIVATE int
dPut_V_select_oneobs_radar(void *V, const double D[],
  int LdimD, int Nrows, int Ncols,
  int ProcID, const int Flag[])
{
  VIEW_select_oneobs_radar *P = V;
  int Count = MIN(Nrows, P->Nrows);
  int K1 = 0, K2 = Count;
  int Npes = P->Npes;
  FILE *do_trace = ODB_trace_fp();
  DRHOOK_START(dPut_V_select_oneobs_radar);
  ODBMAC_PEINFO_OFFSET();
  Call_ScatterPut_VIEW(CCMA, d, 1, select_oneobs_radar, pk9real, K1, K2, body, obsvalue, D, DATATYPE_REAL8, 0, 0);
  Call_ScatterPut_VIEW(CCMA, d, 2, select_oneobs_radar, Bitfield, K1, K2, body, datum_status, D, DATATYPE_BITFIELD, 0, 1);
  DRHOOK_END(K2-K1);
  return K2-K1;
}

PRIVATE void
Dim_V_select_oneobs_radar(void *V, int *Nrows, int *Ncols, int *Nrowoffset, int ProcID) { ODBMAC_DIM(select_oneobs_radar); }

#define Swapout_V_select_oneobs_radar Ccl_V_select_oneobs_radar

PRIVATE int
Sql_V_select_oneobs_radar(FILE *fp, int mode, const char *prefix, const char *postfix, char **sqlout) { ODBMAC_VIEWSQL(); }

PRIVATE int
ColAux_V_select_oneobs_radar(void *V, int colaux[], int colaux_len)
{
  int filled = 0;
  static const int ColAux_len = 2;
  static const int ColAux[2] = {1,2};
  ODBMAC_COPY_COLAUX(select_oneobs_radar);
  return filled;
}

PRIVATE int *
SortKeys_V_select_oneobs_radar(void *V, int *NSortKeys) { ODBMAC_SORTKEYS(select_oneobs_radar); }

PRIVATE int 
UpdateInfo_V_select_oneobs_radar(void *V, const int ncols, int can_UPDATE[]) { ODBMAC_UPDATEINFO(select_oneobs_radar); }

PRIVATE int *
GetIndex_V_select_oneobs_radar(void *V, const char *Table, int *Nidx)
{
  VIEW_select_oneobs_radar *P = V;
  int Dummy = 0;
  int *Nlen = Nidx ? Nidx : &Dummy;
  ODBMAC_GETINDEX(body);
  return NULL;
}

PRIVATE int
PutIndex_V_select_oneobs_radar(void *V, const char *Table, int Nidx, int idx[], int by_address)
{
  /* *** Warning: This is a VERY DANGEROUS routine -- if misused !!! */
  VIEW_select_oneobs_radar *P = V;
  int rc = 0;
  ODBMAC_PUTINDEX(body);
  return rc;
}

PRIVATE void
PEinfo_V_select_oneobs_radar(void *V, ODB_PE_Info *PEinfo) { ODBMAC_PEINFO_INIT(select_oneobs_radar); }

PRIVATE void *
Init_V_select_oneobs_radar(void *V, ODB_Pool *Pool, int Dummy1, int Dummy2, int it, int add_vars)
{
  VIEW_select_oneobs_radar *P = V;
  int PoolNo = Pool->poolno;
  ODB_Funcs *pf;
  static ODB_CommonFuncs *pfcom = NULL; /* Shared between pools & threads */
  DRHOOK_START(Init_V_select_oneobs_radar);
  if (!P) ALLOC(P, 1);
  P->PoolNo = PoolNo;
  P->Ncols = 2;
  P->Nrows = 0;
  P->USD_symbols = 6; /* In SELECT = 0 ; In WHERE = 9 */
  P->Replicate_PE = 0;
  P->Npes = 0;
  P->NrowVec = NULL;
  P->NrowOffset = NULL;
  P->NSortKeys = 0;
  P->SortKeys = NULL;
  /* Initially all bits set to 0, which corresponds to read-only -mode for all */
  memset(P->can_UPDATE, 0, sizeof(P->can_UPDATE));
  ODBIT_set(P->can_UPDATE, P->Ncols, MAXBITS, 0, 0);   /* pk9real:obsvalue@body */
  ODBIT_set(P->can_UPDATE, P->Ncols, MAXBITS, 1, 1);   /* Bitfield:datum_status.active@body */
  {
    ODB_Pool *p = Pool;
    ODBMAC_ASSIGN_TABLEDATA(index);
    ODBMAC_ASSIGN_TABLEDATA(hdr);
    ODBMAC_ASSIGN_TABLEDATA(sat);
    ODBMAC_ASSIGN_TABLEDATA(radar_station);
    ODBMAC_ASSIGN_TABLEDATA(radar);
    ODBMAC_ASSIGN_TABLEDATA(radar_body);
    ODBMAC_ASSIGN_TABLEDATA(body);
  }
  NULLIFY_INDEX(body);
  if (!pfcom) { /* Initialize once only */
    CALLOC(pfcom,1);
    { static char s[] = "select_oneobs_radar"; pfcom->name = s; }
    pfcom->is_table = 0;
    pfcom->is_considered = 0;
    pfcom->ntables = 7;
    pfcom->ncols = P->Ncols;
    pfcom->tableno = 0;
    pfcom->rank = 0;
    pfcom->wt = 0;
    pfcom->tags = V_select_oneobs_radar_TAG;
    pfcom->preptags = V_select_oneobs_radar_PREPTAG;
    pfcom->ntag = nV_select_oneobs_radar_TAG;
    pfcom->npreptag = nV_select_oneobs_radar_PREPTAG;
    pfcom->nmem = nV_select_oneobs_radar_MEM;
    pfcom->Info = NULL;
    pfcom->create_index = 0;
    pfcom->init = Init_V_select_oneobs_radar;
    pfcom->swapout = Swapout_V_select_oneobs_radar;
    pfcom->dim = Dim_V_select_oneobs_radar;
    pfcom->sortkeys = SortKeys_V_select_oneobs_radar;
    pfcom->update_info = UpdateInfo_V_select_oneobs_radar;
    pfcom->aggr_info = NULL;
    pfcom->getindex = GetIndex_V_select_oneobs_radar;
    pfcom->putindex = PutIndex_V_select_oneobs_radar;
    pfcom->peinfo = PEinfo_V_select_oneobs_radar;
    pfcom->select = Sel_V_select_oneobs_radar;
    pfcom->remove = NULL;
    pfcom->cancel = Ccl_V_select_oneobs_radar;
    pfcom->dget = dGet_V_select_oneobs_radar;
    pfcom->dput = dPut_V_select_oneobs_radar;
    pfcom->load = NULL;
    pfcom->store = NULL;
    pfcom->pack = NULL;
    pfcom->unpack = NULL;
    pfcom->sql = Sql_V_select_oneobs_radar;
    pfcom->ncols_aux = 0;
    pfcom->colaux = ColAux_V_select_oneobs_radar;
    pfcom->has_select_distinct = 0;
    pfcom->has_usddothash = 0;
  } /* if (!pfcom) */
  ALLOC(pf, 1);
  pf->it = it;
  pf->data = P;
  pf->Res = NULL;
  pf->tmp = NULL;
  pf->pool = Pool;
  pf->common = pfcom;
  pf->next = NULL;
  P->Funcs = pf;
  P->Handle = P->Funcs->pool->handle;
  if (add_vars) {
    Pool->add_var("CCMA", "$otype", "select_oneobs_radar", it, USD_otype_CCMA);
    Pool->add_var("CCMA", "$vno", "select_oneobs_radar", it, USD_vno_CCMA);
    Pool->add_var("CCMA", "$ident", "select_oneobs_radar", it, USD_ident_CCMA);
    Pool->add_var("CCMA", "$distance", "select_oneobs_radar", it, USD_distance_CCMA);
    Pool->add_var("CCMA", "$elev", "select_oneobs_radar", it, USD_elev_CCMA);
    Pool->add_var("CCMA", "$azimut", "select_oneobs_radar", it, USD_azimut_CCMA);
  } /* if (add_vars) */
  DRHOOK_END(0);
  return P;
}

/* *************** End of VIEW "select_oneobs_radar" *************** */

PUBLIC ODB_Funcs *
Anchor2CCMA_select_oneobs_radar(void *V, ODB_Pool *pool, int *nviews, int it, int add_vars)
{
  VIEW_select_oneobs_radar *P = V;
  ODB_Funcs *pf;
  DRHOOK_START(Anchor2CCMA_select_oneobs_radar);
  if (!P) P = Init_V_select_oneobs_radar(NULL, pool, -1, -1, it, add_vars);
  if (nviews) *nviews = 1;
  pf = P->Funcs;
  DRHOOK_END(0);
  return pf;
}
