import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Rectangle {
    // GUI Option & Properties
    property int headerCellHeight: 45
    property int cellHeight: 30
    property int cellWidth: 200
    property int cellSpacing: 0
    property bool fixedHeader: false

    property int headerBorderWidth: 1
    property int rowBorderWidth: 1

    property color headerColor: "#001920"
    property color headerBorderColor: "#179998"
    property color headerTextColor: "#179998"

    property var rowColors: ["#00171f", "#001820"] // For example-> row1.color = gray, row2.color = LightGray, row3.color = gray and ...
    property var rowBorderColors: ["#179998"] // Just like the cellColorList By default is sync with cellsColor
    property var rowTextColors: ["#ffffff"]

    property color selectColor: "#179998"
    property color selectBorderColor: "#ffffff" // By default is sync with cellsColor
    property color selectTextColor: "#000f16"

    property color hoverColor: "#027c72"
    property color hoverBorderColor: "#179998" // By default is sync with cellsColor
    property color hoverTextColor: "#ffffff"

    property font headerFont: Qt.font({ family: "Arial", pointSize: 13, weight: 300, bold: true})
    property font rowFont: Qt.font({ family: "Arial", pointSize: 11,  weight: 300, bold: false})

    // Table Props
    property var tableModel
    property int hoverRow: -1

    // Ordering Props
    property var columns /** name: str, title: str, visible: bool, columnWidth: int || null **/

    // Headers (Columns)
    clip: true
    color: "#001820"
    Row {
        id: tableHeader
        width: tableView.contentWidth
        height: headerCellHeight
        x: fixedHeader ? 0 : -tableView.contentX
        z: 1
        spacing: cellSpacing

        Repeater {
            model: columns
            Rectangle {
                width: modelData.columnWidth ? modelData.columnWidth : cellWidth
                height: parent.height
                color: headerColor
                border.color: headerBorderColor
                border.width: headerBorderWidth
                visible: modelData.visible
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    x: 4
                    width: parent.width - 4
                    text: modelData.title
                    font: headerFont
                    color: headerTextColor
                    elide: Text.ElideRight
                }
            }

        }
    }
    // Main (Rows)
    TableView {
        id: tableView
        anchors.fill: parent
        anchors.topMargin: tableHeader.height
        columnSpacing: cellSpacing; rowSpacing: cellSpacing
        model: tableModel
        columnWidthProvider: function(column) { return Math.min(200, 1000)}
        reuseItems: true

        ScrollBar.horizontal: ScrollBar { }
        ScrollBar.vertical: ScrollBar { }
        delegate: Row {

            function getRoleValue(role) {
                return model[role]
            }

            function getColor(row, colorList, colorSelect, colorHover) {
                if (itemSelected)
                    return colorSelect
                if (hoverRow === row)
                    return colorHover
                return colorList[row % colorList.length]
            }

            Repeater {
                model: columns
                delegate: Rectangle {
                    id: rowRect
                    color: getColor(row,
                                    rowColors,
                                    selectColor,
                                    hoverColor)
                    border.color: getColor(row,
                                           rowBorderColors,
                                           selectBorderColor,
                                           hoverBorderColor)
                    border.width: rowBorderWidth
                    width: rowValue.width
                    height: rowValue.height
                    visible: modelData.visible

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            tableModel.selectItem(row)
                        }
                        onEntered: {
                            hoverRow = row
                        }
                        onExited: {
                            if (hoverRow === row)
                                hoverRow = -1
                        }
                    }

                    Text {
                            id: rowValue
                            text: getRoleValue(modelData.name)
                            font: rowFont
                            width: modelData.columnWidth ? modelData.columnWidth : cellWidth
                            height: cellHeight
                            color: getColor(row,
                                            rowTextColors,
                                            selectTextColor,
                                            hoverTextColor)
                            elide: column === 49 ? Text.ElideLeft : Text.ElideRight
                            horizontalAlignment: Qt.AlignHCenter
                            verticalAlignment: Qt.AlignVCenter
                        }

                    }

                }

            }

        }

    }
