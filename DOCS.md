# odbfilter Documentation

## Table of Contents
1. [Project Overview](#project-overview)
2. [Background: ODB Databases](#background-odb-databases)
3. [Architecture](#architecture)
4. [Directory Structure](#directory-structure)
5. [Building the Project](#building-the-project)
6. [Usage Guide](#usage-guide)
7. [Filter Types Reference](#filter-types-reference)
8. [Adding New Filters](#adding-new-filters)
9. [SQL Files](#sql-files)
10. [Development Guidelines](#development-guidelines)

---

## Project Overview

`odbfilter` is a Fortran/C tool for filtering and modifying observations in ODB (Ocean Data Base) databases, specifically CCMA (Current Cycle Model Analysis) and ECMA (Earlier Cycle Model Analysis) databases used in numerical weather prediction.

The tool allows you to:
- Select specific observations based on criteria (observation type, time slot, location, etc.)
- Delete observations by setting them as "passive"
- Modify observation data (copy departures, update values)
- Process radar, GPS, satellite, and conventional observations

---

## Background: ODB Databases

ODB (Ocean Data Base) is a database system used at ECMWF for storing observation data.

### CCMA (Current Cycle Model Analysis)
- Contains observations for the current analysis cycle
- Used for data assimilation

### ECMA (Earlier Cycle Model Analysis)  
- Contains observations from earlier cycles
- Used for verification and monitoring

### Key Concepts
- **Active/Passive**: Observations can be marked as active (used) or passive (ignored)
- **obstype**: Observation type (e.g., 5=TEMP, 120=AMSU-A)
- **varno**: Variable number (e.g., 2=temperature, 7=u-wind, 8=v-wind)
- **timeslot**: Time slot within the assimilation window

---

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    odb_filter (main)                    │
│                  src/filter.F90                         │
│                                                         │
│  Parses command line → Selects filter type →           │
│  Calls ODB_select/get/put to modify observations       │
└────────────────────┬────────────────────────────────────┘
                     │
        ┌────────────┴────────────┐
        │                         │
┌───────▼────────┐      ┌────────▼──────────┐
│ odb_filter_mod │      │   SQL Queries     │
│ src/odb_...F90 │      │   src/*.sql       │
│                 │      │                   │
│ - Parse args    │      │ - select_*.sql    │
│ - ODB env setup │      │ - copy_*.sql      │
│ - ODB open/close│      │ - update_*.sql    │
└────────────────┘      └───────────────────┘
        │
┌───────▼────────────────────────────────────┐
│         ODB Library (external)             │
│  - libcma-odb, libodb, libifsaux          │
│  - odb98.x (SQL processor)                 │
└────────────────────────────────────────────┘
```

### Source Files

| File | Purpose |
|------|---------|
| `src/filter.F90` | Main program with filter logic for each filter type |
| `src/odb_filter_mod.F90` | Module: argument parsing, ODB env setup, cleanup |
| `src/_odb_glue.c` | C glue code for ODB function registration |
| `src/CCMA_Sstatic.c` | CCMA schema static initializer |
| `src/ECMA_Sstatic.c` | ECMA schema static initializer |

---

## Directory Structure

```
odbfilter/
├── CMakeLists.txt          # CMake build configuration
├── README.md              # Quick start guide
├── DOCS.md                # This documentation
├── AGENTS.md              # Development guidelines for AI agents
├── .gitignore             # Git ignore rules
│
├── src/                   # Source files
│   ├── *.F90             # Fortran source files
│   ├── *.c               # C source files
│   └── *.sql             # SQL query definitions
│
├── scripts/               # Utility scripts
│   ├── install.sh        # Legacy build script
│   ├── odb_filter.sh    # Example run script
│   ├── odbtbx.sh        # ODB toolbox script
│   ├── CCMA2ECMA        # Perl: Convert CCMA to ECMA
│   └── create_ioassign   # Create IOASSIGN file
│
└── build/                 # Build directory (generated)
```

---

## Building the Project

### Prerequisites

- **Fortran compiler**: gfortran (>=4.8) or Intel ifort
- **C compiler**: gcc
- **ODB libraries**: libcma-odb, libodb, libmain-odb, libifsaux
- **NetCDF**: libnetcdf, libnetcdff (Fortran)
- **ODB tools**: odb98.x (SQL processor)
- **Optional**: Fiat library for additional functionality

### Method 1: CMake (Recommended)

```bash
# Clone the repository
cd $HOME
git clone https://github.com/meteoea/odbfilter.git
cd odbfilter

# Create build directory
mkdir -p build && cd build

# Configure (adjust paths to your ODB installation)
cmake .. \
  -DLIBNCDF=/path/to/netcdf/lib \
  -DLIBNCDFF=/path/to/netcdff/lib \
  -DINC_CCMA=/path/to/odb/ddl.CCMA \
  -DINC_ECMA=/path/to/odb/ddl.ECMA \
  -DTYPE_PACK=local

# Build
make

# Install (optional)
make install
```

### Method 2: install.sh (Legacy)

The `install.sh` script expects to be run from within an ODB "pack" directory with proper `.gmkfile` configuration.

```bash
cd /path/to/your/pack
odbfilter/scripts/install.sh
```

This will:
1. Process all `.sql` files with `odb98.x`
2. Compile C and Fortran sources
3. Link against ODB libraries
4. Create `odb_filter` executable in `odbfilter/odbfilter/` directory

### CMake Options

| Option | Default | Description |
|--------|---------|-------------|
| `TYPE_PACK` | `local` | Pack type: `local` or `main` |
| `LIBNCDF` | `` | Path to NetCDF library |
| `LIBNCDFF` | `` | Path to NetCDF Fortran library |
| `FIAT_DIR` | `` | Path to Fiat installation |
| `INC_CCMA` | `src/local/odb/ddl.CCMA` | CCMA include directory |
| `INC_ECMA` | `src/local/odb/ddl.ECMA` | ECMA include directory |

---

## Usage Guide

### Basic Syntax

```bash
odb_filter <filter_type> [arguments...]
```

### Environment Setup

Before running `odb_filter`, ensure ODB environment is set up:

```bash
export ODB_SRCPATH_CCMA=/path/to/CCMA
export ODB_DATAPATH_CCMA=/path/to/CCMA
export ODB_CMA=CCMA
# ... (see scripts/odb_filter.sh for full setup)
```

### Common Examples

#### 1. Select observations by type (keep only TEMP, disable others)
```bash
odb_filter type 5
# Keeps only obstype=5 (TEMP), disables all others
```

#### 2. Delete observations by type
```bash
odb_filter deletetype 5
# Marks all TEMP observations as passive (deleted)
```

#### 3. Select by type and variable
```bash
odb_filter varno 5 2
# Selects obstype=5, varno=2 (temperature)
```

#### 4. Select single observation
```bash
odb_filter singleobs 5 2 12
# Selects obstype=5, varno=2, timeslot=12
```

#### 5. Filter by timeslot
```bash
odb_filter timeslot 6
# Selects observations in timeslot 6
```

---

## Filter Types Reference

### Selection Filters (keep matching observations)

| Filter | Arguments | Description |
|--------|------------|-------------|
| `timeslot` | `<tslot>` | Select by time slot |
| `type` | `<obstype>` | Select by observation type |
| `varno` | `<obstype> <varno>` | Select by type and variable |
| `wind` | `<obstype> <vno_u> <tslot>` | Select wind components |
| `singleobs` | `<obstype> <varno> [tslot]` | Select single observation |
| `singleradar` | `<obstype> <varno> <ident> <dist> <elev> <azimut>` | Select radar obs |
| `singlegpssol` | `<obstype> <codetype> <lon> <lat>` | Select GPS sol obs |
| `singlestatid` | `<statid>` | Select by station ID |
| `singleobsarea` | `<otype> <varno> <lonmin> <lonmax> <latmin> <latmax> <presmin> <presmax>` | Select by area |
| `singleobscanal` | `<obstype> <vertco>` | Select by channel |
| `scat` | `<tslot>` | Select scatterometer by timeslot |
| `sensor` | `<obstype> <sensor>` | Select by sensor number |
| `amsua` | none | Select AMSU-A observations |
| `sophie` | none | Custom selection (Sophie's filter) |

### Deletion Filters (mark as passive)

| Filter | Arguments | Description |
|--------|------------|-------------|
| `deletetype` | `<obstype>` | Delete by observation type |
| `deletevarno` | `<obstype> <varno>` | Delete by type and variable |
| `delete_passive` | none | Delete all passive observations |

### Modification Filters (change values)

| Filter | Arguments | Description |
|--------|------------|-------------|
| `fg_depar` | none | Copy FG departure to column 2 |
| `an_depar` | none | Copy AN departure to column 2 |
| `copy_fg_in_actual_depar` | none | Copy FG into actual departure |
| `debug` | none | Debug filter (customizable) |

### Special Filters

| Filter | Arguments | Description |
|--------|------------|-------------|
| `singleobs_sv` | `<otype> <vno> <tslot>` | Single obs with supervention |
| `singlewind` | `<otype> <vno_u> <tslot>` | Single wind observation |

---

## Adding New Filters

### Step 1: Create SQL File

Create a new SQL file in `src/` (e.g., `select_myfilter.sql`):

```sql
SELECT * FROM hdr, body
WHERE obstype = $otype
  AND varno = $vno
  AND @some_condition
```

### Step 2: Update odb_filter_mod.F90

Add a new case in `odb_filter_start()` to parse arguments:

```fortran
case ('myfilter')
  allocate(vars(2),vals(2))
  call getarg(2,cvar)
  read(unit=cvar,fmt='(I3)') ivar
  vals(1)=real(ivar)
  vars(1)="$otype"
  call getarg(3,cvar)
  read(unit=cvar,fmt='(I3)') ivar
  vals(2)=real(ivar)
  vars(2)="$vno"
```

### Step 3: Update filter.F90

Add the filter logic in the main `select case`:

```fortran
case ('myfilter')
  ! Select observations
  rc=ODB_select(odb,"select_myfilter",nrows,ncols,nra=nra, &
       setvars=vars(1:2),values=vals(1:2))
  allocate(x0(nra,0:ncols))
  rc=ODB_get(odb,"select_myfilter",x0,nrows,ncols=ncols)
  
  ! Modify all observations (disable)
  rc=ODB_select(odb,"select_all",nrows,ncols,nra=nra)
  allocate(x1(nra,0:ncols))
  rc=ODB_get(odb,"select_all",x1,nrows,ncols=ncols)
  x1(1:nra,1)=rmdi
  x1(1:nra,2)=0
  rc=ODB_put(odb,"select_all",x1,nrows,ncols=ncols)
  
  ! Re-enable selected observations
  allocate(x2(nra,0:ncols))
  rc=ODB_get(odb,"select_myfilter",x2,nrows,ncols=ncols)
  x2(1:nra,1)=x0(1:nra,1)
  x2(1:nra,2)=1
  rc=ODB_put(odb,"select_myfilter",x2,nrows,ncols=ncols)
  
  print *, "Nb obs selected: ",nrows
```

### Step 4: Register in CCMA_Sstatic.c and ECMA_Sstatic.c

Add the SQL view to both files:

```c
ODB_ANCHOR_VIEW(CCMA, select_myfilter);
```

### Step 5: Update Usage Documentation

Add the new filter to `filter.F90` usage message and to this documentation.

---

## SQL Files

### Naming Convention

- `select_*.sql` - Query for selecting observations
- `copy_*.sql` - Query for copying values between columns
- `update_*.sql` - Query for updating header status
- `delete_*.sql` - Query for deleting observations
- `hdr_set_*.sql` - Query for setting header values

### Available SQL Files

| File | Purpose |
|------|---------|
| `select_all.sql` | Select all observations |
| `select_timeslot.sql` | Select by timeslot |
| `select_obstype.sql` | Select by observation type |
| `select_obstype_varno.sql` | Select by type and variable |
| `select_obstype_wind.sql` | Select wind observations |
| `select_obstype_sensor.sql` | Select by sensor |
| `select_wind_obstype_varno_tslot.sql` | Select wind by type/varno/tslot |
| `select_scat_tslot.sql` | Select scatterometer by timeslot |
| `select_onestatid.sql` | Select by station ID |
| `select_oneobstypearea.sql` | Select by area (lat/lon) |
| `select_oneobs_gpssol.sql` | Select GPS sol observation |
| `select_oneobs_radar.sql` | Select radar observation |
| `select_oneobscanal.sql` | Select by channel |
| `select_amsua.sql` | Select AMSU-A observations |
| `select_sophie.sql` | Custom Sophie filter |
| `select_fg_actual_depar.sql` | Select FG/actual departure |
| `select_for_debug.sql` | Debug selection |
| `copy_fg_depar.sql` | Copy FG departure |
| `copy_an_depar.sql` | Copy analysis departure |
| `update_hdr_status.sql` | Update header status |
| `hdr_set_passive.sql` | Set observations as passive |
| `delete_passive.sql` | Delete passive observations |

### SQL File Structure

```sql
&hdr
  obstype@hdr,
  varno@body,
  datum_status.active@body
&body
WHERE obstype@hdr = $otype
  AND varno@body = $vno
  AND @some_condition
```

Variables prefixed with `$` are set from the Fortran code via `setvars` and `values` parameters.

---

## Development Guidelines

### Code Style

- Fortran: Use implicit none, declare all variables
- Comments: Use `!` for Fortran, `/* */` or `//` for C
- Indentation: 2-3 spaces (Fortran), 2 spaces (C)
- Line length: Max 80-120 characters

### Key Constants

```fortran
real(8), parameter :: rmdi = -2147483647  ! Real Missing Data Indicator
real(8), parameter :: PI = 3.14159265358979323846
```

### ODB API Functions

| Function | Purpose |
|----------|---------|
| `ODB_init()` | Initialize ODB |
| `ODB_open(db, mode, npools)` | Open ODB database |
| `ODB_select(odb, view, nrows, ncols, nra, setvars, values)` | Select data |
| `ODB_get(odb, view, data, nrows, ncols)` | Get selected data |
| `ODB_put(odb, view, data, nrows, ncols)` | Put (update) data |
| `ODB_close(odb, commit)` | Close ODB (commit or rollback) |
| `ODB_end()` | Cleanup ODB |

### Data Array Layout

The `x0`, `x1`, `x2` arrays have this layout:
- Column 0: Row index / sequence number
- Column 1: Original value (often used for datum_status.active)
- Column 2: New value (1=active, 0=passive, or new data value)

### Testing

1. Build in debug mode: `cmake .. -DCMAKE_BUILD_TYPE=Debug`
2. Run with a small test database
3. Verify selected observations with `odbtools` or `shuffle`
4. Check ODB log files for errors

### Git Workflow

```bash
# Create feature branch
git checkout -b feature/my-new-filter

# Make changes, commit
git add -A
git commit -m "Add my new filter"

# Push to remote
git push origin feature/my-new-filter
```

---

## Troubleshooting

### Common Issues

| Problem | Solution |
|---------|-----------|
| `odb98.x not found` | Install ODB tools, add to PATH |
| `CCMA.h not found` | Run `odb98.x` to generate headers from SQL |
| `libcma-odb not found` | Set `LIBNCDF`/`LIBNCDFF` in CMake or `.gmkfile` |
| `Fortran compiler not found` | Install gfortran or ifort |
| `ODB_select fails` | Check SQL syntax, verify ODB environment |

### Getting Help

- Check `scripts/odb_filter.sh` for proper ODB environment setup
- Review SQL files for query examples
- Examine `src/filter.F90` for filter implementation patterns
- Consult ODB documentation at ECMWF

---

*Documentation generated on April 2026*
