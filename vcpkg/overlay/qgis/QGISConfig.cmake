function(set_library_target NAMESPACE LIB_NAME DEBUG_LIB_FILE_NAME RELEASE_LIB_FILE_NAME INCLUDE_DIR)
    add_library(${NAMESPACE}::${LIB_NAME} STATIC IMPORTED)
    set_target_properties(${NAMESPACE}::${LIB_NAME} PROPERTIES
                          IMPORTED_CONFIGURATIONS "RELEASE;DEBUG"
                          IMPORTED_LOCATION_RELEASE "${RELEASE_LIB_FILE_NAME}"
                          IMPORTED_LOCATION_DEBUG "${DEBUG_LIB_FILE_NAME}"
                          INTERFACE_INCLUDE_DIRECTORIES "${INCLUDE_DIR}"
                          )
    set(${NAMESPACE}_${LIB_NAME}_FOUND 1)
    set(${NAMESPACE}_${LIB_NAME}_LIBRARY ${NAMESPACE}::${LIB_NAME})
    set(${NAMESPACE}_${LIB_NAME}_INCLUDE_DIR ${INCLUDE_DIR})
endfunction()

get_filename_component(ROOT "${CMAKE_CURRENT_LIST_FILE}" PATH)
get_filename_component(ROOT "${ROOT}" PATH)
get_filename_component(ROOT "${ROOT}" PATH)

if (CMAKE_HOST_WIN32)
  set_library_target("QGIS" "CORE" "${ROOT}/debug/lib/qgis_core.lib" "${ROOT}/lib/qgis_core.lib" "${ROOT}/include/qgis/")
  set_library_target("QGIS" "ANALYSIS" "${ROOT}/debug/lib/qgis_analysis.lib" "${ROOT}/lib/qgis_analysis.lib" "${ROOT}/include/qgis/")
else ()
  set_library_target("QGIS" "CORE" "${ROOT}/debug/lib/libqgis_core.a" "${ROOT}/lib/libqgis_core.a" "${ROOT}/include/qgis/")
  set_library_target("QGIS" "ANALYSIS" "${ROOT}/debug/lib/libqgis_analysis.a" "${ROOT}/lib/libqgis_analysis.a" "${ROOT}/include/qgis/")
endif ()
set(QGIS_INCLUDE_DIR ${INCLUDE_DIR})
find_package(GDAL REQUIRED)
target_link_libraries(QGIS::CORE INTERFACE GDAL::GDAL)
target_link_libraries(QGIS::ANALYSIS INTERFACE QGIS::CORE)
