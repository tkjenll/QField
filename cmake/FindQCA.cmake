# Find QCA (Qt Cryptography Architecture 2+)
# ~~~~~~~~~~~~~~~~
# When run this will define
#
#  QCA_FOUND - system has QCA
#  QCA_LIBRARY - the QCA library or framework
#  QCA_INCLUDE_DIR - the QCA include directory
#  QCA_VERSION_STR - e.g. "2.0.3"
#
# Copyright (c) 2006, Michael Larouche, <michael.larouche@kdemail.net>
# Copyright (c) 2014, Larry Shaffer, <larrys (at) dakotacarto (dot) com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

if(ANDROID)
  set(QCA_INCLUDE_DIR ${OSGEO4A_STAGE_DIR}/${ANDROID_ABI}/include/Qca-qt5/QtCrypto CACHE PATH "")
  set(QCA_LIBRARY ${OSGEO4A_STAGE_DIR}/${ANDROID_ABI}/lib/libqca-qt5_${ANDROID_ABI}.so CACHE PATH "")
  set(QCA_FOUND TRUE)

else()
  if(QCA_INCLUDE_DIR AND QCA_LIBRARY)
    set(QCA_FOUND TRUE)
  else(QCA_INCLUDE_DIR AND QCA_LIBRARY)
    set(QCA_LIBRARY_NAMES qca-qt5 qca2-qt5 qca-qt6 qca qca-qt5_${ANDROID_ABI})

    find_library(QCA_LIBRARY
      NAMES ${QCA_LIBRARY_NAMES}
      PATHS
        ${LIB_DIR}
        $ENV{LIB}
        "$ENV{LIB_DIR}"
        $ENV{LIB_DIR}/lib
        /usr/local/lib
        ${OSGEO4A_STAGE_DIR}/${ANDROID_ABI}/lib
    )

    set(_qca_fw)
    if(QCA_LIBRARY MATCHES "/qca.*\\.framework")
      string(REGEX REPLACE "^(.*/qca.*\\.framework).*$" "\\1" _qca_fw "${QCA_LIBRARY}")
    endif()

    find_path(QCA_INCLUDE_DIR
      NAMES QtCrypto
      PATHS
        "${_qca_fw}/Headers"
        ${LIB_DIR}/include
        "$ENV{LIB_DIR}/include"
        $ENV{INCLUDE}
        /usr/local/include
        ${OSGEO4A_STAGE_DIR}/${ANDROID_ABI}/include
        PATH_SUFFIXES QtCrypto qt5/QtCrypto Qca-qt5/QtCrypto qt/Qca-qt5/QtCrypto qt5/Qca-qt5/QtCrypto Qca-qt6/QtCrypto
    )

    if(QCA_LIBRARY AND QCA_INCLUDE_DIR)
      set(QCA_FOUND TRUE)
    endif()
  endif(QCA_INCLUDE_DIR AND QCA_LIBRARY)

endif()

if(NOT QCA_FOUND)

  if(QCA_FIND_REQUIRED)
    message(FATAL_ERROR "Could not find QCA")
  else()
    message(STATUS "Could not find QCA")
  endif()

else(NOT QCA_FOUND)

  # Check version is valid (>= 2.0.3)
  # find_package(QCA 2.0.3) works with 2.1.0+, which has a QcaConfigVersion.cmake, but 2.0.3 does not

  # qca_version.h header only available with 2.1.0+
  set(_qca_version_h "${QCA_INCLUDE_DIR}/qca_version.h")
  if(EXISTS "${_qca_version_h}")
    file(STRINGS "${_qca_version_h}" _qca_version_str REGEX "^.*QCA_VERSION_STR +\"[^\"]+\".*$")
    string(REGEX REPLACE "^.*QCA_VERSION_STR +\"([^\"]+)\".*$" "\\1" QCA_VERSION_STR "${_qca_version_str}")
  else()
    # qca_core.h contains hexadecimal version in <= 2.0.3
    set(_qca_core_h "${QCA_INCLUDE_DIR}/qca_core.h")
    if(EXISTS "${_qca_core_h}")
      file(STRINGS "${_qca_core_h}" _qca_version_str REGEX "^#define +QCA_VERSION +0x[0-9a-fA-F]+.*")
      string(REGEX REPLACE "^#define +QCA_VERSION +0x([0-9a-fA-F]+)$" "\\1" _qca_version_int "${_qca_version_str}")
      if("${_qca_version_int}" STREQUAL "020003")
        set(QCA_VERSION_STR "2.0.3")
      endif()
    endif()
  endif()

  if(NOT QCA_VERSION_STR)
    set(QCA_FOUND FALSE)
    if(QCA_FIND_REQUIRED)
      message(FATAL_ERROR "Could not find QCA >= 2.0.3")
    else()
      message(STATUS "Could not find QCA >= 2.0.3")
    endif()
  else()
    if(NOT QCA_FIND_QUIETLY)
      message(STATUS "Found QCA: ${QCA_LIBRARY} (${QCA_VERSION_STR})")
    endif()
  endif()

endif(NOT QCA_FOUND)
