import QtQuick 2.12
import QtQuick.Layouts 1.12

Item {
    id: root

    property alias xAxisGauge: xAxisGaugePane
    property alias yAxisGauge: yAxisGaugePane

    RowLayout {
        anchors.fill: parent
        spacing: 5

        GaugePane {
            id: xAxisGaugePane
            Layout.fillHeight: true
            Layout.fillWidth: true

            // level: 0
            title: "Servo X-Axis"

            servoIndicators.digitalInputsModel: [servoXDevice.di1, servoXDevice.di2, servoXDevice.di3, servoXDevice.di4,
                servoXDevice.di5, servoXDevice.di6, servoXDevice.di7, servoXDevice.di8, servoXDevice.di9,
                servoXDevice.di10, servoXDevice.di11, servoXDevice.di12, servoXDevice.di13, servoXDevice.di14]
            servoIndicators.digitalOutputModel: [servoXDevice.do1, servoXDevice.do2, servoXDevice.do3, servoXDevice.do4,
                servoXDevice.do5]

            torqueGauge.gauge.value: servoXDevice.currentTorque
            torqueGauge.editBoxGauge.textItem.text: "%1 %".arg(servoXDevice.currentTorque)

            speedGauge.gauge.value: servoXDevice.currentSpeed
            speedGauge.editBoxGauge.textItem.text: "%1 rpm".arg(servoXDevice.currentSpeed)
        }

        GaugePane {
            id: yAxisGaugePane
            Layout.fillHeight: true
            Layout.fillWidth: true
            // level: 0

            rowLayout.layoutDirection: Qt.RightToLeft
            title: "Servo Y-Axis"
        }
    }
}
