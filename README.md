
odbfilter 
=========

This tool allows a ODB database ( CCMA or ECMA ) to be updated according to
customizable SQL requests.

Directory Structure
------------------

```
odbfilter/
├── CMakeLists.txt      # CMake build configuration
├── README.md          # This file
├── AGENTS.md          # Development guidelines
├── src/               # Source files (.F90, .c, .sql)
├── scripts/           # Shell and Perl scripts
└── build/             # Build directory (cmake)
```

Installation
------------

`cd $HOME`

`git clone https://github.com/meteoea/odbfilter.git`

Usage
-----

Add a new SQL request or edit an existing one ( See: `src/*.sql` )
If needed, update `src/odb_filter_mod.F90` and `src/filter.F90` which are in charge of modifying the ODB data.
`odb_filter` must be linked with ODB libraries in a pack

Compile with CMake (Recommended)
--------------------------------

Prerequisites: ODB libraries, NetCDF, Fortran compiler (gfortran/ifort)

```bash
cd odbfilter
mkdir build && cd build
cmake .. -DLIBNCDF=/path/to/netcdf -DLIBNCDFF=/path/to/netcdff
make
make install
```

Compile with install.sh (Legacy)
-------------------------------

`cd $HOME/pack/[mypack]`

`odbfilter/scripts/install.sh`

Examples
--------

- Disable in a CCMA all observations but one TEMP temperature:
	`odb_filter singleobs 5 2`
- Disable in a CCMA all observations but TEMP:
	`odb_filter type 5`
- Disable in a CCMA all TEMP observations:
	`odb_filter deletetype 5`
	
	...


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