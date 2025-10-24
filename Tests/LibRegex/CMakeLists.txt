set(TEST_SOURCES
    TestRegex.cpp
)

foreach(source IN LISTS TEST_SOURCES)
    imooglebrowser_test("${source}" LibRegex LIBS LibRegex)
endforeach()
