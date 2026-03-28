import QtQuick 2.12
import QtQuick.Layouts 1.12
import com.wearily.WeaQuick 1.0

Pane {
    id: root

    level: 2
    flat: false

    property int spacing: 5

    property alias title: lblTitle.text
    property alias titleLabel: lblTitle

    default property alias contentItem: contentItem.data

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: root.spacing
        Label {
            id: lblTitle
            Layout.fillWidth: true
            Layout.preferredHeight: contentHeight + 10

            horizontalAlignment: Qt.AlignHCenter
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Item {
                id: contentItem
                anchors.fill: parent
            }
        }
    }
}
