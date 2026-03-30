import QtQuick 2.12

import com.wearily.WeaQuick 1.0 as WeaQuick
import CustomItems 1.0

Item {
    id: root

    property alias model: repeater.model

    implicitHeight: 32

    Row {
        anchors.fill: parent
        spacing: 5
        layoutDirection: Qt.RightToLeft

        Repeater {
            id: repeater
            delegate: WeaQuick.StatusIndicator {
                id: statusCommunicationSuccess

                height: root.implicitHeight - 5
                width: height
                radius: 4
                borderWidth: 1
                outerMargin: 3

                iconSize: 10

                iconName: modelData.iconName
                levelActive: modelData.levelActive
                active: modelData.active
                blinking: modelData.blinking
            }
        }

        // FPS Label
        WeaQuick.Label {
            id: fpsLabel
            text: "FPS %1".arg(fpsObject.fps)
            width: 60
            height: root.implicitHeight
            font.pixelSize: 13
            horizontalAlignment: Qt.AlignLeft
            verticalAlignment: Qt.AlignVCenter
        }
    }

    // FPS Calculator
    Fps {
        id: fpsObject
        x: 0
        y: 0
        width: 1
        height: 1
    }
}
