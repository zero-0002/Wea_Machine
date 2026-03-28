# Qt TableView Framework with Dynamic Model Abstraction

This project provides a lightwright and modular framework for integrating a `QAbstractListModel` with QML's `TableView`. It is designed to seprate logic from UI while offering filtering, dynamic columns, styling support, and real-time updates.
---

## File Tree
```bash
.
├── CMakeLists.txt
├── common
│   ├── fps.h
│   ├── worker.cpp
│   └── worker.h
├── main.cpp
├── models
│   ├── examples
│   │   ├── SortFilterProxy.h
│   │   ├── Target.h
│   │   └── TargetModel.h
│   ├── IQItemListModel.h
│   ├── QItemBase.h
│   ├── QItemListModel.h
│   └── QItemSortFilterProxyModel.h
├── README.md
├── resources
│   ├── common
│   │   ├── RadarView.qml
│   │   └── TargetItem.qml
│   ├── main.qml
│   ├── models
│   │   └── ModelTableView.qml
│   └── qml.qrc
└── tree.txt

```

---

## Core C++ Classes
### QItemBase.h
A base template class for list items. Designed for type-safe and generic item structures in a list model.
### IQItemListModel.h
Abstract base class providing interface for items count, data access, notifications, and more.
### QItemListModel.h
Implements a typed list model using `IQItemListModel` with template. Designed for reuse with any custom item type.
### QItemSOrtFilterProxyModel
A base template class which inherited from `QSortFilterProxyModel`. You can use this class as your parent SortFilterProxy class.

---

## QML Component

### ModelTableView.qml
Reusable QML `TableView` that accepts a `QAbstractListModel`.

**Required Properies:**
- `columns: var` - Defines table columns [{name: "azimuth", title: "Az", "visible": true, columnWidth: 200}, ...] OR you can just use with `myTableModel.getHeadersData()`.
- `tableModel: var` - Defines model.

**Optional properties** 
- property int headerCellHeight: 45
- property int cellHeight: 30
- property int cellWidth: 200
- property int cellSpacing: 0
- property bool fixedHeader: false
- property int headerBorderWidth: 1
- property int rowBorderWidth: 1
- property color headerColor: "#001920"
- property color headerBorderColor: "#179998"
- property color headerTextColor: "#179998"
- property var rowColors: ["#00171f", "#001820"] // For example-> row1.color = gray, row2.color = LightGray, row3.color = gray and ...
- property var rowBorderColors: ["#179998"] // Just like the cellColorList By default is sync with cellsColor
- property var rowTextColors: ["#ffffff"]
- property color selectColor: "#179998"
- property color selectBorderColor: "#ffffff" // By default is sync with cellsColor
- property color selectTextColor: "#000f16"
- property color hoverColor: "#027c72"
- property color hoverBorderColor: "#179998" // By default is sync with cellsColor
- property color hoverTextColor: "#ffffff"
- property font headerFont: Qt.font({ family: "Arial", pointSize: 13, weight: 300, bold: true})
- property font rowFont: Qt.font({ family: "Arial", pointSize: 11,  weight: 300, bold: false})

---

## Sample Model Classes

### Target.h
Custom data item representing a radar target(Or you can replace it with your own ItemClass). Inherits from `QItemBase.h`.

**Must include**

**Note**: Replace these attributes with your own data.

```cpp
    enum class TargetRoles : int {
        AzimuthRole = Qt::UserRole + 1,
        ElevationRole,
        RangeCellRole,
        PowerRole,
        SelectedRole,
        RowRole,
        IdRole,
        TargetObjectRole,
        AllRole
    };
    Q_ENUM(TargetRoles)
    
    static QHash<int, QByteArray> getRoles() {
        return {
            {AzimuthRole, "azimuth"},
            {ElevationRole, "elevation"},
            {RangeCellRole, "rangeCell"},
            {PowerRole, "power"},
            { SelectedRole, "selected" },
            { RowRole, "row" },
            { IdRole, "id" },
            {TargetObjectRole, "targetObject",},
            {AllRole, "all"}
        };
    }
    
    QVariant getValueByRole(int role) override {
        switch (role) {
        case AzimuthRole: return azimuth();
        case ElevationRole: return elevation();
        case RangeCellRole: return rangeCell();
        case PowerRole: return power();
        case SelectedRole: return selected();
        case RowRole: return row();
        case IdRole: return id();
        case TargetObjectRole: return QVariant::fromValue(this);
    
        default: return {};
        }
    
    }
    

    QVariantMap getHeaderDataByRole(int role) const override {
        switch (role) {
        case static_cast<int>(TargetRoles::AzimuthRole): return QVariantMap({{"title", "Az"}, {"columnWidth", 100}, {"visible", true}, {"kill", false}}); // If False or not contains that will not kill else that gonna be removed from model.
        case static_cast<int>(TargetRoles::ElevationRole): return QVariantMap({{"title", "Elv"}, {"columnWidth", 100}, {"visible", true}});
        case static_cast<int>(TargetRoles::RangeCellRole): return QVariantMap({{"title", "RangeCell"}, {"columnWidth", 100}, {"visible", true}});
        case static_cast<int>(TargetRoles::NameRole): return QVariantMap({{"title", "Target Names"}, {"columnWidth", 100}, {"visible", true}});
        case static_cast<int>(TargetRoles::PowerRole): return QVariantMap({{"title", "Power"}, {"columnWidth", 100}, {"visible", true}});
    //        case static_cast<int>(TargetRoles::ItemSelectedRole): return QVariantMap({{"title", "Select"}, {"columnWidth", 100}, {"visible", true}});
    //        case static_cast<int>(TargetRoles::RowRole): return QVariantMap({{"title", "Row"}, {"columnWidth", 100}, {"visible", true}});
    //        case static_cast<int>(TargetRoles::IdRole): return QVariantMap({{"title", "ID"}, {"columnWidth", 100}, {"visible", true}});
        default: return QVariantMap();
        }
    }
```

