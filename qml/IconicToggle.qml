import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

WeaQuick.IconFont {
    id: root

    property bool toggled: false

    property alias mouseArea: mouseArea

    width: implicitWidth
    height: implicitHeight

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: root.enabled
        acceptedButtons: Qt.LeftButton
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            toggled = !toggled;
        }
    }
}
