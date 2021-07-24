include(SelectLibraryConfigurations)

find_path(QGIS_INCLUDE_DIR
    NAMES qgis.h
    PATHS "${CMAKE_CURRENT_LIST_DIR}/../../include"
    NO_DEFAULT_PATH
)
find_library(QGIS_LIBRARY_DEBUG
    NAMES qgis_core_d qgis
    NAMES_PER_DIR
    PATHS "${CMAKE_CURRENT_LIST_DIR}/../../debug/lib"
    NO_DEFAULT_PATH
)
find_library(QGIS_LIBRARY_RELEASE
    NAMES qgis_core
    NAMES_PER_DIR
    PATHS "${CMAKE_CURRENT_LIST_DIR}/../../lib"
    NO_DEFAULT_PATH
)
select_library_configurations(QGIS)

if(NOT QGIS_INCLUDE_DIR OR NOT QGIS_LIBRARY)
    message(FATAL_ERROR "Installation of vcpkg port qgis is broken.")
endif()

_find_package(${ARGS})

set(_qgis_dep_find_args "")
if(";${ARGS};" MATCHES ";REQUIRED;")
    list(APPEND _qgis_dep_find_args "REQUIRED")
endif()
function(_qgis_add_dependency target package)
    find_package(${package} ${ARGN} ${_qgis_dep_find_args})
    if(${package}_FOUND)
        foreach(suffix IN ITEMS "" "-shared" "_shared" "-static" "_static" "-NOTFOUND")
            set(dependency "${target}${suffix}")
            if(TARGET ${dependency})
                break()
            endif()
        endforeach()
        if(NOT TARGET ${dependency})
            string(TOUPPER ${package} _qgis_deps_package)
            if(DEFINED ${_qgis_deps_package}_LIBRARIES)
                set(dependency ${${_qgis_deps_package}_LIBRARIES})
            elseif(DEFINED ${package}_LIBRARIES)
                set(dependency ${${package}_LIBRARIES})
            elseif(DEFINED ${_qgis_deps_package}_LIBRARY)
                set(dependency ${${_qgis_deps_package}_LIBRARY})
            elseif(DEFINED ${package}_LIBRARY)
                set(dependency ${${package}_LIBRARY})
            endif()
        endif()
        if(dependency)
            if(TARGET QGIS::QGIS) # CMake 3.14
                target_link_libraries(QGIS::QGIS INTERFACE ${dependency})
            endif()
            if(NOT QGIS_LIBRARIES STREQUAL "QGIS::QGIS")
                set(QGIS_LIBRARIES "${QGIS_LIBRARIES};${dependency}" PARENT_SCOPE)
            endif()
        else()
            message(WARNING "Did not find which libraries are exported by ${package}")
            set(QGIS_FOUND false PARENT_SCOPE)
        endif()
    else()
        set(QGIS_FOUND false PARENT_SCOPE)
    endif()
endfunction()
if(QGIS_FOUND)
    _qgis_add_dependency(GDAL gdal CONFIG)
    list(FIND ARGS "REQUIRED" required)
    if(NOT QGIS_FOUND AND NOT required EQUAL "-1")
      message(FATAL_ERROR "Failed to find dependencies of QGIS")
    endif()
endif()
