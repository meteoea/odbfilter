# odbfilter Examples

## Command-Line Usage

### Basic Syntax

```bash
odb_filter <filter_type> [arguments]
```

All filters read from a CCMA database and modify observation statuses.

---

## Filter Examples

### 1. Select Observations by Time Slot

**Filter**: `timeslot`

**Purpose**: Keep only observations from a specific time slot.

```bash
odb_filter timeslot 12
```

- Selects observations from time slot 12
- All other observations are marked as passive

---

### 2. Keep Only Specific Observation Type

**Filter**: `type`

**Purpose**: Keep only observations of a given type, mark others as passive.

```bash
# Keep only TEMP observations (obstype=5)
odb_filter type 5
```

**Common Observation Types**:
- `5`: TEMP (radiosondes)
- `4`: SYNOP (surface stations)
- `3`: AIREP (aircraft)
- `2`: DRIBU (drifting buoys)
- `1`: TEMP SHIP (ships)

---

### 3. Delete Specific Observation Type

**Filter**: `deletetype`

**Purpose**: Delete all observations of a given type.

```bash
# Delete all TEMP observations
odb_filter deletetype 5
```

This sets `DATUM_STATUS.ACTIVE=0` and `REPORT_STATUS.ACTIVE=0`.

---

### 4. Filter by Observation Type and Variable

**Filter**: `varno`

**Purpose**: Keep observations matching both type and variable number.

```bash
# Keep TEMP temperature observations (varno=2)
odb_filter varno 5 2
```

**Common Variable Numbers**:
- `2`: Temperature
- `3`: Pressure
- `4`: Specific humidity
- `7`: Wind u-component
- `8`: Wind v-component

---

### 5. Select Single Observation

**Filter**: `singleobs`

**Purpose**: Select a single observation of specified type/varno.

```bash
# Select one TEMP temperature observation
odb_filter singleobs 5 2

# Select one TEMP observation from timeslot 6
odb_filter singleobs 5 2 6

# Select 3 TEMP observations
odb_filter singleobs 5 2 6 3
```

**Arguments**:
1. `obstype`: Observation type
2. `varno`: Variable number
3. `[timeslot]`: Optional time slot
4. `[nb_obs]`: Optional number of observations to select (default: 1)

---

### 6. Select Wind Observations

**Filter**: `wind`

**Purpose**: Select wind observations (u and v components).

```bash
# Select wind observations for TEMP (obstype=5), varno_u=7
odb_filter wind 5 7 6 1
```

**Arguments**:
1. `obstype`: Observation type
2. `varno_u`: Wind u-component variable number
3. `timeslot`: Time slot
4. `partition`: Partition number

---

### 7. Filter by Geographic Area

**Filter**: `singleobsarea`

**Purpose**: Select observations within a geographic area.

```bash
# Select TEMP obs in area: lon -10 to 10, lat 40 to 50
odb_filter singleobsarea 5 2 -10 10 40 50

# Also filter by pressure: 950 to 1050 hPa
odb_filter singleobsarea 5 2 -10 10 40 50 950 1050
```

**Arguments**:
1. `obstype`: Observation type
2. `varno`: Variable number
3. `lonmin`, `lonmax`: Longitude range
4. `latmin`, `latmax`: Latitude range
5. `[presmin]`, `[presmax]`: Optional pressure range (hPa)

---

### 8. Filter by Station ID

**Filter**: `singlestatid`

**Purpose**: Select observations from a specific station.

```bash
# Select observations from station 12345
odb_filter singlestatid 12345
```

**Arguments**:
1. `statid`: Station ID

---

### 9. Filter Scatterometer Observations

**Filter**: `scat`

**Purpose**: Select scatterometer observations for a time slot.

```bash
# Select scatterometer obs from timeslot 6
odb_filter scat 6

# Select 5 scatterometer observations
odb_filter scat 6 5
```

**Arguments**:
1. `timeslot`: Time slot
2. `[nb_obs]`: Optional number of observations (default: 1)

---

### 10. Filter by Sensor

**Filter**: `sensor`

**Purpose**: Select observations from a specific sensor.

```bash
# Select TEMP observations from sensor 12
odb_filter sensor 5 12
```

**Arguments**:
1. `obstype`: Observation type
2. `sensor`: Sensor number

---

### 11. Select Single Radar Observation

**Filter**: `singleradar`

**Purpose**: Select a single radar observation with specific criteria.

```bash
# Select radar observation
odb_filter singleradar 5 2 "IDENT123" 100.5 500 45.0
```

**Arguments**:
1. `obstype`: Observation type
2. `varno`: Variable number
3. `ident`: Identifier (quoted string)
4. `distance`: Distance (km)
5. `elev`: Elevation (m)
6. `azimut`: Azimuth (degrees)

