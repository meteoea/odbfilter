# odbfilter Technical Reference

## ODB (Observations Data Base)

### Overview

ODB (Observations Data Base) is a database system used in numerical weather prediction for storing and processing observation data. 

### Key Concepts

- **Database Schemas**: Logical groupings of observation data (CCMA, ECMA)
- **Tables**: `hdr` (header), `body` (observation data), `errstat` (error statistics)
- **Views**: SQL-based queries that define data selection/modification
- **Anchors**: Entry points for ODB to initialize schema functions

### ECMA/CCMA Schema

**Conventional and Satellite Observation Data**

- Primary schema for conventional observations (TEMP, SYNOP, etc.) and satellite data
- Tables: `hdr`, `body`, `errstat`, `cma` (CMA-specific)
- Used by `odb_filter` as the main input/output database
- Used for validation and comparison
- Data can be transferred between CCMA and ECMA via shuffle operations

---

## SQL Files

### Location

All SQL files are stored in `sql/` directory. They are symlinked via `ddl.*` directories.

### File Structure

Each SQL file follows this pattern:

```sql
//
//-- ODB/SQL file 'filename.sql'
//

UPDATED;  // Indicates the view can modify data

SET $variable = default_value;  // Optional variable declarations

CREATE VIEW view_name AS
  SELECT column1, column2 UPDATED,  // UPDATED = modifiable
    FROM   table1, table2
    WHERE  condition=$variable
;
```

### Key Keywords

| Keyword | Purpose |
|---------|---------|
| `UPDATED` | Marks the view as capable of modifying data |
| `SET $var = val` | Declares a variable with default value |
| `CREATE VIEW` | Defines the SQL view |
| `UPDATED` (column) | Marks a column as modifiable |
| `$variable` | References a declared variable |

### Available SQL Files

#### Selection Views

| File | Purpose | Variables |
|------|---------|------------|
| `select_all.sql` | Select all observations | - |
| `select_obstype.sql` | Filter by observation type | `$otype` |
| `select_timeslot.sql` | Filter by timeslot | `$tslot` |
| `select_obstype_varno.sql` | Filter by type and variable | `$otype`, `$vno` |
| `select_obstype_varno_tslot.sql` | Filter by type, var, timeslot | `$otype`, `$vno`, `$tslot` |
| `select_obstype_wind.sql` | Filter wind observations | `$otype`, `$vno_u`, `$vno_v` |
| `select_wind_obstype_varno_tslot.sql` | Wind with all params | `$otype`, `$vno_u`, `$vno_v`, `$tslot` |
| `select_scat_tslot.sql` | Scatterometer by timeslot | `$tslot` |
| `select_obstype_sensor.sql` | Filter by type and sensor | `$otype`, `$sensor` |
| `select_onestatid.sql` | By station ID | `$statid` |
| `select_oneobsarea.sql` | By type and area | `$otype`, `$varno`, `$lonmin/max`, `$latmin/max`, `$presmin/max` |
| `select_oneobs_radar.sql` | Single radar observation | `$otype`, `$vno`, `$ident`, `$distance`, `$elev`, `$azimut` |
| `select_oneobs_gpssol.sql` | Single GPS sol observation | `$otype`, `$ctype`, `$lon`, `$lat` |
| `select_oneobscanal.sql` | By channel (canal) | `$otype`, `$vertco` |
| `select_amsua.sql` | AMSU-A observations | - |
| `select_sophie.sql` | Custom selection for Sophie | - |
| `select_for_debug.sql` | Debug selection | - |

#### Update/Modify Views

| File | Purpose |
|------|---------|
| `hdr_set_passive.sql` | Set `REPORT_STATUS.ACTIVE=0` (passive) |
| `update_hdr_status.sql` | Set `REPORT_STATUS.ACTIVE=1` where `DATUM_STATUS.ACTIVE=1` |
| `copy_fg_depar.sql` | Copy first guess departures to column 2 |
| `copy_an_depar.sql` | Copy analysis departures to column 2 |
| `delete_passive.sql` | Delete passive observations |
| `select_fg_actual_depar.sql` | Select FG/actual departures |

