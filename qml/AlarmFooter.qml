import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Rectangle {
    id: root

    property alias resetAlarms: buttonResetAlarms
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

        CusDelayButton {
            id: buttonResetAlarms
            anchors.verticalCenter: parent.verticalCenter
            level: 5
            height: 40

            text: "Reset Alarms"
        }
    }
}
