import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Rectangle {
    id: root

    property alias model: repeater.model
    property alias layout: layout

    Row {
        id: layout
        anchors {
            fill: parent
            rightMargin: 5
            leftMargin: 5
        }
        layoutDirection: Qt.RightToLeft
        spacing: 10

        Repeater {
            id: repeater

            delegate: CusDelayButton {
                anchors.verticalCenter: parent.verticalCenter
                level: 5
                height: 40

                text: modelData.name
            }
        }
    }
}
