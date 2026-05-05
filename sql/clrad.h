//
// Table Definition: clrad tables
//
CREATE TABLE clrad AS (
  report_clreflflag       pk1int,       // Cloud reflectivity betfield flag - See yomclradlid.F90
  clrad_body              @LINK,
);

CREATE TABLE clrad_body AS (
  clreflvalue             pk9real,       // Simulated cloud radar reflectivity
  clreflvaluetl           pk9real,       // Simulated TL of cloud radar reflectivity
  clreflvaluead           pk9real,       // Simulated AD of cloud radar reflectivity
  clreflvaluefg           pk9real,       // Simulated FG of cloud radar reflectivity
  datum_clrefl_stflag     pk1int,        // Status flag for cloud rad.reflectivity - See yomclradlid.F90
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

