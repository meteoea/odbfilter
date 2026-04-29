set(SQL_OBJ_FILES "")
file(GLOB CMA_SQL_PATHFILES "*.sql")
set(CMA_SQL_FILES "")


foreach(_F ${CMA_SQL_PATHFILES})
    get_filename_component(_NAME "${_F}" NAME)
    list(APPEND CMA_SQL_FILES "${_NAME}")
endforeach()

foreach(sql ${CMA_SQL_FILES})
  if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${sql}")
    file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/${sql}
         DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
    get_filename_component(sql_we "${sql}" NAME_WE)
    set(CCMA_OBJ "CCMA_${sql_we}.o")
    set(ECMA_OBJ "ECMA_${sql_we}.o")
    list(APPEND SQL_OBJ_FILES ${CMAKE_CURRENT_BINARY_DIR}/${CCMA_OBJ})
    list(APPEND SQL_OBJ_FILES ${CMAKE_CURRENT_BINARY_DIR}/${ECMA_OBJ})

    add_custom_command(
      OUTPUT ${CCMA_OBJ}
      COMMAND ${ODB98_EXECUTABLE} -c -I${INC_CCMA} -l CCMA -w -l CCMA -w ${sql}
      DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${sql}
      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
      COMMENT "Processing ${sql} for CCMA"
    )

    add_custom_command(
      OUTPUT ${ECMA_OBJ}
      COMMAND ${ODB98_EXECUTABLE} -c -I${INC_ECMA} -l ECMA -w -l ECMA -w ${sql}
      DEPENDS ${sql}
      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
      COMMENT "Processing ${sql} for ECMA"
    )
  endif()
endforeach()

add_library(sqls_lib STATIC ${SQL_OBJ_FILES})
set_target_properties(sqls_lib PROPERTIES LINKER_LANGUAGE C)

