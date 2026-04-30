# odbfilter Developer Guide

## Project Structure

```
odbfilter/
+-- CMakeLists.txt              # Main CMake build configuration
+-- build_for_pack.sh          # Build script for pack environments
+-- README.md                  # Project overview and quick start
+-- cmake/
|   +-- templates/
|       +-- _odb_glue.c.in    # Template for ODB glue code
|       +-- _Sstatic.c.in     # Template for schema static initializers
+-- src/
|   +-- filter.F90             # Main Fortran program
|   +-- odb_filter_mod.F90    # Fortran module (init/cleanup)
|   +-- _odb_glue.c          # Generated: ODB entry point (in build/)
|   +-- *_Sstatic.c          # Generated: Schema initializers (in build/)
+-- sql/                       # SQL view definitions
|   +-- select_all.sql
|   +-- select_obstype.sql
|   +-- ... (23 SQL files total)
+-- ddl.CCMA -> sql/          # Schema symlink (auto-detected)
+-- ddl.ECMA -> sql/          # Schema symlink (auto-detected)
+-- scripts/
|   +-- odb_filter.sh        # Wrapper script with ODB environment
|   +-- odbtbx.sh            # Toolbox: filter + shuffle
|   +-- CCMA2ECMA           # Convert CCMA to ECMA format
|   +-- create_ioassign      # Create IOASSIGN file
+-- doc/                      # Documentation (this directory)
|   +-- user-guide.md
|   +-- developer-guide.md   # (this file)
|   +-- technical-reference.md
|   +-- examples.md
+-- build/                    # Build directory (generated)
```

---

## Build System

### Overview

The project uses CMake (minimum version 3.10) with a custom build process:

1. **Auto-detection**: Scans for `ddl.*` directories to identify database schemas
2. **Code Generation**: Uses `configure_file()` with templates in `cmake/templates/`
3. **SQL Processing**: Compiles `.sql` files to `.o` using `odb98.x`
4. **Linking**: Links against ODB libraries and dependencies

### CMakeLists.txt Structure

The main `CMakeLists.txt` is organized into these sections:

```
1. Project setup and options
2. Schema auto-detection (ddl.* directories)
3. SQL file discovery
4. Find dependencies (NetCDF, ODB, Fiat)
5. Set include directories
6. Generate C files from templates
7. Add schema subdirectories (sql/CMakeLists.txt)
8. Set compilation flags
9. Create object libraries
10. Main executable target
11. Link libraries
12. Installation rules
```

### Adding a New Schema

To add support for a new ODB schema (e.g., "TEST"):

```bash
cd /home/arbogaste/git/odbfilter
ln -s sql ddl.TEST
rm -rf build && mkdir build && cd build && cmake ..
```

CMake will automatically:
- Detect `ddl.TEST` in the glob scan
- Add "TEST" to the `_SCHEMAS` list
- Generate `build/src/TEST_Sstatic.c` from template
- Add `TEST_lib` target from SQL processing
- Update `_odb_glue.c` with `Static_Init(TEST);`

### Template System

#### `cmake/templates/_odb_glue.c.in`

This template generates the ODB entry point code. Key placeholders:

- `@STATIC_INIT_CALLS@`: Replaced with `Static_Init(CCMA);`, `Static_Init(ECMA);`, etc.

#### `cmake/templates/_Sstatic.c.in`

This template generates schema-specific static initializers. Key placeholders:

- `@SCHEMA@`: Replaced with schema name (CCMA, ECMA, etc.)
- `@ODB_ANCHOR_VIEWS@`: Replaced with `ODB_ANCHOR_VIEW()` calls for each SQL view

### Generated Files

All generated C files are placed in `${CMAKE_BINARY_DIR}/src/` (not the source directory):

- `_odb_glue.c`: ODB entry point with `codb_set_entrypoint_()`
- `CCMA_Sstatic.c`: CCMA schema initializer
- `ECMA_Sstatic.c`: ECMA schema initializer

This keeps the source directory clean and allows out-of-source builds.

---

## Code Architecture

### Main Program (`src/filter.F90`)

The main Fortran program that:
1. Parses command-line arguments to determine filter type
2. Initializes ODB environment via `odb_filter_start()`
3. Routes to appropriate filter logic (select case)
4. Reads/modifies/writes observations
5. Cleans up via `odb_filter_end()`

**Supported Filters** (18 total):
- `timeslot`, `type`, `deletetype`, `varno`, `wind`
- `singleobs`, `singlewind`, `scat`, `sensor`
- `singleradar`, `singlegpssol`, `singlestatid`
- `singleobsarea`, `singleobscanal`, `sophie`
- `fg_depar`, `an_depar`, `delete_passive`, `debug`

### Module (`src/odb_filter_mod.F90`)

Provides initialization and cleanup routines:

