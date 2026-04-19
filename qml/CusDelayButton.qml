import QtQuick 2.12
import QtQuick.Controls 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

DelayButton {
    id: root

    property alias level: button.level
    property alias flat: button.flat

    property alias mouseArea: button.mouseArea
    property alias button: button

    delay: 1000

    contentItem: WeaQuick.Label {
        id: label
        text: root.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: WeaQuick.RectangleControl {
        id: button

        property alias textItem: label

        anchors.centerIn: parent

        implicitWidth: 100
        // implicitHeight: 35
        border.width: 1

        flat: false

        mouseArea.cursorShape: Qt.PointingHandCursor

        ShineLine {
            id: shineLine
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
            }

            width: progress * parent.width
        }

        mouseArea.onReleased: {
            progress = 0.0;
            shineLine.color = "white";
        }
    }

    onProgressChanged: {
        if (progress === 1.0) {
            activated();
        }
    }

    onActivated: {
        shineLine.color = "orange";
    }

    NumberAnimation on progress {
        running: button.mouseArea.pressed
        duration: delay
        from: 0.0
        to: 1.0
    }
}
