set(SOURCES
    Application.cpp
    Fixture.cpp
    Fuzzy.cpp
    TestWebView.cpp
    main.cpp
)

add_executable(test-web ${SOURCES})
add_dependencies(test-web imooglebrowser_build_resource_files ImageDecoder RequestServer WebContent WebWorker)
target_link_libraries(test-web PRIVATE AK LibCore LibDiff LibFileSystem LibGfx LibImageDecoderClient LibIPC LibJS LibMain LibRequests LibURL LibWeb LibWebView)
lagom_copy_runtime_dlls(test-web)

if (APPLE)
    target_compile_definitions(test-web PRIVATE IMOOGLE_BROWSER_BINARY_PATH="$<TARGET_FILE_DIR:imooglebrowser>")
elseif (WIN32)
    target_link_libraries(test-web PRIVATE LibDevTools)
    find_package(pthread REQUIRED)
    target_include_directories(test-web PRIVATE $<BUILD_INTERFACE:${PTHREAD_INCLUDE_DIR}>)
endif()

# FIXME: Increase support for building targets on Windows
if (WIN32 AND ENABLE_WINDOWS_CI)
    return()
endif()

if (BUILD_TESTING)
    find_package(Python3 REQUIRED)

    add_test(
        NAME LibWeb
        COMMAND $<TARGET_FILE:test-web> --python-executable ${Python3_EXECUTABLE} --dump-failed-ref-tests --per-test-timeout 120 --verbose
    )

    set_tests_properties(LibWeb PROPERTIES
        ENVIRONMENT IMOOGLE_BROWSER_SOURCE_DIR=${IMOOGLE_BROWSER_PROJECT_ROOT}
        TIMEOUT_SIGNAL_NAME SIGTERM)
endif()
