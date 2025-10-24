include(cmake/ResourceFiles.cmake)

function(create_imooglebrowser_bundle target_name)
    set_target_properties(${target_name} PROPERTIES
        OUTPUT_NAME "ImoogleBrowser"
        MACOSX_BUNDLE_GUI_IDENTIFIER org.imooglebrowser.ImoogleBrowser
        MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
        MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
        MACOSX_BUNDLE_INFO_PLIST "${IMOOGLE_BROWSER_SOURCE_DIR}/UI/Info.plist"
        MACOSX_BUNDLE TRUE
        WIN32_EXECUTABLE TRUE
        XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER org.imooglebrowser.ImoogleBrowser
    )

    if (APPLE)
        set(bundle_dir "$<TARGET_BUNDLE_DIR:${target_name}>")
        add_custom_command(TARGET ${target_name} POST_BUILD
            COMMAND "${CMAKE_COMMAND}" -E make_directory "${bundle_dir}/Contents/Resources"
            COMMAND "iconutil" --convert icns "${IMOOGLE_BROWSER_SOURCE_DIR}/UI/Icons/macos/app_icon.iconset" --output "${bundle_dir}/Contents/Resources/app_icon.icns"
        )

        # Note: This symlink is removed in the install commands
        # This makes the bundle in the build directory *NOT* relocatable
        add_custom_command(TARGET ${target_name} POST_BUILD
            COMMAND "${CMAKE_COMMAND}" -E create_symlink "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}" "${bundle_dir}/Contents/lib"
        )

        if (NOT CMAKE_BUILD_TYPE MATCHES "Release|RelWithDebInfo" AND "arm64" IN_LIST CMAKE_OSX_ARCHITECTURES)
            add_custom_command(TARGET ${target_name} POST_BUILD
                COMMAND codesign -s - -v -f --entitlements "${IMOOGLE_BROWSER_SOURCE_DIR}/Meta/debug.plist" "${bundle_dir}"
            )
        else()
            add_custom_target(apply-debug-entitlements
                COMMAND codesign -s - -v -f --entitlements "${IMOOGLE_BROWSER_SOURCE_DIR}/Meta/debug.plist" "${bundle_dir}"
                USES_TERMINAL
            )
        endif()
    endif()

    if (APPLE)
        set(resource_base_dir "$<TARGET_BUNDLE_DIR:${target_name}>/Contents/Resources")
    else()
        set(resource_base_dir "${CMAKE_BINARY_DIR}/${IN_BUILD_PREFIX}${CMAKE_INSTALL_DATADIR}/Lagom")
    endif()

    copy_resources_to_build(${resource_base_dir} ${target_name})
endfunction()

# Select UI Framework
if (ENABLE_QT)
   add_subdirectory(Qt)
elseif (APPLE)
   add_subdirectory(AppKit)
elseif(ANDROID)
   add_subdirectory(Android)
else()
    # TODO: Check for other GUI frameworks here when we move them in-tree
    return()
endif()

if (NOT TARGET imooglebrowser)
    message(FATAL_ERROR "UI Framework selection must declare a imooglebrowser target")
endif()

if (TARGET imooglebrowser_impl)
    set(IMOOGLE_BROWSER_TARGET imooglebrowser_impl PUBLIC)
else()
    set(IMOOGLE_BROWSER_TARGET imooglebrowser PRIVATE)
endif()

set(IMOOGLE_BROWSER_LIBS AK LibCore LibFileSystem LibGfx LibImageDecoderClient LibIPC LibJS LibMain LibWeb LibWebView LibWebViewPlatform LibRequests LibURL)
target_link_libraries(${IMOOGLE_BROWSER_TARGET} PRIVATE ${IMOOGLE_BROWSER_LIBS})
target_link_libraries(${IMOOGLE_BROWSER_TARGET} PRIVATE OpenSSL::Crypto OpenSSL::SSL)

target_include_directories(${IMOOGLE_BROWSER_TARGET} ${CMAKE_CURRENT_BINARY_DIR})
target_include_directories(${IMOOGLE_BROWSER_TARGET} ${IMOOGLE_BROWSER_SOURCE_DIR})
target_include_directories(${IMOOGLE_BROWSER_TARGET} ${IMOOGLE_BROWSER_SOURCE_DIR}/Services/)

if(WIN32)
    target_link_libraries(${IMOOGLE_BROWSER_TARGET} LibDevTools)
endif()

function(set_helper_process_properties)
    set(targets ${ARGV})
    if (APPLE)
        # Store helper processes in the same bundle directory as the main application
        set_target_properties(${targets} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "$<TARGET_FILE_DIR:imooglebrowser>")
    else()
        set_target_properties(${targets} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/${IN_BUILD_PREFIX}${CMAKE_INSTALL_LIBEXECDIR}")
    endif()
endfunction()

add_custom_target(run
    COMMAND "${CMAKE_COMMAND}" -E env "IMOOGLE_BROWSER_SOURCE_DIR=${IMOOGLE_BROWSER_SOURCE_DIR}" "$<TARGET_FILE:imooglebrowser>" $ENV{LAGOM_ARGS}
    USES_TERMINAL
    VERBATIM
)

if (APPLE)
    add_custom_target(debug-imooglebrowser
        COMMAND "${CMAKE_COMMAND}" -E env "IMOOGLE_BROWSER_SOURCE_DIR=${IMOOGLE_BROWSER_SOURCE_DIR}" lldb "$<TARGET_BUNDLE_DIR:imooglebrowser>"
        USES_TERMINAL
    )
else()
    add_custom_target(debug-imooglebrowser
        COMMAND "${CMAKE_COMMAND}" -E env "IMOOGLE_BROWSER_SOURCE_DIR=${IMOOGLE_BROWSER_SOURCE_DIR}" gdb "$<TARGET_FILE:imooglebrowser>"
        USES_TERMINAL
    )
endif()

set(imooglebrowser_helper_processes ImageDecoder RequestServer WebContent WebWorker)

add_dependencies(imooglebrowser ${imooglebrowser_helper_processes})
# FIXME: Increase support for building targets on Windows
if (NOT WIN32)
    add_dependencies(WebDriver imooglebrowser)
endif()

set_helper_process_properties(${imooglebrowser_helper_processes})
if (APPLE)
    set_helper_process_properties(WebDriver)
endif()

if(NOT CMAKE_SKIP_INSTALL_RULES)
    include(cmake/InstallRules.cmake)
endif()
