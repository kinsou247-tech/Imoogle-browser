set(TEST_SOURCES
    TestDNSResolver.cpp
)

foreach(source IN LISTS TEST_SOURCES)
    imooglebrowser_test("${source}" LibDNS LIBS LibDNS LibTLS)
endforeach()
