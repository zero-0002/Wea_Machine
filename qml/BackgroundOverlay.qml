import QtQuick 2.12

Rectangle {
    id: root

    visible: opacity > 0.0
    opacity: 0.0
    color: "#555"

    Behavior on opacity {
        NumberAnimation {
            duration: 100
        }
    }
}