---

## ODB Macros and Functions

### In C Code (Generated)

#### `ODB_ANCHOR(schema)`

Initializes the anchor point for a schema. Must be called before registering views.

```c
ODB_ANCHOR(CCMA);  // Initialize CCMA schema anchor
```

#### `ODB_ANCHOR_VIEW(schema, view)`

Registers a SQL view function with ODB. Called within `${schema}_static_init()`.

```c
ODB_ANCHOR_VIEW(CCMA, select_all);  // Register select_all view for CCMA
```

#### `Static_Init(db)` Macro

Defined in `_odb_glue.c`, this macro:
1. Checks if the provided `dbname` matches the schema
2. If matched, registers the schema's `db_static_init()` function

```c
// Expanded macro for CCMA:
if (strncmp(dbname, "CCMA", dbname_len) == 0) {
  extern void CCMA_static_init();
  ODB_add2funclist("CCMA", CCMA_static_init, 0);
}
```

### ODB API Functions

#### `codb_set_entrypoint_(dbname, dbname_len)`

**Entry point called by ODB** to set up database schema initializers.

- **Parameters**:
  - `dbname`: The database schema name (e.g., "CCMA", "ECMA")
  - `dbname_len`: Length of the dbname string (Fortran hidden argument)
- **Purpose**: Calls `Static_Init()` for each detected schema

#### `codb_procdata_(myproc, nproc, pid, it, inumt)`

**ODB internal function** to get processor information.

- **Parameters**: All are output parameters (pointers)
  - `myproc`: Current processor number
  - `nproc`: Total number of processors
  - `pid`: Process ID
  - `it`: Thread number
  - `inumt`: Number of threads

#### `ODB_add2funclist(dbname, func, funcno)`

**Registers a function** in ODB's function list.

- **Parameters**:
  - `dbname`: Database schema name
  - `func`: Function pointer to register
  - `funcno`: Function number (0 for static init)

---

## Build Integration

### odb98.x SQL Compiler

The `odb98.x` tool converts `.sql` files to C object files.

**Command** (from `sql/CMakeLists.txt`):
```bash
odb98.x -c -I${INC_CMA}.${cma} -l ${cma} -w -l ${cma} -w ${sql}
```

- `-c`: Compile mode
- `-I`: Include directory for schema headers
- `-l`: Schema name
- `-w`: Wrap function names
- `${sql}`: SQL file to compile

### Generated Files

#### `${schema}.h`

Generated by `odb98.x` during SQL processing. Contains:
- Function declarations for each SQL view
- Schema-specific definitions

Located in: `${CMAKE_BINARY_DIR}/ddl.${schema}/${schema}.h`

#### `${schema}_Sstatic.c`

Generated from `cmake/templates/_Sstatic.c.in`. Contains:
- `${schema}_static_init()` function
- `ODB_ANCHOR()` call
- `ODB_ANCHOR_VIEW()` calls for each SQL view

Located in: `${CMAKE_BINARY_DIR}/src/${schema}_Sstatic.c`

#### `_odb_glue.c`

Generated from `cmake/templates/_odb_glue.c.in`. Contains:
- `codb_set_entrypoint_()` function
- `Static_Init()` macro definition
- Calls to each schema's `Static_Init()`

Located in: `${CMAKE_BINARY_DIR}/src/_odb_glue.c`

### Object Libraries

For each schema, a static library is created:

- **`${schema}_lib`**: Contains object files from all SQL views
- Created in `sql/CMakeLists.txt`
- Linked into the final executable

---

## Environment Variables

### ODB Runtime Variables

