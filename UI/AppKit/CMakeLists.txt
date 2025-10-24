add_library(imooglebrowser_impl STATIC
    Application/Application.mm
    Application/ApplicationDelegate.mm
    Interface/Autocomplete.mm
    Interface/Event.mm
    Interface/InfoBar.mm
    Interface/ImoogleBrowserWebView.mm
    Interface/ImoogleBrowserWebViewBridge.cpp
    Interface/ImoogleBrowserWebViewWindow.mm
    Interface/Menu.mm
    Interface/Palette.mm
    Interface/SearchPanel.mm
    Interface/Tab.mm
    Interface/TabController.mm
    Utilities/Conversions.mm
)
target_include_directories(imooglebrowser_impl PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>)

target_compile_options(imooglebrowser_impl PUBLIC
        $<$<COMPILE_LANGUAGE:CXX>:-fobjc-arc>
        $<$<COMPILE_LANGUAGE:CXX>:-Wno-deprecated-anon-enum-enum-conversion> # Required for CGImageCreate
)
target_compile_features(imooglebrowser_impl PUBLIC cxx_std_23)

add_executable(imooglebrowser MACOSX_BUNDLE
   main.mm
)
target_link_libraries(imooglebrowser_impl PUBLIC "-framework Cocoa -framework UniformTypeIdentifiers" LibUnicode)
target_link_libraries(imooglebrowser PRIVATE imooglebrowser_impl)

create_imooglebrowser_bundle(imooglebrowser)
