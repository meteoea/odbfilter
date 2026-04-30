cmake_minimum_required(VERSION 3.10)
project(odbfilter Fortran C)

enable_language(Fortran)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

set(PACK ${CMAKE_SOURCE_DIR} CACHE PATH "Pack directory")
set(TYPE_PACK "main" CACHE STRING "Pack type: local or main")

# Auto-detect ddl.* directories first
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

# Get SQL files list
file(GLOB _SQL_FILES "sql/*.sql")
set(_SQL_BASES "")
foreach(_sql ${_SQL_FILES})
  get_filename_component(_base ${_sql} NAME_WE)
  list(APPEND _SQL_BASES ${_base})
endforeach()

find_library(NETCDF_LIB netcdf PATHS ${LIBNCDF} /usr/lib /usr/local/lib)
find_library(NETCDFF_LIB netcdff PATHS ${LIBNCDFF} /usr/lib /usr/local/lib)

set(ODB_COMPILER "${PACK}/sys/odb98.x" CACHE PATH "ECMA include dir")
set(INC_CMA "${PACK}/src/${TYPE_PACK}/odb/ddl" CACHE PATH "CMA include dir")
set(INC_ODB "${PACK}/src/${TYPE_PACK}/odb/module" CACHE PATH "ODB module dir")

set(LIBNCDF "" CACHE PATH "NetCDF library path")
set(LIBNCDFF "" CACHE PATH "NetCDF Fortran library path")

include_directories(${INC_CMA}.CCMA ${INC_CMA}.ECMA ${INC_ODB} ${MODULE})
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)
include_directories(${CMAKE_CURRENT_BINARY_DIR}/src)

# Add build directories for each schema to find generated .h files
foreach(_schema ${_SCHEMAS})
  include_directories(${CMAKE_CURRENT_BINARY_DIR}/ddl.${_schema})
endforeach()

set(FIAT_DIR "" CACHE PATH "Fiat installation directory")
if(FIAT_DIR AND EXISTS "${FIAT_DIR}")
  set(INCFIAT "${FIAT_DIR}/include/fiat" CACHE PATH "")
  set(MODFIAT "${FIAT_DIR}/module/fiat" CACHE PATH "")
  set(LIBFIAT -L${FIAT_DIR}/lib64 -lmpi_serial -lfiat -Wl,-rpath,${FIAT_DIR}/lib64)
  include_directories(${INCFIAT} ${MODFIAT})
endif()

find_program(ODB98_EXECUTABLE odb98.x PATHS ${ODB_COMPILER} )
if(NOT ODB98_EXECUTABLE)
  message(WARNING "odb98.x not found - SQL processing will fail")
endif()

# Generate _odb_glue.c from template
set(STATIC_INIT_CALLS "")
foreach(_schema ${_SCHEMAS})
  string(APPEND STATIC_INIT_CALLS "  Static_Init(${_schema});\n")
endforeach()
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/cmake/templates/_odb_glue.c.in
               ${CMAKE_CURRENT_BINARY_DIR}/src/_odb_glue.c
               @ONLY)

# Generate _Sstatic.c for each schema from template
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

# Add subdirectories for each schema
foreach(_schema ${_SCHEMAS})
  add_subdirectory(ddl.${_schema})
endforeach()

# Set source files properties (using build directory paths)
set(_STATIC_SRC_FILES "")
foreach(_schema ${_SCHEMAS})
  list(APPEND _STATIC_SRC_FILES "${CMAKE_CURRENT_BINARY_DIR}/src/${_schema}_Sstatic.c")
endforeach()

set_source_files_properties(
  ${_STATIC_SRC_FILES}
  "${CMAKE_CURRENT_BINARY_DIR}/src/_odb_glue.c"
  PROPERTIES COMPILE_FLAGS "-DWITHOUT_OML"
)

# Create object libraries and collect objects
set(_STATIC_OBJS "")
foreach(_schema ${_SCHEMAS})
  string(TOLOWER ${_schema} _schema_lower)
  add_library(${_schema_lower}_static_obj OBJECT "${CMAKE_CURRENT_BINARY_DIR}/src/${_schema}_Sstatic.c")
  list(APPEND _STATIC_OBJS $<TARGET_OBJECTS:${_schema_lower}_static_obj>)
endforeach()

add_library(odb_glue_obj OBJECT "${CMAKE_CURRENT_BINARY_DIR}/src/_odb_glue.c")

set(FORTRAN_FLAGS "-DWITHOUT_OML")
set_source_files_properties(src/odb_filter_mod.F90 PROPERTIES COMPILE_FLAGS "${FORTRAN_FLAGS}")

add_executable(odb_filter src/filter.F90 src/odb_filter_mod.F90
  ${_STATIC_OBJS}
  $<TARGET_OBJECTS:odb_glue_obj>
)

# Link libraries
set(_LINK_LIBS "")
foreach(_schema ${_SCHEMAS})
  list(APPEND _LINK_LIBS ${_schema}_lib)
endforeach()

target_link_libraries(odb_filter
  ${_LINK_LIBS}
  -L${PACK}/lib -lcma-odb.${TYPE_PACK}
  -lodb.${TYPE_PACK}
  -lmain-odb.${TYPE_PACK}
  -lifsaux.${TYPE_PACK}
  -L${LIBNCDF} -lnetcdf
  -L${LIBNCDFF} -lnetcdff
  -lstdc++ 
  -liomp5
  ${LIBFIAT}
)

set_target_properties(odb_filter PROPERTIES
  LINK_FLAGS "-Wl,-rpath,${PACK}/lib -Wl,--allow-multiple-definition -Wl,--start-group -Wl,--end-group -Wl,-rpath,${LIBNCDFF} -Wl,-rpath,${LIBNCDF}"
)

install(TARGETS odb_filter DESTINATION bin)
install(PROGRAMS scripts/CCMA2ECMA src/create_ioassign DESTINATION bin)
install(PROGRAMS scripts/odbtbx.sh DESTINATION bin)
