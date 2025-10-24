qt_add_executable(imooglebrowser main.cpp)
target_sources(imooglebrowser PRIVATE
    Application.cpp
    Autocomplete.cpp
    BrowserWindow.cpp
    FindInPageWidget.cpp
    Icon.cpp
    LocationEdit.cpp
    Menu.cpp
    Settings.cpp
    StringUtils.cpp
    Tab.cpp
    TabBar.cpp
    TVGIconEngine.cpp
    WebContentView.cpp
    imooglebrowser.qrc
)
target_link_libraries(imooglebrowser PRIVATE Qt::Core Qt::Gui Qt::Widgets)
lagom_copy_runtime_dlls(imooglebrowser)
create_imooglebrowser_bundle(imooglebrowser)

if (WIN32)
    qt_generate_deploy_script(
        TARGET imooglebrowser
        OUTPUT_SCRIPT imooglebrowser_deploy_script
        CONTENT "
qt_deploy_runtime_dependencies(
    EXECUTABLE $<TARGET_FILE:imooglebrowser>
    PLUGINS_DIR $<TARGET_FILE_DIR:imooglebrowser>
)
")

    add_custom_command(TARGET imooglebrowser POST_BUILD
        COMMAND ${CMAKE_COMMAND}
            -P ${imooglebrowser_deploy_script}
        COMMAND_EXPAND_LISTS
    )
endif()
