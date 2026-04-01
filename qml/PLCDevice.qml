import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

WeaQuick.Pane {
    id: root

    property alias modelName: titleLabel.text

    property alias titleLabel: titleLabel

    property real padding: 0
    property real leftPadding: padding
    property real rightPadding: padding
    property real bottomPadding: padding
    property real topPadding: padding

    level: 1
    flat: false
    gradientOrientation: Qt.Horizontal

    WeaQuick.Label {
        id: titleLabel

        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
            left: parent.left
            margins: padding
            leftMargin: leftPadding
            rightMargin: rightPadding
            bottomMargin: bottomPadding
            topMargin: topPadding
        }

        rotation: -90
        font.pixelSize: 45
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
        text: "DVP-28SA11T"
    }
}