---

**NOTE: As you see there is no need to implement RowRole, IdRole, SelectedRole. These base roles will implicitly add on [QItemListModel](http://172.16.50.13/parsa/qcustommodels/-/blob/main/models/QItemListModel.h#L307) class.**

---

**NOTE: If you want to ignore some roles on `TableView`, set `kill` key to `true` on getHeaderDataByRole initialization.**

### TargetModel.h

A model class derived from `QItemListModel<ItemType>`(ItemType at this session is Target class). Provides list data for the table.

**Impelmention Example**
```cpp

#include "QItemListModel.h"
#incldue "Target.h" // This must be your custom ItemType class that inherited with "QItemBase" class.

class TargetModel: public QItemListModel<Target> {
    Q_OBJECT
public:
};

```

### SortFilterProxy.h

Custom subclass of `QSortFilterProxyModel`.
Used to filter/search `TargetModel` (e.g. by ID, velocity, etc.).

**Here is the example of usage on `TextField` filtering:**

- Valids : 10 >,  22 <, 35 >=, 35 <=, 35 =, 10~37 and also the default 12 (only a single digit)

**Also you can use with multi columns filtering by seprating with ','**
- Valids :  id: 10 > , azimuth: 100.5 ~ 120.0, elevation: 120 >, ...

**Note:** the rule of the filtering patter is: "{role}: {minRange} {condition} {maxRange (optional)}, ..."

---

## Example & Utility Classes

### worker.h

Mock class for simulating incoming data.

- Periodically emits random target updates
- Can switch to real data over network with **#define USE_NETWORK_SOURCE**.
- Uses [WeaNet](http://172.16.50.13/parsa/wearily-netlib)  if available.

### fps.h

A QQuickPaintedItem subclass that calculates and paints FPS onto screen.

## Dependencies
- Qt5.15+ or Qt6x(QtQuick, QtQuick.Controls)
- (Optional) [WeaNet](http://172.16.50.13/parsa/wearily-netlib) for networking

## QML Usage
### ModelTableView Usage

```qml

ModelTableView {
    tableModel: targetModel
    id: table
    Layout.fillHeight: true
    Layout.fillWidth: true
    columns: targetModel.headersData()

//    cellColorList: ["purple"]
//    cellsBorderColorList: ["brown", "dark-blue", "black"]
//    selectedCellsBorderColor: "gray"
//    hoverCellsBorderColor: "red"

}

```
**Also you can set your customized header columns**

```qml
ModelTableView {
    tableModel: targetModel
    id: table
    Layout.fillHeight: true
    Layout.fillWidth: true
    columns: [{"name": "id", "title": "Id", "visible": true, "columnWidth": null},
                {"name": "row", "title": "Row", "visible": true, "columnWidth": null},
                {"name": "azimuth", "title": "Az", "visible": true, "columnWidth": null},
                {"name": "elevation", "title": "Elv", "visible": true, "columnWidth": null},
                {"name": "rangeCell", "title": "Range", "visible": true, "columnWidth": 400},
                {"name": "power", "title": "Power", "visible": true, "columnWidth": null}]

}

```

---

**And your Target on PPI can be like this**

**Note**: You can write your own TargetItem.qml (This one right here is just a sample).

**TargetItem.qml**
```qml
import QtQuick 2.15
Item {
    id: target
    property real centerX
    property real centerY
    property real azimuth
    property real elevation
    property real range
    property bool selected: false

    width: 10
    height: 10
    x: centerX + range * Math.cos(azimuth * Math.PI / 180) - width / 2
    y: centerY + range * Math.sin(azimuth * Math.PI / 180) - height/ 2

    Rectangle {
        anchors.fill: parent
        color: selected ? "yellow" : "red"
        radius: width / 2
    }

}
```

---

**RadarView.qml**
```qml
import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: radar
    property real centerX: width / 2
    property real centerY: height / 2
    property var tarModel // Should be pass same as ModelTableView.qml "targetModel"

    Rectangle {
        anchors.fill: parent
        color: "#001020"
        border.color: "green"
        border.width: 2
        radius: width / 2
    }

    Repeater {
        model: tarModel
        delegate: TargetItem {
            centerX: radar.centerX
            centerY: radar.centerY
            azimuth: model.azimuth
            elevation: model.elevation
            range: model.rangeCell
            selected: model.itemSelected
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    tarModel.selectItem(model.row)
                }
            }
        }
    }
}

```
---

## C++ Integration

### Initialization

```cpp
qmlRegisterType<Fps>("CustomItems", 1, 0, "Fps");
qmlRegisterType<SortFilterProxyModel>("CustomItems", 1, 0, "SortFilterProxyModel");

TargetModel targetModel; // Or create on heap (new keyword)
// Custom Filtering class
SortFilterProxyModel filter; 
filter.setSourceModel(&targetModel);
filter.m_targetModel = &targetModel;
filter.setFilterCaseSensitivity(Qt::CaseInsensitive);

...

engine.rootContext()->setContextProperty("tableModel", &targetModel);
engine.rootContext()->setContextProperty("proxyModel", &filter); // If you want to use filtering else uncommnet above line

```

### Model Items Insert/Edit/Remove

```cpp

...

// Inserting Example:
Target *target = Target();
targetModel.insertItem(target, 0); // 0 is just an Id an must be different for each item.
...

// Editing Example:
Target *target = targetModel.returnItemObject(0); // Also 0 is ItemId
target->setAzimuth(90.0);
target->setElevation(15.0);
...

// Remove Example:
targetModel.removeItem(0); // Also 0 is ItemId
...


```

