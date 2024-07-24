
odbfilter 
=========

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