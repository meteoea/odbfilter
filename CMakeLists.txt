# CMakeLists.txt for odbfilter project
# 
# This project filters ODB (Observations Data Base) data using SQL-like queries.
# It auto-detects database schemas from ddl.* directories and generates
# the necessary C glue code from templates in cmake/templates/.
#
# Build instructions:
#   mkdir build && cd build && cmake .. && make
#
# Adding a new schema:
#   ln -s sql ddl.NEWSCHEMA
#   (re-run cmake to auto-detect and generate code)

cmake_minimum_required(VERSION 3.10)
project(odbfilter Fortran C)

enable_language(Fortran)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

# Project configuration options
set(PACK ${CMAKE_SOURCE_DIR} CACHE PATH "Pack directory - root of ODB installation")
set(TYPE_PACK "main" CACHE STRING "Pack type: 'main' or 'local'")

# Auto-detect ddl.* directories (e.g., ddl.CCMA, ddl.ECMA)
# These are typically symlinks to the sql/ directory
# Populates _SCHEMAS variable with schema names (CCMA, ECMA, etc.)
file(GLOB _DDL_DIRS "ddl.*")
set(_SCHEMAS "")
foreach(_ddl ${_DDL_DIRS})
  if(IS_DIRECTORY ${_ddl} OR IS_SYMLINK ${_ddl})
    get_filename_component(_schema ${_ddl} EXT)
    string(REPLACE "." "" _schema ${_schema})
    list(APPEND _SCHEMAS ${_schema})
  endif()
endforeach()
list(REMOVE_DUPLICATES _SCHEMAS)

# Get list of SQL view files from sql/ directory
# These define the database queries that can be executed
file(GLOB _SQL_FILES "sql/*.sql")
set(_SQL_BASES "")
foreach(_sql ${_SQL_FILES})
  get_filename_component(_base ${_sql} NAME_WE)
  list(APPEND _SQL_BASES ${_base})
endforeach()

# Find required libraries
find_library(NETCDF_LIB netcdf PATHS ${LIBNCDF} /usr/lib /usr/local/lib)
find_library(NETCDFF_LIB netcdff PATHS ${LIBNCDFF} /usr/lib /usr/local/lib)

# ODB compiler and include paths
# odb98.x: ODB SQL compiler that generates C code from .sql files
set(ODB_COMPILER "${PACK}/sys/odb98.x" CACHE PATH "Path to odb98.x compiler")
set(INC_CMA "${PACK}/src/${TYPE_PACK}/odb/ddl" CACHE PATH "CMA include directory")
set(INC_ODB "${PACK}/src/${TYPE_PACK}/odb/module" CACHE PATH "ODB module directory")

# NetCDF library paths (optional, can be set via cmake -DLIBNCDF=...)
set(LIBNCDF "" CACHE PATH "NetCDF C library path")
set(LIBNCDFF "" CACHE PATH "NetCDF Fortran library path")

# Include directories for compilation
# ${INC_CMA}.CCMA, ${INC_CMA}.ECMA: Schema-specific includes
# ${INC_ODB}: ODB module includes
# src/: Project source directory
# ${CMAKE_CURRENT_BINARY_DIR}/src/: Generated C files (e.g., _odb_glue.c)
include_directories(${INC_CMA}.CCMA ${INC_CMA}.ECMA ${INC_ODB} ${MODULE})
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)
include_directories(${CMAKE_CURRENT_BINARY_DIR}/src)

# Add build directories for each schema to find generated .h files
# odb98.x generates .h files in the build directory (e.g., build/ddl.CCMA/CCMA.h)
foreach(_schema ${_SCHEMAS})
  include_directories(${CMAKE_CURRENT_BINARY_DIR}/ddl.${_schema})
endforeach()

# Fiat library support (optional - for ECMWF Fiat library integration)
set(FIAT_DIR "" CACHE PATH "Fiat installation directory")
if(FIAT_DIR AND EXISTS "${FIAT_DIR}")
  set(INCFIAT "${FIAT_DIR}/include/fiat" CACHE PATH "")
  set(MODFIAT "${FIAT_DIR}/module/fiat" CACHE PATH "")
  set(LIBFIAT -L${FIAT_DIR}/lib64 -lmpi_serial -lfiat -Wl,-rpath,${FIAT_DIR}/lib64)
  include_directories(${INCFIAT} ${MODFIAT})
endif()

# Find odb98.x SQL compiler
# This tool converts .sql files to C object files
find_program(ODB98_EXECUTABLE odb98.x PATHS ${ODB_COMPILER} )
if(NOT ODB98_EXECUTABLE)
  message(WARNING "odb98.x not found - SQL processing will fail")
endif()

# ==============================================================================
# Generate C source files from templates
# ==============================================================================

# Generate _odb_glue.c from template
# This file provides the entry point for ODB to initialize database schemas
# @STATIC_INIT_CALLS@ is replaced with Static_Init() calls for each schema
set(STATIC_INIT_CALLS "")
foreach(_schema ${_SCHEMAS})
  string(APPEND STATIC_INIT_CALLS "  Static_Init(${_schema});\n")
