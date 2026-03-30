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
            spacing: 5
            ServoGauges {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 50
            }

            // Rectangle {
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 50
                spacing: 5

                AlarmTable {
                    id: alaramTable
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.preferredWidth: 50
                }

                StatusPane {
                    id: statusPane
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.preferredWidth: 50
                }
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
        width: 380
    }
}
