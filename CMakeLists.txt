# ODB Filter - Main CMake Configuration
# This project filters ODB (Observing Database) data with NetCDF output support
# Requires: Fortran and C compilers, ODB98 compiler, NetCDF libraries

cmake_minimum_required(VERSION 3.10)
project(odbfilter Fortran C)

# Enable Fortran language support for ODB processing
enable_language(Fortran)

# Default to Release build type if not specified
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

# ODB installation paths - PACK is the root of ODB installation
set(PACK ${CMAKE_SOURCE_DIR} CACHE PATH "Pack directory - root of ODB installation")
set(TYPE_PACK "main" CACHE STRING "Pack type: 'main' or 'local'")

# Find NetCDF libraries (C and Fortran interfaces)
find_library(NETCDF_LIB netcdf PATHS ${LIBNCDF} /usr/lib /usr/local/lib)
find_library(NETCDFF_LIB netcdff PATHS ${LIBNCDFF} /usr/lib /usr/local/lib)

# ODB compiler and module paths
set(ODB_COMPILER "${PACK}/sys/odb98.x" CACHE PATH "Path to odb98.x compiler")
set(INC_ODB "${PACK}/src/${TYPE_PACK}/odb/module" CACHE PATH "ODB module directory")

# Allow users to specify custom NetCDF library paths
set(LIBNCDF "" CACHE PATH "NetCDF C library path")
set(LIBNCDFF "" CACHE PATH "NetCDF Fortran library path")

# Include directories for ODB modules, project source, and build output
include_directories(${INC_ODB} ${MODULE})
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)
include_directories(${CMAKE_CURRENT_BINARY_DIR}/src)

# Optional Fiat library support (for interpolation/transformation operations)
set(FIAT_DIR "" CACHE PATH "Fiat installation directory")
if(FIAT_DIR AND EXISTS "${FIAT_DIR}")
  set(INCFIAT "${FIAT_DIR}/include/fiat" CACHE PATH "")
  set(MODFIAT "${FIAT_DIR}/module/fiat" CACHE PATH "")
  set(LIBFIAT -L${FIAT_DIR}/lib64 -lfiat -lmpi_serial -Wl,-rpath,${FIAT_DIR}/lib64)
  include_directories(${INCFIAT} ${MODFIAT})
endif()

# Find ODB98 compiler executable (required for SQL/DDL processing)
find_program(ODB98_EXECUTABLE odb98.x PATHS ${ODB_COMPILER} )
if(NOT ODB98_EXECUTABLE)
  message(WARNING "odb98.x not found - SQL processing will fail")
endif()

# Discover CMA (Consistent Model Archive) directories (ddl.*)
# Each CMA represents a different data schema (e.g., ddl.cca, ddl.ecca)
file(GLOB _DDL_DIRS "ddl.*")
set(_CMA_S "")
foreach(_ddl ${_DDL_DIRS})
  if(IS_DIRECTORY ${_ddl} OR IS_SYMLINK ${_ddl})
    get_filename_component(_cma ${_ddl} EXT)
    string(REPLACE "." "" _cma ${_cma})
    list(APPEND _CMA_S ${_cma})
  endif()
endforeach()
list(REMOVE_DUPLICATES _CMA_S)

# Generate ODB glue code with static initialization calls for each CMA
set(STATIC_INIT_CALLS "")
foreach(_cma ${_CMA_S})
  string(APPEND STATIC_INIT_CALLS "  Static_Init(${_cma});\n")
endforeach()
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/cmake/templates/_odb_glue.c.in
               ${CMAKE_CURRENT_BINARY_DIR}/src/_odb_glue.c
               @ONLY)

# Process each CMA subdirectory (contains SQL/DDL code)
foreach(_cma ${_CMA_S})
  add_subdirectory(ddl.${_cma})
endforeach()

# Compile ODB glue code with WITHOUT_OML flag (no OML support)
set_source_files_properties(
  "${CMAKE_CURRENT_BINARY_DIR}/src/_odb_glue.c"
  PROPERTIES COMPILE_FLAGS "-DWITHOUT_OML"
)

add_library(odb_glue_obj OBJECT "${CMAKE_CURRENT_BINARY_DIR}/src/_odb_glue.c")

# Compile Fortran filter module with WITHOUT_OML flag
set(FORTRAN_FLAGS "-DWITHOUT_OML")
set_source_files_properties(src/odb_filter_mod.F90 PROPERTIES COMPILE_FLAGS "${FORTRAN_FLAGS}")

# Main executable - ODB filter with SQL-based data filtering
add_executable(odb_filter src/filter.F90 src/odb_filter_mod.F90
  $<TARGET_OBJECTS:odb_glue_obj>
)

# Build list of CMA libraries to link against
set(_LINK_CMA_LIBS "")
foreach(_cma ${_CMA_S})
  list(APPEND _LINK_CMA_LIBS ${_cma}_lib )
  list(APPEND _LINK_CMA_LIBS -L${CMAKE_CURRENT_BINARY_DIR}/ddl.${_cma} -l${_cma}_tables )
endforeach()

# Link all required libraries for odb_filter executable
target_link_libraries(odb_filter
  ${_LINK_CMA_LIBS}
  # ODB libraries from the pack
  -L${PACK}/lib -lodb.${TYPE_PACK}
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
  -lrt
)

# Set rpath and linker flags for runtime library resolution
set_target_properties(odb_filter PROPERTIES
  LINK_FLAGS "-Wl,-rpath,${PACK}/lib -Wl,--allow-multiple-definition -Wl,--start-group -Wl,--end-group -Wl,-rpath,${LIBNCDFF} -Wl,-rpath,${LIBNCDF}"
)

# Install the main odb_filter executable
install(TARGETS odb_filter DESTINATION bin)

# Install utility scripts
install(PROGRAMS scripts/CCMA2ECMA src/create_ioassign DESTINATION bin)
install(PROGRAMS scripts/build_for_pack.sh scripts/odbtbx.sh DESTINATION bin)
