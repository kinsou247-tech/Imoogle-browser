set(SOURCES
    HttpRequest.cpp
    HttpResponse.cpp
)

imooglebrowser_lib(LibHTTP http)
target_link_libraries(LibHTTP PRIVATE LibCompress LibCore LibTLS LibURL)
