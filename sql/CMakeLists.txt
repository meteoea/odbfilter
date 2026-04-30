set(SQL_OBJ_FILES "")
file(GLOB CMA_SQL_PATHFILES "*.sql")
set(CMA_SQL_FILES "")


get_filename_component(dot_cma "${CMAKE_CURRENT_SOURCE_DIR}" EXT)
string(REPLACE "." "" cma "${dot_cma}")
foreach(_F ${CMA_SQL_PATHFILES})
    get_filename_component(_NAME "${_F}" NAME)
    list(APPEND CMA_SQL_FILES "${_NAME}")
endforeach()

foreach(sql ${CMA_SQL_FILES})
  if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${sql}")
    file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/${sql}
         DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
    get_filename_component(sql_we "${sql}" NAME_WE)
    set(CMA_OBJ "${cma}_${sql_we}.o")
    list(APPEND SQL_OBJ_FILES ${CMAKE_CURRENT_BINARY_DIR}/${CMA_OBJ})

    add_custom_command(
      OUTPUT ${CMA_OBJ}
      COMMAND ${ODB98_EXECUTABLE} -c -I${INC_CMA}.${cma} -l ${cma} -w -l ${cma} -w ${sql}
      DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${sql}
      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
      COMMENT "Processing ${sql} for ${cma}"
    )
  endif()
endforeach()

add_library(${cma}_lib STATIC ${SQL_OBJ_FILES})
set_target_properties(${cma}_lib PROPERTIES LINKER_LANGUAGE C)

