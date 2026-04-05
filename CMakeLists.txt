cmake_minimum_required(VERSION 3.16)

project(InjectionMolding VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Quick Qml QuickControls2 SerialBus SerialPort)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Quick Qml QuickControls2 SerialBus SerialPort)

# ============================
# Files
# ============================
file(GLOB_RECURSE PROJECT_HEADERS "include/*.h")
file(GLOB_RECURSE PROJECT_SOURCES "src/*.cpp" "src/*.h")
file(GLOB_RECURSE PROJECT_SCRIPTS "scripts/*.js")
file(GLOB_RECURSE PROJECT_RESOURCES "qml/*.qrc")

set(PROJECT_SOURCES
    main.cpp
    qml.qrc
    ${PROJECT_HEADERS}
    ${PROJECT_SOURCES}
    ${PROJECT_SCRIPTS}
    ${PROJECT_SHADERS}
    ${PROJECT_RESOURCES}
)

find_package(Qt5 REQUIRED COMPONENTS Core)
find_package(Qt5 REQUIRED COMPONENTS Core)

add_executable(InjectionMolding
    ${PROJECT_SOURCES}
)

# Adding 3rdParty Libraries
add_subdirectory(3rdParty/WeaCore)
add_subdirectory(3rdParty/WeaQuick)
# add_subdirectory(3rdParty/WeaModel)

target_compile_definitions(InjectionMolding PRIVATE PROJECT_SOURCE_DIR="${CMAKE_CURRENT_SOURCE_DIR}")

target_include_directories(InjectionMolding
    PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/WeaCore/include
    ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/WeaQuick/include
    # ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/WeaModel
)

target_link_libraries(InjectionMolding
    PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Quick
    Qt${QT_VERSION_MAJOR}::Qml
    Qt${QT_VERSION_MAJOR}::QuickControls2
    Qt${QT_VERSION_MAJOR}::SerialBus
    Qt${QT_VERSION_MAJOR}::SerialPort
    ${WeaCore}
    ${WeaQuick}
)
target_link_libraries(InjectionMolding PRIVATE Qt5::Core)
target_link_libraries(InjectionMolding PRIVATE Qt5::Core)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
if(${QT_VERSION} VERSION_LESS 6.1.0)
    set(BUNDLE_ID_OPTION MACOSX_BUNDLE_GUI_IDENTIFIER com.example.InjectionMolding)
endif()
set_target_properties(InjectionMolding PROPERTIES
    ${BUNDLE_ID_OPTION}
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

include(GNUInstallDirs)
install(TARGETS InjectionMolding
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})

if(QT_VERSION_MAJOR EQUAL 6)
    qt_import_qml_plugins(InjectionMolding)
    qt_finalize_executable(InjectionMolding)
endif()