| Variable | Purpose | Set In |
|----------|---------|--------|
| `ODB_CONSIDER_TABLES` | Tables to consider (excludes /bufr/) | `odb_filter_mod.F90` |
| `ODB_SRCPATH_CCMA` | Source path for CCMA tables | `odb_filter_mod.F90` |
| `ODB_DATAPATH_CCMA` | Data path for CCMA database | `odb_filter_mod.F90` |
| `ODB_STATIC_LINKING` | Enable static linking (1=on) | `odb_filter_mod.F90` |
| `ODB_IO_METHOD` | I/O method (1=default) | `odb_filter_mod.F90` |
| `ODB_CMA` | Database type (CCMA) | `odb_filter_mod.F90` |

### Build Environment Variables

| Variable | Purpose | Set In |
|----------|---------|--------|
| `ODB_COMPILER` | Path to odb98.x | `build_for_pack.sh`, CMake |
| `ODB_COMPILER_FLAGS` | Flags for odb98.x | `build_for_pack.sh` |
| `ODB_CREATE_IOASSIGN` | Path to create_ioassign script | `build_for_pack.sh` |
| `ODB_SYSPATH` | System path for ODB schemas | `build_for_pack.sh` |
| `ODB_CC` | C compiler for ODB | `build_for_pack.sh` |

---

## Database Tables

### hdr (Header Table)

Contains metadata about each observation report.

| Column | Description |
|--------|-------------|
| `expver` | Experiment version |
| `obstype` | Observation type (5=TEMP, 4=SYNOP, etc.) |
| `codetype` | Code type |
| `sensor` | Sensor number |
| `statid` | Station ID |
| `lat`, `lon` | Latitude, Longitude |
| `stalt` | Station altitude |
| `date`, `time` | Observation date and time |
| `report_status` | Report status (active/passive) |
| `datum_status` | Datum status (active/passive) |

### body (Body Table)

Contains the actual observation data.

| Column | Description |
|--------|-------------|
| `varno` | Variable number (2=temp, 3=pressure, etc.) |
| `obsvalue` | Observation value |
| `obserr` | Observation error |
| `fg_depar` | First guess departure |
| `an_depar` | Analysis departure |
| `biascorr` | Bias correction |

### errstat (Error Statistics Table)

Contains error statistics for quality control.

---

## Fortran-ODB Integration

### Key Modules and Functions

#### `odb_filter_mod` Module

- **`odb_filter_start(odb, filter, vars, vals, nb_obs)`**:
  - Initializes ODB environment
  - Parses filter-specific arguments
  - Opens CCMA database in READWRITE mode
  - Returns ODB handle, variables, and values

- **`odb_filter_end(odb, ok)`**:
  - Updates `REPORT_STATUS.ACTIVE` based on `DATUM_STATUS.ACTIVE`
  - Closes ODB (commits if ok!=0, discards otherwise)

#### ODB Fortran API

- **`ODB_select(odb, view, ...)`**: Selects data using a SQL view
- **`ODB_get(...)`**: Gets data from a selection
- **`ODB_put(...)`**: Puts (writes) modified data
- **`ODB_close(odb)`**: Closes ODB handle

### Special Values

| Value | Meaning |
|-------|---------|
| `rmdi` | Real Missing Data Indicator (for Fortran reals) |
| `1` | Active observation |
| `0` | Passive observation |
| `-1` | Deleted observation |

---

## Troubleshooting

### SQL Compilation Errors

**Symptom**: `odb98.x` fails to compile `.sql` files

**Solution**:
1. Check SQL syntax (missing semicolons, etc.)
2. Verify `odb98.x` is in PATH or set `ODB_COMPILER`
3. Check include paths (`INC_CMA` CMake variable)

### Missing Headers

**Symptom**: `"CCMA.h": No such file or directory`

**Solution**:
1. Ensure `odb98.x` ran successfully (check build directory)
2. Verify `${CMAKE_BINARY_DIR}/ddl.CCMA/` is in include path
3. Re-run CMake to regenerate headers

### Schema Not Found

**Symptom**: `Static_Init()` not called for a schema

**Solution**:
1. Check `ddl.*` symlinks exist: `ls -la ddl.*`
2. Verify symlinks point to `sql/`: `readlink ddl.CCMA`
3. Re-run CMake: `rm -rf build && mkdir build && cd build && cmake ..`

---
