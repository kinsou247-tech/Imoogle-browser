add_library(imooglebrowser SHARED
    src/main/cpp/ImoogleBrowserActivity.cpp
    src/main/cpp/WebViewImplementationNative.cpp
    src/main/cpp/WebViewImplementationNativeJNI.cpp
    src/main/cpp/ALooperEventLoopImplementation.cpp
    src/main/cpp/TimerExecutorService.cpp
    src/main/cpp/JNIHelpers.cpp
)
target_link_libraries(imooglebrowser PRIVATE jnigraphics android)

include(../cmake/AndroidExtras.cmake)
create_imooglebrowser_bundle(imooglebrowser)