---

### 12. Select Single GPS Solution

**Filter**: `singlegpssol`

**Purpose**: Select a single GPS solution observation.

```bash
# Select GPS observation at given position
odb_filter singlegpssol 17 76 2.5 48.8
```

**Arguments**:
1. `obstype`: Observation type (17=GPS)
2. `codetype`: Code type
3. `lon`: Longitude
4. `lat`: Latitude

---

### 13. Filter by Channel (Canal)

**Filter**: `singleobscanal`

**Purpose**: Select observations by satellite channel.

```bash
# Select AMSU-A channel 5
odb_filter singleobscanal 4 2 5
```

**Arguments**:
1. `obstype`: Observation type
2. `vertco`: Vertical coordinate (channel number)

---

### 14. Custom Selection (Sophie)

**Filter**: `sophie`

**Purpose**: Custom selection for Sophie's analysis.

```bash
odb_filter sophie
```

This filter uses predefined criteria (check `sql/select_sophie.sql` for details).

---

### 15. Copy First Guess Departures

**Filter**: `fg_depar`

**Purpose**: Copy first guess departures to a different column.

```bash
odb_filter fg_depar
```

Modifies the database by copying `fg_depar` values to column 2.

---

### 16. Copy Analysis Departures

**Filter**: `an_depar`

**Purpose**: Copy analysis departures to a different column.

```bash
odb_filter an_depar
```

Modifies the database by copying `an_depar` values to column 2.

---

### 17. Delete Passive Observations

**Filter**: `delete_passive`

**Purpose**: Permanently delete all passive observations.

```bash
odb_filter delete_passive
```

Removes observations where `DATUM_STATUS.ACTIVE=0`.

---

### 18. Debug Filter

**Filter**: `debug`

**Purpose**: Run a debug selection for troubleshooting.

```bash
odb_filter debug
```

Uses `sql/select_for_debug.sql` for special debugging criteria.

---

## Using Wrapper Scripts

### odb_filter.sh

Sets up ODB environment and runs `odb_filter`:

```bash
# Basic usage
scripts/odb_filter.sh type 5

# With shuffle
scripts/odb_filter.sh singleobs 5 2
```

This script also:
1. Performs shuffle (CCMA → ECMA)
2. Copies first guess departures (`odb_filter fg_depar`)

---

### odbtbx.sh (Toolbox)

Provides filter and shuffle functions:

```bash
# Apply filter
scripts/odbtbx.sh -f type 5

# Perform shuffle
scripts/odbtbx.sh -s

# Both filter and shuffle
scripts/odbtbx.sh -f singleobs 5 2 -s
```

**Options**:
- `-f`: Apply specified filter
- `-s`: Perform shuffle operation

---

### CCMA2ECMA

Converts a CCMA database to pseudo-ECMA format:

```bash
# In a directory containing CCMA/
scripts/CCMA2ECMA
```

This script:
1. Renames `CCMA/` to `ECMA/`
2. Filters IOASSIGN file
3. Replaces "CCMA" with "ECMA" in file contents
4. Recreates IOASSIGN symlinks

---

## Advanced Scenarios

### Batch Processing Multiple Filters

```bash
# Process multiple time slots
for ts in 1 2 3 4 5 6; do
  odb_filter timeslot $ts
done
```

### Combining Filters

```bash
# First select by type, then by area
odb_filter type 5
odb_filter singleobsarea 5 2 -10 10 40 50
```

### Working with Wrapper Scripts in Production

```bash
# Set up environment
export ODB_CMA=CCMA
export ODB_SRCPATH_CCMA=/path/to/odb/src/main/odb/ddl.CCMA
export ODB_DATAPATH_CCMA=/path/to/data

# Run filter with shuffle
scripts/odbtbx.sh -f singleobs 5 2 -s
```

---

## Verifying Results

### Check Active Observations

After running a filter, verify the results:

```bash
# Use ODB tools to check
odbsql "SELECT obstype, varno, COUNT(*) FROM hdr, body WHERE datum_status.active=1 GROUP BY obstype, varno"
```

### Check Report Status

```bash
# Check report_status values
odbsql "SELECT report_status.active, COUNT(*) FROM hdr GROUP BY report_status.active"
```

---

## Common Patterns

### Keep Only One Observation Type

```bash
odb_filter type 5  # Keep only TEMP
```

### Select Specific Observations

```bash
odb_filter singleobs 5 2 6  # One TEMP temp obs from timeslot 6
```

### Filter by Area

```bash
odb_filter singleobsarea 5 2 -10 10 40 50  # TEMP in area
```

### Work with Wind

```bash
odb_filter wind 5 7 6 1  # TEMP wind from timeslot 6
```

---
