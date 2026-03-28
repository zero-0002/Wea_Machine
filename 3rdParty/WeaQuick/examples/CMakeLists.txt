cmake_minimum_required(VERSION 3.16)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Qml Quick)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Qml Quick)

add_executable(${MODULE_NAME}Example main.cpp
    qml.qrc
    CustomEngine.h
    )

add_compile_definitions(PROJECT_SOURCE_DIR="${CMAKE_CURRENT_SOURCE_DIR}")
add_compile_definitions(EXAMPLES_PAGES_DIR="${CMAKE_CURRENT_SOURCE_DIR}/ExamplesPages/")


target_link_libraries(${MODULE_NAME}Example
    PRIVATE
        Qt${QT_VERSION_MAJOR}::Core
        Qt${QT_VERSION_MAJOR}::Qml
        Qt${QT_VERSION_MAJOR}::Quick
    PUBLIC
        ${MODULE_NAME}
)
