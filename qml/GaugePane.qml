import QtQuick 2.12
import QtQuick.Layouts 1.12

BorderRectangle {
    id: root

    property alias rowLayout: rowLayout
    property alias columnLayout: columnLayout
    property alias servoIndicators: servoIndicators
    property alias torqueGauge: torqueGauge
    property alias speedGauge: speedGauge

    clip: true

    contentItem: Item {
        anchors.fill: parent

        RowLayout {
            id: rowLayout
            anchors.fill: parent

            ColumnLayout {
                id: columnLayout
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredWidth: 40

                DigitalIndicators {
                    id: servoIndicators
                    digitalInputsModel: 14
                    digitalOutputModel: 5
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }

                TorqueGauge {
                    id: torqueGauge
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
            }

            SpeedGauge {
                id: speedGauge
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredWidth: 60
            }
        }
    }
}
