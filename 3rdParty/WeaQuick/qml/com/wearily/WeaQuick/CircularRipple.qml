import QtQuick 2.12

Rectangle {
    id: root

    /** REQUIRED Properties **/
    property bool active: false
    property color targetColor

    /** Default Properties **/
    property real size: 22 // Size instead width/height because its circle
    property real defaultOpacity: 0.4
    property real focusedOpacity: defaultOpacity * 1.5
    property bool hasFocused: false

    visible: opacity > 0

    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    width: size
    height: size
    radius: size / 2

    opacity: enabled && active ? hasFocused ? focusedOpacity : defaultOpacity : 0.0
    color: Qt.rgba(targetColor.r, targetColor.g, targetColor.b, opacity)

    /** Animations **/
    Behavior on opacity {
        NumberAnimation {
            duration: 150
        }
    }
}
