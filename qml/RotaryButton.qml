import QtQuick 2.12

IconicToggle {
    id: root

    property real defaultAngle: 0
    property real toggledAngle: 180

    property alias duration: rotationAnimation.duration
    property alias rotationAnimation: rotationAnimation

    rotation: toggled ? toggledAngle : defaultAngle

    horizontalAlignment: Qt.AlignHCenter
    verticalAlignment: Qt.AlignVCenter

    Behavior on rotation {
        RotationAnimation {
            id: rotationAnimation
            duration: 200
        }
    }
}
