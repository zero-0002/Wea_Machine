import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

WeaQuick.Pane {
    id: root

    property bool applyContentMargins: true

    property alias title: titleLabel.text
    property alias titleSize: titleLabel.font.pixelSize
    property alias titleHAlignment: titleLabel.horizontalAlignment
    property alias titleVAlignment: titleLabel.verticalAlignment

    property alias titleLabel: titleLabel
    default property alias contentItem: contentItem.data

    level: 1
    flat: false

    WeaQuick.Label {
        id: titleLabel
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: 10
        }

        text: "Title"
        font.pixelSize: 17
        horizontalAlignment: Qt.AlignHCenter
    }

    Item {
        anchors {
            top: titleLabel.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: applyContentMargins ? 10 : 0
        }

        Item {
            id: contentItem
            anchors.fill: parent
        }
    }
}