- **`odb_filter_start()`**: Sets up ODB environment, parses arguments, opens database
- **`odb_filter_end()`**: Updates header status, closes database
- **`odb_env()`**: Configures ODB environment variables

### C Glue Code

#### `_odb_glue.c` (Generated)

Provides the interface between ODB library and odbfilter:

- **`codb_set_entrypoint_()`**: Called by ODB to register schema initializers
- **`Static_Init(db)` macro**: Registers a schema's `db_static_init()` function
- **`ctxprint_()`**: Dummy callback for ODB

#### `*_Sstatic.c` (Generated per schema)

Schema-specific static initializers:

- **`CCMA_static_init()`**: Registers all CCMA SQL views
- **`ECMA_static_init()`**: Registers all ECMA SQL views
- Uses `ODB_ANCHOR()` and `ODB_ANCHOR_VIEW()` macros

---

## Adding New Features

### Adding a New Filter Type

1. **Create SQL file** in `sql/`:
   ```sql
   //
   //-- ODB/SQL file 'my_filter.sql'
   //
   UPDATED;
   SET $my_param = 100;
   CREATE VIEW my_filter AS
     SELECT obsvalue UPDATED
     FROM   hdr, body
     WHERE  varno = $my_param;
   ```

2. **Update `src/odb_filter_mod.F90`**:
   - Add variable: `$my_param`
   - Parse argument in `odb_filter_start()`

3. **Update `src/filter.F90`**:
   - Add case in select case: `case ('myfilter')`
   - Implement filter logic

4. **Rebuild**:
   ```bash
   cd build && cmake .. && make
   ```

### Adding a New SQL View

Simply add a new `.sql` file to `sql/`. CMake will:
- Auto-detect the new file
- Add `ODB_ANCHOR_VIEW()` call to each schema's `_Sstatic.c`

### Modifying Templates

To change the generated C code:

1. Edit `cmake/templates/_odb_glue.c.in` or `_Sstatic.c.in`
2. Rebuild: `cd build && cmake .. && make`

---

## Build Options

### CMake Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `PACK` | Pack root directory | `${CMAKE_SOURCE_DIR}` |
| `TYPE_PACK` | "main" (production) or "local" (dev) | "main" |
| `ODB_COMPILER` | Path to odb98.x | `${PACK}/sys` |
| `INC_CMA` | CMA include directory | `${PACK}/src/${TYPE_PACK}/odb/ddl` |
| `INC_ODB` | ODB module directory | `${PACK}/src/${TYPE_PACK}/odb/module` |
| `LIBNCDF` | NetCDF C library path | "" |
| `LIBNCDFF` | NetCDF Fortran library path | "" |
| `FIAT_DIR` | Fiat library installation directory | "" |

### Compilation Flags

- **`-DWITHOUT_OML`**: Compiled into all C files (disables Ocean Model Library support)
- **Fortran flags**: Also use `-DWITHOUT_OML`

---

## Dependencies

### Required

- **ODB Libraries**: `libcma-odb`, `libodb`, `libmain-odb`, `libifsaux`
- **odb98.x**: ODB SQL compiler (from ODB installation)
- **NetCDF**: `libnetcdf`, `libnetcdff`
- **Compilers**: C (gcc/icc), Fortran (gfortran/ifort)

### Optional

- **Fiat**: Fiat library (set `FIAT_DIR` to enable)

---

## Testing

### Manual Testing

```bash
# Build
cd build && make

# Run a simple filter
cd /path/to/CCMA/database
odb_filter type 5

# Verify results
# (Check that only obstype=5 observations are active)
```

### Adding New Tests

1. Create test SQL files in `sql/`
2. Add test cases to `src/filter.F90`
3. Document test scenarios in `doc/examples.md`

---

## Contributing

### Code Style

- **Fortran**: Follow existing indentation (2 spaces)
- **C**: Follow existing style (2 spaces, K&R braces)
- **CMake**: Use comments for major sections, keep variable names descriptive

### Commit Messages

Follow conventional commit format:
- `feat:` New features
- `fix:` Bug fixes
- `docs:` Documentation updates
- `refactor:` Code refactoring
- `build:` Build system changes

---

## Debugging

### Common Issues

**"odb98.x not found"**
- Set `ODB_COMPILER` CMake variable
- Or ensure `odb98.x` is in PATH

**"Schema not detected"**
- Check `ddl.*` symlinks exist
- Run `cmake ..` in build directory to re-detect

**Link errors**
- Verify ODB libraries are in pack directory
- Check `PACK` and `TYPE_PACK` settings

### Debug Output

The `codb_set_entrypoint_()` function prints debug info when `myproc == 1`:
```
codb_set_entrypoint_(dbname='CCMA', dbname_len=4)
```

Enable by setting `myproc = 1` in the source code.

---
