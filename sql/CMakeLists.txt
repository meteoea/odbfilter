# SQL Processing CMake Configuration
# This file handles ODB SQL file processing for a specific CMA (Consistent Model Archive)
# Expected to be included from ddl.* subdirectories via add_subdirectory()

# Collect all object files generated from SQL processing
set(SQL_OBJ_FILES "")
file(GLOB CMA_SQL_PATHFILES "*.sql")
set(CMA_SQL_FILES "")

# Include ODB headers for SQL compilation
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../odb/include )

# Extract CMA name from directory extension (e.g., ddl.cca -> cca)
set(_SQL_BASES "")
get_filename_component(dot_cma "${CMAKE_CURRENT_SOURCE_DIR}" EXT)
string(REPLACE "." "" cma "${dot_cma}")
foreach(_F ${CMA_SQL_PATHFILES})
    get_filename_component(_NAME "${_F}" NAME)
    get_filename_component(_base ${_F} NAME_WE)
    list(APPEND CMA_SQL_FILES "${_NAME}")
    list(APPEND _SQL_BASES ${_base})
endforeach()

# Process DDL file to generate C header with table definitions
add_custom_command(
  OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${cma}.h
  COMMAND ${ODB98_EXECUTABLE} -c -o ${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/${cma}.ddl
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${cma}.ddl
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  COMMENT "Processing ${cma}"
)

# Create static library archive from compiled DDL objects
add_custom_command(
  OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/lib${cma}_tables.a
  COMMAND ar rcs lib${cma}_tables.a ${cma}.o ${cma}_T_*.o 
  DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/${cma}.h
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  COMMENT "Processing lib${cma}_tables.a"
)

# Custom target to trigger DDL header and table library generation
add_custom_target(
  ${cma}_h 
  DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/${cma}.h ${CMAKE_CURRENT_BINARY_DIR}/lib${cma}_tables.a
)

# Generate static initialization code with ODB_ANCHOR_VIEW macros for each SQL base
set(SCHEMA ${cma})
set(ODB_ANCHOR_VIEWS "")
foreach(_base ${_SQL_BASES})
  string(APPEND ODB_ANCHOR_VIEWS "ODB_ANCHOR_VIEW(${cma}, ${_base} );\n"
)
endforeach()
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/../cmake/templates/_Sstatic.c.in
               ${CMAKE_CURRENT_BINARY_DIR}/${cma}_Sstatic.c
               @ONLY)

# Compile the generated static initialization code as an object library
string(TOLOWER ${cma} _schema_lower)
add_library(${_schema_lower}_static_obj OBJECT "${CMAKE_CURRENT_BINARY_DIR}/${cma}_Sstatic.c")
list(APPEND SQL_OBJ_FILES $<TARGET_OBJECTS:${_schema_lower}_static_obj>)

add_dependencies(${_schema_lower}_static_obj ${cma}_h)

# Process each SQL file - copy to build dir and compile with odb98.x
foreach(sql ${CMA_SQL_FILES})
  if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${sql}")
    file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/${sql}
         DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
    get_filename_component(sql_we "${sql}" NAME_WE)
    set(CMA_OBJ "${cma}_${sql_we}.o")
    list(APPEND SQL_OBJ_FILES ${CMAKE_CURRENT_BINARY_DIR}/${CMA_OBJ})

    add_custom_command(
      OUTPUT ${CMA_OBJ}
      COMMAND ${ODB98_EXECUTABLE} -c -l ${cma} -w -l ${cma} -w ${sql}
      DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${sql} ${CMAKE_CURRENT_BINARY_DIR}/${cma}.h
      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
      COMMENT "Processing ${sql} for ${cma}"
    )
  endif()
endforeach()

# Create static library containing all SQL-compiled objects for this CMA
add_library(${cma}_lib STATIC ${SQL_OBJ_FILES}) 

add_dependencies(${cma}_lib {cma}_h)
set_target_properties(${cma}_lib PROPERTIES LINKER_LANGUAGE C)

