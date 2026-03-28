import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQml.Models 2.12
import QtQuick.Controls 2.12

import com.wearily.WeaQuick 1.0 as WeaQuick
// Including ExamplePane
import "../"

ExamplePane {
    id: root

    spacing: 0

    title: "Font Awesome Pro Solid Icons.\n"

    contentItem: ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 5

        WeaQuick.SearchEdit {
            id: searchEdit
            Layout.preferredWidth: 165
            Layout.preferredHeight: 30
            Layout.alignment: Qt.AlignCenter

            sourceData: Object.keys(FontAwesome.icons)
            // caseSensitive: true
            // applyFilterType: SearchEdit.ApplyFilterType.SubmitApply
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            GridView {
                id: grid
                anchors.fill: parent
                anchors.margins: 30
                clip: true
                cellWidth: 50
                cellHeight: 50
                model: searchEdit.filteredData

                delegate: WeaQuick.IconFont {
                    name: "%1".arg(WeaQuick.FontAwesome.icons[modelData])
                    pixelSize: 16

                    MouseArea {
                        id: mouseContains
                        anchors.fill: parent
                        hoverEnabled: true
                    }

                    ToolTip {
                        delay: 500
                        visible: mouseContains.containsMouse
                        text: "%1".arg(modelData)
                    }
                }
            }
        }
    }
}
