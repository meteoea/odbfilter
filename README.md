 
odbfilter 
========

This tool allows a ODB (Observations Data Base) database (CCMA or ECMA) to be updated according to customizable SQL requests.

Documentation
-------------

- **User Guide**: [doc/user-guide.md](doc/user-guide.md) - Installation, usage, and examples
- **Developer Guide**: [doc/developer-guide.md](doc/developer-guide.md) - Build system, architecture, contributing
- **Technical Reference**: [doc/technical-reference.md](doc/technical-reference.md) - ODB, SQL, macros, functions
- **Examples**: [doc/examples.md](doc/examples.md) - Detailed usage examples

Directory Structure
------------------

```
odbfilter/
├── CMakeLists.txt      # CMake build configuration
├── README.md          # This file
├── src/               # Source files (.F90, .c)
├── sql/               # SQL view definitions
├── scripts/           # Shell and Perl scripts
├── cmake/templates/   # C file templates
├── doc/               # Documentation (see links above)
├── build_for_pack.sh   # Build script for pack environments
└── build/             # Build directory (cmake)
```

Installation
------------

`cd $HOME`

`git clone https://github.com/meteoea/odbfilter.git`

Usage
----

Add a new SQL request or edit an existing one ( See: `sql/*.sql` )
If needed, update `src/odb_filter_mod.F90` and `src/filter.F90` which are in charge of modifying the ODB data.
`odb_filter` must be linked with ODB libraries in a pack

Compile with CMake (Recommended)
-------------------------------

Prerequisites: ODB libraries, NetCDF, Fortran compiler (gfortran/ifort)

```bash
cd odbfilter
mkdir build && cd build
cmake .. -DLIBNCDF=/path/to/netcdf -DLIBNCDFF=/path/to/netcdff
make
make install
```

Compile in Pack Environment
-------------------------------

For ECMWF pack environments (CY49T1, CY50T2, etc.):

```bash
cd odbfilter
./build_for_pack.sh
```

Examples
-------

- Disable in a CCMA all observations but one TEMP temperature:
	`odb_filter singleobs 5 2`
- Disable in a CCMA all observations but TEMP:
	`odb_filter type 5`
- Disable in a CCMA all TEMP observations:
	`odb_filter deletetype 5`
	
For more examples, see [doc/examples.md](doc/examples.md).

---

This tool allows a ODB (Observations Data Base) database (CCMA or ECMA) to be updated according to customizable SQL requests.

For detailed documentation, see the [doc/](doc/) directory.


This tool allows a ODB database ( CCMA or ECMA ) to be updated according to
customizable SQL requests.

Installation
------------

`cd $HOME`

`git clone https://github.com/meteoea/odbfilter.git`

Usage
-----

Add a new SQL request or edit an existing one ( See: *.sql )
If needed, update `odb_filter_mod.F90` and `filter.F90` which are in charge of modifying the ODB data.
`odb_filter` must be linked with ODB libraries in a pack

Compile
-------

`cd $HOME/pack/[mypack]`

`$HOME/odbfilter/install.sh`

Examples
--------

- Disable in a CCMA all observations but one TEMP temperature:
	`$HOME/pack/[mypack]/odbfilter/odb_filter singleobs 5 2`
- Disable in a CCMA all observations but TEMP:
	`$HOME/pack/[mypack]/odbfilter/odb_filter type 5`
- Disable in a CCMA all TEMP observations:
	`$HOME/pack/[mypack]/odbfilter/odb_filter deletetype 5`
	
	
...
