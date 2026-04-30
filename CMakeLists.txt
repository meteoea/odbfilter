cmake_minimum_required(VERSION 3.10)
project(odbfilter Fortran C)

enable_language(Fortran)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

set(PACK ${CMAKE_SOURCE_DIR} CACHE PATH "Pack directory")
set(TYPE_PACK "main" CACHE STRING "Pack type: local or main")

find_library(NETCDF_LIB netcdf PATHS ${LIBNCDF} /usr/lib /usr/local/lib)
find_library(NETCDFF_LIB netcdff PATHS ${LIBNCDFF} /usr/lib /usr/local/lib)

set(ODB_COMPILER "${PACK}/sys/odb98.x" CACHE PATH "ECMA include dir")
set(INC_CMA "${PACK}/src/${TYPE_PACK}/odb/ddl" CACHE PATH "CMA include dir")
set(INC_ODB "${PACK}/src/${TYPE_PACK}/odb/module" CACHE PATH "ODB module dir")

set(LIBNCDF "" CACHE PATH "NetCDF library path")
set(LIBNCDFF "" CACHE PATH "NetCDF Fortran library path")

include_directories(${INC_CMA}.CCMA ${INC_CMA}.ECMA ${INC_ODB} ${MODULE})
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)

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

add_subdirectory(ddl.CCMA)
add_subdirectory(ddl.ECMA)

set_source_files_properties(
  src/CCMA_Sstatic.c
  src/ECMA_Sstatic.c
  src/_odb_glue.c
  PROPERTIES COMPILE_FLAGS "-DWITHOUT_OML"
)

add_library(cma_static_obj OBJECT src/CCMA_Sstatic.c)
add_library(ecma_static_obj OBJECT src/ECMA_Sstatic.c)
add_library(odb_glue_obj OBJECT src/_odb_glue.c)

set(FORTRAN_FLAGS "-DWITHOUT_OML")
set_source_files_properties(src/odb_filter_mod.F90 PROPERTIES COMPILE_FLAGS "${FORTRAN_FLAGS}")

add_executable(odb_filter src/filter.F90 src/odb_filter_mod.F90
  $<TARGET_OBJECTS:cma_static_obj>
  $<TARGET_OBJECTS:ecma_static_obj>
  $<TARGET_OBJECTS:odb_glue_obj>
)

target_link_libraries(odb_filter
  CCMA_lib
  ECMA_lib
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