endforeach()
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/cmake/templates/_odb_glue.c.in
               ${CMAKE_CURRENT_BINARY_DIR}/src/_odb_glue.c
               @ONLY)

# Generate _Sstatic.c for each schema from template
# These files register SQL view functions for each database schema
# @SCHEMA@ is replaced with schema name (CCMA, ECMA, etc.)
# @ODB_ANCHOR_VIEWS@ is replaced with ODB_ANCHOR_VIEW() calls for each SQL view
foreach(_schema ${_SCHEMAS})
  set(SCHEMA ${_schema})
  set(ODB_ANCHOR_VIEWS "")
  foreach(_base ${_SQL_BASES})
    string(APPEND ODB_ANCHOR_VIEWS "ODB_ANCHOR_VIEW(${_schema}, ${_base} );\n")
  endforeach()
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/cmake/templates/_Sstatic.c.in
                 ${CMAKE_CURRENT_BINARY_DIR}/src/${_schema}_Sstatic.c
                 @ONLY)
endforeach()

# ==============================================================================
# Add subdirectories for SQL processing
# ==============================================================================
# Each ddl.* directory has its own CMakeLists.txt that processes .sql files
# using odb98.x to generate .o object files
foreach(_schema ${_SCHEMAS})
  add_subdirectory(ddl.${_schema})
endforeach()

# ==============================================================================
# Set compilation properties
# ==============================================================================

# Set source files properties (using build directory paths)
# -DWITHOUT_OML: Compile without OML (Ocean Model Library) support
set(_STATIC_SRC_FILES "")
foreach(_schema ${_SCHEMAS})
  list(APPEND _STATIC_SRC_FILES "${CMAKE_CURRENT_BINARY_DIR}/src/${_schema}_Sstatic.c")
endforeach()

set_source_files_properties(
  ${_STATIC_SRC_FILES}
  "${CMAKE_CURRENT_BINARY_DIR}/src/_odb_glue.c"
  PROPERTIES COMPILE_FLAGS "-DWITHOUT_OML"
)

# ==============================================================================
# Create object libraries
# ==============================================================================
# Create object libraries for each schema's static initializer
# These are linked into the final executable later
set(_STATIC_OBJS "")
foreach(_schema ${_SCHEMAS})
  string(TOLOWER ${_schema} _schema_lower)
  add_library(${_schema_lower}_static_obj OBJECT "${CMAKE_CURRENT_BINARY_DIR}/src/${_schema}_Sstatic.c")
  list(APPEND _STATIC_OBJS $<TARGET_OBJECTS:${_schema_lower}_static_obj>)
endforeach()

# Object library for the ODB glue code
add_library(odb_glue_obj OBJECT "${CMAKE_CURRENT_BINARY_DIR}/src/_odb_glue.c")

# Fortran compilation flags
set(FORTRAN_FLAGS "-DWITHOUT_OML")
set_source_files_properties(src/odb_filter_mod.F90 PROPERTIES COMPILE_FLAGS "${FORTRAN_FLAGS}")

# ==============================================================================
# Main executable
# ==============================================================================
add_executable(odb_filter src/filter.F90 src/odb_filter_mod.F90
  ${_STATIC_OBJS}
  $<TARGET_OBJECTS:odb_glue_obj>
)

# ==============================================================================
# Link libraries
# ==============================================================================
# Link against schema libraries (generated from SQL files)
# and required system libraries (ODB, NetCDF, Fiat, etc.)
set(_LINK_LIBS "")
foreach(_schema ${_SCHEMAS})
  list(APPEND _LINK_LIBS ${_schema}_lib)
endforeach()

target_link_libraries(odb_filter
  ${_LINK_LIBS}
  # ODB libraries from the pack
  -L${PACK}/lib -lcma-odb.${TYPE_PACK}
  -lodb.${TYPE_PACK}
  -lmain-odb.${TYPE_PACK}
  -lifsaux.${TYPE_PACK}
  # NetCDF libraries
  -L${LIBNCDF} -lnetcdf
  -L${LIBNCDFF} -lnetcdff
  # Standard libraries
  -lstdc++ 
  -liomp5
  # Optional Fiat library
  ${LIBFIAT}
)

# Set linker flags
# -Wl,-rpath: Set runtime library search path
# -Wl,--allow-multiple-definition: Allow multiple symbol definitions
# -Wl,--start-group/--end-group: Handle circular dependencies
set_target_properties(odb_filter PROPERTIES
  LINK_FLAGS "-Wl,-rpath,${PACK}/lib -Wl,--allow-multiple-definition -Wl,--start-group -Wl,--end-group -Wl,-rpath,${LIBNCDFF} -Wl,-rpath,${LIBNCDF}"
)

# ==============================================================================
# Installation
# ==============================================================================
# Install the main executable
install(TARGETS odb_filter DESTINATION bin)

# Install helper scripts
install(PROGRAMS scripts/CCMA2ECMA src/create_ioassign DESTINATION bin)
install(PROGRAMS scripts/odbtbx.sh DESTINATION bin)
