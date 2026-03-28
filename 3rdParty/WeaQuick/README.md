# @MODULE_NAME@ 

@MODULE_DESC@

---

## File Tree
<details>
  <summary>See file tree</summary>

```bash
.
├── cmake
│   └── @MODULE_NAME@Config.cmake.in
├── CMakeLists.txt
├── include
│   └── @MODULE_NAME@/*.h
├── src
│   └── *.cpp
├── resources
│   └── *.qrc
├── qml
│   └── *.qml
├── shaders
│   └── *.frag / *.vert
├── examples
│   ├── CMakeLists.txt
│   └── main.cpp
├── tests
│   ├── CMakeLists.txt
│   └── test_main.cpp
├── README.md
├── install.sh
└── uninstall.sh
```
</details>

---

## Table of Contents
1. [Requirements](#requirements)
2. [Build and Installation](#build-and-installation)
3. [Usage and Importing](#usage-and-importing)
4. [Features](#features)
5. [Example](#example)
6. [Additional Notes](#additional-notes)
7. [Information](#information)
8. [TODO](#todo)
---

## Requirements
- C++: Minimum C++11 (Recommended C++17)
- Qt: 5.15+ (Supports Qt6)
- OpenGL: Required version depends on the module
- CMake: 3.14+
- OS: Cross-platform (Linux, Windows, macOS)
---
## Build and Installation
This project uses **CMake** as its build system and is cross-platform.

### 1. Clone the Repository
```bash
git clone <repository_url>
cd <repository_root>/@MODULE_NAME@
```

### 2. Build Instruction

<details><summary><h4> Linux </h4></summary> 

Make sure you have **cmake** and a **C++ compiler (gcc/g++)**

```bash
chmod +x install.sh
sudo ./install.sh [INSTALL_PREFIX]
```


> [!NOTE]
> Usually the `INSTALL_PREFIX` on linux is: `/usr/local/...`.


> [!NOTE]
> You can pass custom `INSTALL_PREFIX` like below.


</details>

<details><summary><h4> Windows </h4></summary>

Make sure you have **CMake** and **(MinGW or MSVC)**  compiler installed.
Run `cmd` as Adminstrator, then do like below:

```bash
mkdir BUILD
cd BUILD
cmake .. -G "MinGW Makefiles" -DCMAKE_INSTALL_PREFIX="C:/My/Custom/Path"
cmake --build . --config Release
cmake --install .
```


> [!NOTE]
> Usually the `CMAKE_INSTALL_PREFIX` on windows is: `C:/Program Files/WeaChart/`.


> [!NOTE]
> You can pass custom `CMAKE_INSTALL_PREFIX` like below.

```bash
...
cmake .. -DBUILD_EXAMPLE=OFF -G "MinGW Makefiles" -DCMAKE_INSTALL_PREFIX="C:/My/Custom/Path/WeaChart"
...
```
</details>

<details><summary><h4> Using the source code </h4></summary>

To avoid installing the library and using it via source code follow these steps:
1. Create directory named `libs/@MODULE@` in your **PROJECT_SOURCE_ROOT**.
2. Copy the `include`, `qml`, `shaders`, `src` and `resources.qrc` to your  **PROJECT_SOURCE_ROOT/libs/@MODULE@**
3. Add `libs/@MODULE@` directory using **Add Existing Directory**.
4. Add `libs/@MODULE@/include` to your project **INCLUDEPATH**.
5. To import **@MODULE@ Qml types & components**, follow like below:

```qml
// Your .qml file
import com.wearily.@MODULE_NAME@ 1.0 // Importing registered components

```
</details>

## Usage and Importing

> [!NOTE]
> If after assigning **QML_IMPORT_PATH** Components were still **Unknown**, restart Qt Creator application and then it works :)

<details><summary><h3> qmake </h3></summary>

Here is an example of usage **WeaChart** on **.pro** application:

```qmake
QT += quick core opengl
CONFIG += c++17

...

# The path will comes from INSTALL_PREFIX at installation stage.
# You can print "WeaChart_QML_IMPORT_PATH" constant on main.cpp to see which path is on your system.
QML_IMPORT_PATH = /usr/local/share/qml/ # Change it with your installation path.
... 

unix:!macx: LIBS += -L/usr/local/lib64 -lWeaChart # Change it with your installation path.
unix:!macx: INCLUDEPATH += /usr/local/include # Change it with your installation path.

```
</details>

<details><summary><h3> CMake </h3></summary>

Here is an example of usage **WeaChart** on **CMakeLists.txt**.

```CMake

cmake_minimum_required(VERSION 3.14)
project(myProject VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Quick OpenGL)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Quick OpenGL)
# Note: If you installed on specific location path make sure you specify here like: find_package(WeaChart PATHS "my/custom/path/" REQUIRED)
find_package(WeaChart REQUIRED) 

# Note: Also its same like above Note.
# Optional.
# You can print "WeaChart_QML_IMPORT_PATH" constant on main.cpp to see which path is on your system.
set(QML_IMPORT_PATH /usr/local/share/qml CACHE STRING "" FORCE)

add_executable(myProject
        main.cpp
        qml.qrc
)

target_link_libraries(myProject PRIVATE Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Quick WeaChart::WeaChart)

```
</details>

## Features
- Feature 1 (describe module feature)
- Feature 2 (optional)
- Supports QML/Plugin integration (if applicable)
- Configurable options exposed via header or QML

## Example
Import all files and directories instead **example** directory to your project.

### Quick Start

<details><summary> main.cpp </summary>

```cpp
#include <QGuiApplication>
#include <QQmlApplicationEngine>
// Include your module headers
#include <@MODULE_NAME@/SomeClass.h>

int main(int argc, char** argv) {
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    // optional: register types
    SomeClass::registerMetaTypes(&engine);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    return app.exec();
}

```
</details>

<details><summary> main.qml </summary>

```qml
import QtQuick 2.12
import com.wearily.@MODULE_NAME@ 1.0

Window {
    visible: true
    width: 400
    height: 400
    title: "@MODULE_NAME@ Example"
}

```
</details>

## Additional Notes
- Customizable options depend on module
- Supports cross-platform development
- Optimized for performance if applicable

## Information
- Official documentation: TBD
- Source code comments: see `include/@MODULE_NAME@/*.h`

## TODO
- [ ] Some todo content
