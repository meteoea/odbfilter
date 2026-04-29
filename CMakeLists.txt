cmake_minimum_required(VERSION 3.10)
project(odbfilter Fortran C)

enable_language(Fortran)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

set(CMAKE_Fortran_FLAGS "-DWITHOUT_OML -g")
set(CMAKE_C_FLAGS "-DWITHOUT_OML")

include(FindOpenMP)
if(OPENMP_FOUND)
  set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} ${OpenMP_Fortran_FLAGS}")
endif()

set(PACK ${CMAKE_SOURCE_DIR} CACHE PATH "Pack directory")
set(TYPE_PACK "local" CACHE STRING "Pack type: local or main")

find_library(NETCDF_LIB netcdf PATHS ${LIBNCDF} /usr/lib /usr/local/lib)
find_library(NETCDFF_LIB netcdff PATHS ${LIBNCDFF} /usr/lib /usr/local/lib)

set(INC_CCMA "${PACK}/src/${TYPE_PACK}/odb/ddl.CCMA" CACHE PATH "CCMA include dir")
set(INC_ECMA "${PACK}/src/${TYPE_PACK}/odb/ddl.ECMA" CACHE PATH "ECMA include dir")
set(INC1 "${PACK}/src/${TYPE_PACK}/odb/module" CACHE PATH "ODB module dir")
set(INC2 "${PACK}/src/${TYPE_PACK}/ifsaux/module" CACHE PATH "IFS aux module dir")

set(LIBNCDF "" CACHE PATH "NetCDF library path")
set(LIBNCDFF "" CACHE PATH "NetCDF Fortran library path")

set(FIAT_DIR "" CACHE PATH "Fiat installation directory")
if(FIAT_DIR AND EXISTS "${FIAT_DIR}")
  set(INCFIAT "-I${FIAT_DIR}/include/fiat -I${FIAT_DIR}/module/fiat")
  set(MODFIAT "-I${FIAT_DIR}/module/fiat")
  set(LIBFIAT "-L${FIAT_DIR}/lib64 -lfiat -Wl,-rpath,${FIAT_DIR}/lib64")
endif()

include_directories(${INC_CCMA} ${INC_ECMA} ${INC1} ${INC2} ${INCFIAT})
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)

find_program(ODB98_EXECUTABLE odb98.x PATHS ${PACK}/bin /usr/local/bin /usr/bin)
if(NOT ODB98_EXECUTABLE)
  message(WARNING "odb98.x not found - SQL processing will fail")
endif()

set(SQL_OBJ_FILES "")
set(CMA_SQL_FILES
  select_all.sql
  select_timeslot.sql
  select_obstype.sql
  select_obstype_varno.sql
  select_obstype_varno_tslot.sql
  select_obstype_wind.sql
  select_obstype_sensor.sql
  select_wind_obstype_varno_tslot.sql
  select_scat_tslot.sql
  select_onestatid.sql
  select_oneobstypearea.sql
  select_oneobs_gpssol.sql
  select_oneobs_radar.sql
  select_oneobscanal.sql
  select_amsua.sql
  select_fg_actual_depar.sql
  select_for_debug.sql
  select_sophie.sql
  copy_an_depar.sql
  copy_fg_depar.sql
  update_hdr_status.sql
  hdr_set_passive.sql
  delete_passive.sql
)

foreach(sql ${CMA_SQL_FILES})
  if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/src/${sql}")
    set(CCMA_OBJ "CCMA_${sql}.o")
    set(ECMA_OBJ "ECMA_${sql}.o")
    list(APPEND SQL_OBJ_FILES ${CCMA_OBJ} ${ECMA_OBJ})

    add_custom_command(
      OUTPUT ${CCMA_OBJ}
      COMMAND ${ODB98_EXECUTABLE} -c -I${INC_CCMA} -l CCMA -w -l CCMA -w ${sql}
      DEPENDS src/${sql}
      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
      COMMENT "Processing ${sql} for CCMA"
    )

    add_custom_command(
      OUTPUT ${ECMA_OBJ}
      COMMAND ${ODB98_EXECUTABLE} -c -I${INC_ECMA} -l ECMA -w -l ECMA -w ${sql}
      DEPENDS src/${sql}
      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
      COMMENT "Processing ${sql} for ECMA"
    )
  endif()
endforeach()

set_source_files_properties(
  src/CCMA_Sstatic.c
  src/ECMA_Sstatic.c
  src/_odb_glue.c
  PROPERTIES COMPILE_FLAGS "-DWITHOUT_OML"
)

add_library(cma_static_obj OBJECT src/CCMA_Sstatic.c)
add_library(ecma_static_obj OBJECT src/ECMA_Sstatic.c)
add_library(odb_glue_obj OBJECT src/_odb_glue.c)

set(FORTRAN_FLAGS "-DWITHOUT_OML ${INCFIAT} -I${INC1} -I${INC2}")
set_source_files_properties(src/odb_filter_mod.F90 PROPERTIES COMPILE_FLAGS "${FORTRAN_FLAGS}")

add_executable(odb_filter src/filter.F90 src/odb_filter_mod.F90
  $<TARGET_OBJECTS:cma_static_obj>
  $<TARGET_OBJECTS:ecma_static_obj>
  $<TARGET_OBJECTS:odb_glue_obj>
)

target_link_libraries(odb_filter
  -lcma-odb.${TYPE_PACK}
  -lodb.${TYPE_PACK}
  -lmain-odb.${TYPE_PACK}
  -lifsaux.${TYPE_PACK}
  -L${LIBNCDF} -lnetcdf
  -L${LIBNCDFF} -lnetcdff
  -lstdc++
  ${LIBFIAT}
  ${SQL_OBJ_FILES}
)

set_target_properties(odb_filter PROPERTIES
  LINK_FLAGS "-Wl,--allow-multiple-definition -Wl,--start-group -Wl,--end-group -Wl,-rpath,${LIBNCDFF} -Wl,-rpath,${LIBNCDF}"
)

install(TARGETS odb_filter DESTINATION bin)
install(PROGRAMS scripts/CCMA2ECMA src/create_ioassign DESTINATION bin)
install(PROGRAMS scripts/odbtbx.sh DESTINATION bin)
