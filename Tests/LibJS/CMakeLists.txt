imooglebrowser_test(test-invalid-unicode-js.cpp LibJS LIBS LibJS LibUnicode)
imooglebrowser_test(test-value-js.cpp LibJS LIBS LibJS LibUnicode)

imooglebrowser_testjs_test(test-js.cpp test-js LIBS LibGC)
set_tests_properties(test-js PROPERTIES ENVIRONMENT IMOOGLE_BROWSER_SOURCE_DIR=${IMOOGLE_BROWSER_PROJECT_ROOT})
