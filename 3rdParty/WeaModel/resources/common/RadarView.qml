import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: radar
    property real centerX: width / 2
    property real centerY: height / 2
    property var tarModel

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
