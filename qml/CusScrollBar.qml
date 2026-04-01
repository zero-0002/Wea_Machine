import QtQuick 2.12
import QtQuick.Controls 2.12

ScrollBar {
    id: root

    implicitWidth: 7

    size: 0.3
    position: 0.2
    active: true
    orientation: Qt.Vertical
    contentItem: Rectangle {
        radius: width / 2
        color: root.pressed ? "orange" : "#111"
        opacity: root.policy === ScrollBar.AlwaysOn || (root.active && root.size < 1.0) ? 0.75 : 0

        Behavior on opacity {
            NumberAnimation {}
        }

        Behavior on color {
            ColorAnimation {}
        }
    }
}
