add_executable(${MODULE_NAME}Tests main.cpp)

target_link_libraries(${MODULE_NAME}Tests
    PRIVATE
        ${MODULE_NAME}
        Qt${QT_VERSION_MAJOR}::Core
)

add_test(NAME ${MODULE_NAME}_unit_tests COMMAND ${MODULE_NAME}Tests)
