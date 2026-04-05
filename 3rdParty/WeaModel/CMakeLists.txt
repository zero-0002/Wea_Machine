cmake_minimum_required(VERSION 3.14)

project(WeaModel LANGUAGES CXX VERSION 1.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOMOC ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core)

set(HEADERS
    models/IQItemListModel.h
    models/QItemListModel.h
    models/QItemSortFilterProxyModel.h
    models/QItemBase.h
)
set(QML_FILES
        resources/qml.qrc
)
set(PROJECT_SOURCES
    ${HEADERS}
    ${QML_FILES}
)


add_library(appListModel SHARED
  ${PROJECT_SOURCES})


target_include_directories(appListModel PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

target_link_libraries(appListModel PRIVATE Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Quick Qt${QT_VERSION_MAJOR}::Qml )
