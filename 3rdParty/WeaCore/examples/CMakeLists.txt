cmake_minimum_required(VERSION 3.16)

add_executable(${MODULE_NAME}Example
    main.cpp
    MainClass.h)

target_link_libraries(${MODULE_NAME}Example
    PUBLIC
        ${MODULE_NAME}
        Qt${QT_VERSION_MAJOR}::Core
)
