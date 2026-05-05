# odbfilter User Guide

## Overview

odbfilter is a tool for filtering and updating ODB (Observations Data Base) databases used in numerical weather prediction. It allows you to selectively activate or deactivate observations based on customizable SQL requests.

### Key Features

- Filter observations by type, time slot, geographic area, and more
- Works with CCMA and ECMA database schemas
- Customizable SQL views for complex filtering logic
- Integration with ODB shuffle operations (CCMA <-> ECMA)

---

## Installation

### Prerequisites

- **ODB libraries** (libcma-odb, libodb, libmain-odb, libifsaux) - typically from a pack
- **NetCDF** (C and Fortran libraries)
- **Fortran compiler** (gfortran or Intel ifort)
- **C compiler** (gcc or Intel icc)
- **CMake** (version 3.10 or higher)
- **odb98.x** (ODB SQL compiler, from ODB installation)

### Build with CMake (Recommended)

```bash
cd odbfilter
mkdir build && cd build
cmake .. \
  -DLIBNCDF=/path/to/netcdf \
  -DLIBNCDFF=/path/to/netcdff
make
make install
```

### Build in a Pack Environment

For IAL gmkpack environments (CY49T1, CY50T2, etc.), use the provided build script:

```bash
./build_for_pack.sh
```

This script:
- Loads the correct environment modules
- Extracts NetCDF paths from pack configuration
- Configures CMake with appropriate compiler and library paths
- Builds and installs the project

### Build Options

| Option | Description | Default |
|--------|-------------|---------|
| `-DPACK=` | Pack root directory | `${CMAKE_SOURCE_DIR}` |
| `-DTYPE_PACK=` | Pack type: "main" (production) or "local" (development) | "main" |
| `-DLIBNCDF=` | NetCDF C library path | "" |
| `-DLIBNCDFF=` | NetCDF Fortran library path | "" |
| `-DFIAT_DIR=` | Fiat library installation directory (optional) | "" |

---

## Quick Start

### Basic Usage

```bash
odb_filter <filter_type> [arguments]
```

The `odb_filter` executable reads from a CCMA database and modifies observation statuses based on the specified filter type.

### Filter Types

| Filter Type | Description | Arguments |
|-------------|-------------|------------|
| `timeslot` | Select observations for a specific time slot | `timeslot` |
| `type` | Keep only specified observation type | `obstype` |
| `deletetype` | Delete specified observation type | `obstype` |
| `varno` | Filter by observation type and variable number | `obstype`, `varno` |
| `wind` | Filter wind observations (u/v components) | `obstype`, `varno_u`, `timeslot`, `partition` |
| `singleobs` | Select single observation of specified type/varno | `obstype`, `varno`, `[timeslot]`, `[nb_obs]` |
| `singlewind` | Select single wind observation | `obstype`, `varno_u`, `timeslot`, `[nb_obs]` |
| `scat` | Filter scatterometer observations | `timeslot`, `[nb_obs]` |
| `sensor` | Filter by observation type and sensor | `obstype`, `sensor` |
| `singleradar` | Select single radar observation | `obstype`, `varno`, `ident`, `distance`, `elev`, `azimut` |
| `singlegpssol` | Select single GPS sol observation | `obstype`, `codetype`, `lon`, `lat` |
| `singlestatid` | Filter by station ID | `statid` |
| `singleobsarea` | Select observation in geographic area | `obstype`, `varno`, `lonmin/max`, `latmin/max`, `presmin/max` |
| `singleobscanal` | Filter by channel (canal) | `obstype`, `vertco` |
| `sophie` | Custom selection for Sophie | - |
| `fg_depar` | Copy first guess departures | - |
| `an_depar` | Copy analysis departures | - |
| `delete_passive` | Delete passive observations | - |
| `debug` | Debug filter | - |

---

## Common Use Cases

### Disable All Observations Except One TEMP Temperature

```bash
odb_filter singleobs 5 2
```

This selects only TEMP temperature observations (obstype=5, varno=2).

### Keep Only TEMP Observations

```bash
odb_filter type 5
```

Marks all non-TEMP observations as passive.

### Delete All TEMP Observations

```bash
odb_filter deletetype 5
```

Removes all TEMP observations from the database.

### Select Observations for a Specific Time Slot

```bash
odb_filter timeslot 12
```

Keeps only observations from time slot 12.

### Filter by Geographic Area

```bash
odb_filter singleobsarea 5 2 -10 10 40 50 950 1050
```

Selects observations of type 5, varno 2 within:
- Longitude: -10 to 10
- Latitude: 40 to 50
- Pressure: 950 to 1050 hPa

---

## Using Wrapper Scripts

### odb_filter.sh

Wrapper script that sets up the ODB environment and runs `odb_filter`:

```bash
scripts/odb_filter.sh <filter_type> [arguments]
```

This script also performs a shuffle operation (CCMA → ECMA) and copies first guess departures.

### odbtbx.sh

Toolbox script providing filter and shuffle functions:

```bash
# Apply filter
scripts/odbtbx.sh -f <filter_type> [arguments]

# Perform shuffle
scripts/odbtbx.sh -s
```

### CCMA2ECMA

Converts a CCMA database to a pseudo-ECMA database:

```bash
scripts/CCMA2ECMA
```

This is useful for converting conventional observation data to model equivalent format.

---

## Adding Custom SQL Filters

To add a new filter:

1. Create a new SQL file in `sql/` (e.g., `my_filter.sql`)
2. Define your SQL view following the existing pattern
3. Re-run CMake to auto-detect the new SQL file
4. Modify `src/filter.F90` and `src/odb_filter_mod.F90` to use your new filter

Example SQL file (`sql/my_filter.sql`):

```sql
//
//-- ODB/SQL file 'my_filter.sql'
//

UPDATED;

SET $my_param = 100;

CREATE VIEW my_filter AS
  SELECT obsvalue UPDATED
  FROM   hdr, body, errstat
  WHERE  varno = $my_param;
```

---

## Troubleshooting

### "odb98.x not found"

Ensure ODB is installed and `odb98.x` is in your PATH, or set `-DODB_COMPILER=/path/to/odb98.x`.

### "ODB library not found"

Check that your pack environment is correctly set up, or specify library paths manually with `-DPACK=/path/to/pack`.

### Compilation errors with generated C files

The C files (`_odb_glue.c`, `*_Sstatic.c`) are auto-generated in the build directory. If you encounter issues:
1. Clean the build: `rm -rf build && mkdir build`
2. Re-run CMake: `cd build && cmake ..`
3. Check that all `ddl.*` directories are correctly set up

---
