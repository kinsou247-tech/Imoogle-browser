
include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

set(package ImoogleBrowser)

set(imooglebrowser_applications imooglebrowser ${imooglebrowser_helper_processes})

set(app_install_targets ${imooglebrowser_applications})

install(TARGETS imooglebrowser
  EXPORT imooglebrowserTargets
  RUNTIME
    COMPONENT imooglebrowser_Runtime
    DESTINATION ${CMAKE_INSTALL_BINDIR}
  BUNDLE
    COMPONENT imooglebrowser_Runtime
    DESTINATION bundle
  LIBRARY
    COMPONENT imooglebrowser_Runtime
    NAMELINK_COMPONENT imooglebrowser_Development
    DESTINATION ${CMAKE_INSTALL_LIBDIR}
  FILE_SET browser
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  FILE_SET imooglebrowser
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

install(TARGETS ${imooglebrowser_helper_processes}
  EXPORT imooglebrowserTargets
  RUNTIME
    COMPONENT imooglebrowser_Runtime
    DESTINATION ${CMAKE_INSTALL_LIBEXECDIR}
)

include("${IMOOGLE_BROWSER_SOURCE_DIR}/Meta/Lagom/get_linked_lagom_libraries.cmake")
foreach (application IN LISTS imooglebrowser_applications)
  get_linked_lagom_libraries("${application}" "${application}_lagom_libraries")
  list(APPEND all_required_lagom_libraries "${${application}_lagom_libraries}")
endforeach()
list(REMOVE_DUPLICATES all_required_lagom_libraries)

# Remove imooglebrowser shlib if it exists
list(REMOVE_ITEM all_required_lagom_libraries imooglebrowser)

if (APPLE)
    # Fixup the app bundle and copy:
    #   - Libraries from lib/ to ImoogleBrowser.app/Contents/lib
    # Remove the symlink we created at build time for the lib directory first
    install(CODE "
    file(REMOVE \${CMAKE_INSTALL_PREFIX}/bundle/ImoogleBrowser.app/Contents/lib)
    set(lib_dir \${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR})
    if (IS_ABSOLUTE ${CMAKE_INSTALL_LIBDIR})
      set(lib_dir ${CMAKE_INSTALL_LIBDIR})
    endif()

    set(contents_dir \${CMAKE_INSTALL_PREFIX}/bundle/ImoogleBrowser.app/Contents)
    file(COPY \${lib_dir} DESTINATION \${contents_dir})
  "
            COMPONENT imooglebrowser_Runtime)
endif()

install(TARGETS ${all_required_lagom_libraries}
  EXPORT imooglebrowserTargets
  COMPONENT imooglebrowser_Runtime
  LIBRARY
    COMPONENT imooglebrowser_Runtime
    NAMELINK_COMPONENT imooglebrowser_Development
    DESTINATION ${CMAKE_INSTALL_LIBDIR}
  FILE_SET server
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  FILE_SET imooglebrowser
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

write_basic_package_version_file(
    "${package}ConfigVersion.cmake"
    COMPATIBILITY SameMajorVersion
)

# Allow package maintainers to freely override the path for the configs
set(
    imooglebrowser_INSTALL_CMAKEDIR "${CMAKE_INSTALL_DATADIR}/${package}"
    CACHE PATH "CMake package config location relative to the install prefix"
)
mark_as_advanced(imooglebrowser_INSTALL_CMAKEDIR)

install(
    FILES cmake/ImoogleBrowserInstallConfig.cmake
    DESTINATION "${imooglebrowser_INSTALL_CMAKEDIR}"
    RENAME "${package}Config.cmake"
    COMPONENT imooglebrowser_Development
)

install(
    FILES "${CMAKE_CURRENT_BINARY_DIR}/${package}ConfigVersion.cmake"
    DESTINATION "${imooglebrowser_INSTALL_CMAKEDIR}"
    COMPONENT imooglebrowser_Development
)

install(
    EXPORT imooglebrowserTargets
    NAMESPACE imooglebrowser::
    DESTINATION "${imooglebrowser_INSTALL_CMAKEDIR}"
    COMPONENT imooglebrowser_Development
)

if (NOT APPLE)
    # On macOS the resources are handled via the MACOSX_PACKAGE_LOCATION property on each resource file
    install_imooglebrowser_resources("${CMAKE_INSTALL_DATADIR}/Lagom" imooglebrowser_Runtime)
endif()

if (ENABLE_INSTALL_FREEDESKTOP_FILES)
    set(FREEDESKTOP_RESOURCE_DIR "${IMOOGLE_BROWSER_SOURCE_DIR}/Meta/CMake/freedesktop")
    string(TIMESTAMP DATE "%Y-%m-%d" UTC)
    execute_process(
        COMMAND git rev-parse --short=10 HEAD
        WORKING_DIRECTORY ${IMOOGLE_BROWSER_SOURCE_DIR}
        OUTPUT_VARIABLE GIT_HASH
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    configure_file("${FREEDESKTOP_RESOURCE_DIR}/org.imooglebrowser.ImoogleBrowser.metainfo.xml.in" "${CMAKE_CURRENT_BINARY_DIR}/org.imooglebrowser.ImoogleBrowser.metainfo.xml" @ONLY)
    install(FILES
        "${FREEDESKTOP_RESOURCE_DIR}/org.imooglebrowser.ImoogleBrowser.svg"
        DESTINATION "${CMAKE_INSTALL_DATADIR}/icons/hicolor/scalable/apps"
        COMPONENT imooglebrowser_Runtime
    )
    install(FILES
        "${FREEDESKTOP_RESOURCE_DIR}/org.imooglebrowser.ImoogleBrowser.desktop"
        DESTINATION "${CMAKE_INSTALL_DATADIR}/applications"
        COMPONENT imooglebrowser_Runtime
    )
    install(FILES
        "${FREEDESKTOP_RESOURCE_DIR}/org.imooglebrowser.ImoogleBrowser.service"
        DESTINATION "${CMAKE_INSTALL_DATADIR}/dbus-1/services"
        COMPONENT imooglebrowser_Runtime
    )
    install(FILES
        "${CMAKE_CURRENT_BINARY_DIR}/org.imooglebrowser.ImoogleBrowser.metainfo.xml"
        DESTINATION "${CMAKE_INSTALL_DATADIR}/metainfo"
        COMPONENT imooglebrowser_Runtime
    )
endif()
