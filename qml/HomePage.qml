import QtQuick 2.12
import QtQuick.Layouts 1.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Item {
    id: root

    Item {
        id: mainContent
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: stepBar.left
            margins: 10
            rightMargin: stepBar.padding + 10
        }

        ColumnLayout {
            id: vLayout
            anchors.fill: parent
            spacing: 10
            ServoGauges {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            // Rectangle {
            Item {
                id: statusAndAlarm
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }

    // Step Bar
    StepBar {
        id: stepBar
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
        }
        width: 330
    }
}
