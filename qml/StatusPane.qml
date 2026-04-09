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
            digitalInputsModel: [
                {
                    title: "X0"
                },
                {
                    title: "X1"
                },
                {
                    title: "X2"
                },
                {
                    title: "X3"
                },
                {
                    title: "X4"
                },
                {
                    title: "X5"
                },
                {
                    title: "X6"
                },
                {
                    title: "X7"
                },
                {
                    title: "X20"
                },
                {
                    title: "X21"
                },
                {
                    title: "X22"
                },
                {
                    title: "X23"
                },
                {
                    title: "X24"
                },
                {
                    title: "X25"
                },
                {
                    title: "X26"
                },
                {
                    title: "X27"
                },
            ]
            digitalOutputModel: [
                {
                    title: "Y0"
                },
                {
                    title: "Y1"
                },
                {
                    title: "Y2"
                },
                {
                    title: "Y3"
                },
                {
                    title: "Y4"
                },
                {
                    title: "Y5"
                },
                {
                    title: "Y6"
                },
                {
                    title: "Y7"
                },
                {
                    title: "Y20"
                },
                {
                    title: "Y21"
                },
                {
                    title: "Y22"
                },
                {
                    title: "Y23"
                },
            ]
        }
    }
}
