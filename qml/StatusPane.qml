import QtQuick 2.12
import QtQuick.Layouts 1.12

BorderRectangle {
    id: root

    property alias toggleStatusOutput: plcIOStatus.toggleOutput
    property alias manualActive: plcIOStatus.manualActive

    title: "Status"
    level: 0

    ColumnLayout {
        anchors {
            fill: parent
            margins: 10
            topMargin: 0
        }
        spacing: 15

        ShineLine {
            Layout.fillWidth: true
            color: "orange"
        }

        AnalogStatus {
            id: analogStatus
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 25

            // Indices should be same as analogModel
            values: [servoXDevice.encoderPUU, servoYDevice.encoderPUU, servoXDevice.encoderPUU, servoYDevice.encoderPUU]
            analogModel: [
                {
                    title: "X-Axis Encoder PUU: ",
                    decimals: 0,
                    suffix: " pulse"
                },
                {
                    title: "Y-Axis Encoder PUU: ",
                    decimals: 0,
                    suffix: " pulse"
                },
                {
                    title: "X-Axis Distance: ",
                    decimals: 3,
                    suffix: " mm"
                },
                {
                    title: "Y-Axis Distance: ",
                    decimals: 3,
                    suffix: " mm"
                }
            ]
        }

        ShineLine {
            Layout.preferredWidth: parent.width - parent.width / 6
            color: "orange"
        }

        PLCIOStatus {
            id: plcIOStatus
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 75
            digitalInputsModel: _plcIOModel.inputs
            digitalOutputModel: _plcIOModel.outputs
        }
    }
}
