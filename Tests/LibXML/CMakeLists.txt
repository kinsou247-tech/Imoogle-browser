set(TEST_SOURCES
    TestParser.cpp
)

foreach(source IN LISTS TEST_SOURCES)
    imooglebrowser_test("${source}" LibXML LIBS LibXML)
endforeach()
