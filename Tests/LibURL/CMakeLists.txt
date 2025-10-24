set(URL_TEST_SOURCES
    TestURL.cpp
    TestURLPatternConstructorStringParser.cpp
    TestPublicSuffix.cpp
)

foreach(source IN LISTS URL_TEST_SOURCES)
    imooglebrowser_test("${source}" LibURL LIBS LibURL)
endforeach()
