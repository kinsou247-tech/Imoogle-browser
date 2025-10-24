set(SOURCES
    Message.cpp
)

imooglebrowser_lib(LibDNS dns EXPLICIT_SYMBOL_EXPORT)
target_link_libraries(LibDNS PRIVATE LibCore PUBLIC LibCrypto)
