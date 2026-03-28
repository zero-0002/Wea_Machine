cmake_minimum_required(VERSION 3.16)

# ============================
#  Variables
# ============================
include(.cmake.conf)
# ============================

project(${MODULE_NAME}
        VERSION ${MODULE_VERSION}
        LANGUAGES CXX)

include(GNUInstallDirs)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# ============================
# Qt Setup
# ============================
find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core)

# Optional QML support
option(WITH_QML "Enable QML modules" ON)
if(WITH_QML)
    find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Qml Quick)
endif()

# ============================
# Files
# ============================
file(GLOB_RECURSE MODULE_HEADERS "include/*.h")
file(GLOB_RECURSE MODULE_SOURCES "src/*.cpp" "src/*.h")
file(GLOB_RECURSE MODULE_SCRIPTS "scripts/*.js")
file(GLOB_RECURSE MODULE_RESOURCES "qml/*.qrc" "shaders/*.qrc" "scripts/*.qrc")
file(GLOB_RECURSE MODULE_SHADRES "shaders/*.glsl" "shaders/*.vert" "shaders/*.frag")

add_library(${MODULE_NAME} SHARED
    ${MODULE_HEADERS}
    ${MODULE_SOURCES}
    ${MODULE_SCRIPTS}
    ${MODULE_SHADERS}
    ${MODULE_RESOURCES}
)

target_include_directories(${MODULE_NAME}
    PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

target_link_libraries(${MODULE_NAME} PUBLIC Qt${QT_VERSION_MAJOR}::Core)

if(WITH_QML)
    target_link_libraries(${MODULE_NAME} PUBLIC Qt${QT_VERSION_MAJOR}::Qml Qt${QT_VERSION_MAJOR}::Quick)
endif()

# Export definition
target_compile_definitions(${MODULE_NAME} PRIVATE ${MODULE_NAME}_EXPORT)

# ============================
# Install
# ============================
include(CMakePackageConfigHelpers)

write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/${MODULE_NAME}ConfigVersion.cmake"
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY SameMajorVersion
)

configure_package_config_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/${MODULE_NAME}Config.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/${MODULE_NAME}Config.cmake"
    INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${MODULE_NAME}
)

install(TARGETS ${MODULE_NAME}
    EXPORT ${MODULE_NAME}Targets
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/${MODULE_NAME}Config.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/${MODULE_NAME}ConfigVersion.cmake"
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${MODULE_NAME}
)

install(EXPORT ${MODULE_NAME}Targets
    FILE ${MODULE_NAME}Targets.cmake
    NAMESPACE ${MODULE_NAMESPACE}::
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${MODULE_NAME}
)

# Install QML files (if exist)
if(WITH_QML)
    set(QML_DEST "${CMAKE_INSTALL_PREFIX}/share/qml/com/wearily/${MODULE_NAME}")
    install(DIRECTORY qml/
        DESTINATION ${QML_DEST}
        FILES_MATCHING PATTERN "*.qml" PATTERN "qmldir"
    )
endif()
# Removing Duplicate WeaChart directories.
install(DIRECTORY ${CMAKE_INSTALL_INCLUDEDIR}/${MODULE_NAME} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# ============================
# Examples & Tests
# ============================
option(BUILD_${MODULE_NAME}_EXAMPLES "Build examples" ON)
if(BUILD_${MODULE_NAME}_EXAMPLES)
    add_subdirectory(examples)
endif()

option(BUILD_${MODULE_NAME}_TESTS "Build tests" ON)
if(BUILD_${MODULE_NAME}_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()


# Also Important flags
message(STATUS
   "CMakeAttributes: "
   "\nCMAKE_INSTALL_PREFIX: ${CMAKE_INSTALL_PREFIX}"
   "\nCMAKE_INSTALL_BINDIR: ${CMAKE_INSTALL_BINDIR}"
   "\nCMAKE_INSTALL_LIBDIR: ${CMAKE_INSTALL_LIBDIR}"
   "\nCMAKE_INSTALL_INCLUDEDIR: ${CMAKE_INSTALL_INCLUDEDIR}"
   "\nCMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}"
   "\nCMAKE_MODULE_PATH: ${CMAKE_MODULE_PATH}"
   "\nPROJECT_VERSION: ${PROJECT_VERSION}"
   "\nTemplate Attributes: "
   "\nMODULE_NAME: ${MODULE_NAME}"
   "\nMODULE_NAME: ${MODULE_NAMESPACE}"
   "\nMODULE_VERSION: ${MODULE_VERSION}"
   "\nMODULE_HEADERS: ${MODULE_HEADERS}"
   "\nMODULE_SOURCES: ${MODULE_SOURCES}"
   "\nMODULE_SCRIPTS: ${MODULE_SCRIPTS}"
   "\nMODULE_SHADERS: ${MODULE_SHADERS}"
   "\nMODULE_RESOURCES: ${MODULE_RESOURCES}"
   "\nWITH_QML: ${WITH_QML}"
   "\nQML_DEST: ${QML_DEST}"
)
