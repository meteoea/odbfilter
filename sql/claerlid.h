//
// Table Definition: claerlid tables
//
CREATE TABLE claerlid AS (
  report_clbscflag        pk1int,       // Cloud lidar backscatter betfield flag - See yomclradlid.F90
  claerlid_body           @LINK,
);

CREATE TABLE claerlid_body AS (
  clbscvalue              pk9real,       // Simulated cloud lidar backscatter
  clbscvaluetl            pk9real,       // Simulated TL of cloud lidar backscatter
  clbscvaluead            pk9real,       // Simulated AD of cloud lidar backscatter
  clbscvaluefg            pk9real,       // Simulated FG of cloud lidar backscatter
  datum_clbsc_stflag      pk1int,        // Status flag for cloud lid.backscatter - See yomclradlid.F90
  fg_presf                pk9real,
  fg_z                    pk9real,
  fg_temp                 pk9real,
  fg_spech                pk9real,
  fg_cwc                  pk9real,
  fg_iwc                  pk9real,
  fg_cc                   pk9real,
  fg_rwc                  pk9real,
  fg_swc                  pk9real,
  fg_pfra                 pk9real,
  fg_crwc                 pk9real,
  fg_cswc                 pk9real,
  an_presf                pk9real,
  an_temp                 pk9real,
  an_spech                pk9real,
  an_cwc                  pk9real,
  an_iwc                  pk9real,
  an_cc                   pk9real,
  an_rwc                  pk9real,
  an_swc                  pk9real,
  an_pfra                 pk9real,
  an_crwc                 pk9real,
  an_cswc                 pk9real,
);

