import QtQuick 2.15
import QtQuick.Controls 2.15
//import Qt.labs.qmlmodels 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import Qt.labs.platform 1.0
import QtQuick.Controls.Material 2.12
//import QtQuick.Controls.Styles 1.4
import QtQuick.Shapes 1.12
import QtCharts 2.3
import QtLocation 5.6
//import QtPositioning 5.6
import QtQuick.Extras 1.4
import QtQuick.Controls.Styles 1.4
import QtQml 2.12
import QtGraphicalEffects 1.12

import "./common"
import "./models"


ApplicationWindow {
    visible: true
    width: 1250
    height: 800
    title: "Radar with TableView"
    color: "#001820"

    property var targetModel: proxyModel

    Rectangle {
        anchors.fill: parent
//        z: 1
    ColumnLayout {
        anchors.fill: parent
        spacing: 10
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 100


            RadarView {
                Layout.preferredHeight: 500
                Layout.preferredWidth: 500
                Layout.leftMargin: 30
                tarModel: targetModel
            }
            ModelTableView {
                tableModel: targetModel
                id: table
                Layout.fillHeight: true
                Layout.fillWidth: true

//                columns: [{"name": "id", "title": "Id", "visible": true, "columnWidth": null},
//                    {"name": "row", "title": "Row", "visible": true, "columnWidth": null},
//                    {"name": "azimuth", "title": "Az", "visible": true, "columnWidth": null},
//                {"name": "elevation", "title": "Elv", "visible": true, "columnWidth": null},
//                {"name": "rangeCell", "title": "Range", "visible": true, "columnWidth": 400},
//                {"name": "power", "title": "Power", "visible": true, "columnWidth": null}]
                columns: targetModel.headersData()

//                cellColorList: ["purple"]
//                cellsBorderColorList: ["brown", "dark-blue", "black"]
//                selectedCellsBorderColor: "gray"
//                hoverCellsBorderColor: "red"

            }

        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 20

//             Fps {
//                 id: fpsItem
//                 width: 1
//                 height: 1
//                 visible: true
//             }
//             Label {
//                 id: lblFps
//                 width: 150
//                 height: 75
//                 font.pointSize: 11
//                 font.bold: true
//                 text: qsTr("FPS: ") + fpsItem.fps
// //                text: qsTr("FPS: ") + fpsC.

//             }
            TextArea {
                id: txtFilter
                placeholderText: "type to filter..."
                onTextChanged: {
                    targetModel.filterString = text;
                }
            }

            Button {
                text: "Remove Column"
                onClicked: {

                    console.log(sbTargetId.value)
                    console.log(Object.keys(table))
                    console.log("And targetModel", targetModel)
                    targetModel.removeItem(sbTargetId.value)
                }
            }
            CheckBox {
                text: "Column Visible"
                onClicked: {
//                    for (let i = 0; i < table.columns.length; ++i) {
//                        console.log("Name", table.columns[i].name)
//                        if (table.columns[i].name === "row") {
////                            table.columns[i].visible = checked;
//                            table.columns[i].columnWidth = checked ? 50 : null
//                            table.columns = JSON.parse(JSON.stringify(table.columns))
//                            console.log("Visiblity of Az: ", table.columns[i].visible)
//                            break

//                        }

//                    }
                    table.columns[sbTargetId.value].visible = checked
                    table.columns = JSON.parse(JSON.stringify(table.columns))

                }
            }
            SpinBox {
                id: sbTargetId
            }
        }
    }
}

}

