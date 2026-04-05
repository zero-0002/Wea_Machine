import QtQuick 2.12
import QtQuick.Layouts 1.12
import com.wearily.WeaQuick 1.0 as WeaQuick
import CustomItems 1.0

Item {
    id: root

    property SerialConnection serialConnection: SerialConnection {
        portName: cboxPorts.currentText
        baudRate: serialGlobal.mapToBaudRate(cboxBaudRate.currentValue)
        parity: serialGlobal.mapToParity(cboxParity.currentValue)
        stopBits: serialGlobal.mapToStopBits(cboxStopBits.currentValue)
        dataBits: serialGlobal.mapToDataBits(labelDataBits.text)
    }

    readonly property int controlPreferredWidth: 150
    readonly property int controlPreferredHeight: 27

    property int fontSize: 14

    property alias title: titleLabel.text

    signal openConnection
    signal closeConnection

    // implicitWidth: 350
    // implicitHeight: 500

    WeaQuick.Label {
        id: titleLabel
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        font.pixelSize: 17
    }

    Column {
        anchors {
            top: titleLabel.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 20
        }
        spacing: 20

        Compact {
            tagName: "Port: "

            CusComboBox {
                id: cboxPorts
                anchors.right: parent.right
                width: controlPreferredWidth
                model: serialGlobal.availablePorts
            }
        }

        Compact {
            tagName: "BaudRate: "

            CusComboBox {
                id: cboxBaudRate
                anchors.right: parent.right
                width: controlPreferredWidth

                model: serialGlobal.baudRates
                currentIndex: model.length - 1
            }
        }

        Compact {
            tagName: "DataBits: "

            WeaQuick.Label {
                id: labelDataBits
                anchors.right: parent.right
                height: controlPreferredHeight
                width: controlPreferredWidth

                font.pixelSize: root.fontSize
                verticalAlignment: Qt.AlignVCenter
                text: "8"
            }
        }

        Compact {
            tagName: "Parity: "

            CusComboBox {
                id: cboxParity
                anchors.right: parent.right
                width: controlPreferredWidth

                model: serialGlobal.parities
                currentIndex: 1
            }
        }

        Compact {
            tagName: "StopBits: "

            CusComboBox {
                id: cboxStopBits
                anchors.right: parent.right
                width: controlPreferredWidth

                model: serialGlobal.stopBits
            }
        }

        // Compact {
        //     tagName: "Slave Address: "

        //     WeaQuick.EditBox {
        //         id: editBoxSlaveAddr
        //         anchors.right: parent.right
        //         width: controlPreferredWidth

        //         level: 0
        //         flat: false
        //         font.pixelSize: root.fontSize

        //         from: 1
        //         to: 127
        //         decimals: 0
        //         stepSize: 1
        //         value: 1
        //     }
        // }

        // Connect/Disconnect Buttons

        Row {
            anchors.right: parent.right
            spacing: 5
            WeaQuick.Button {
                id: connectButton

                enabled: !serialConnection.connected

                level: 5
                width: 110
                flat: false

                text: "Connect"
                font.pixelSize: root.fontSize
                onClicked: {
                    openConnection();
                }
            }

            WeaQuick.Button {
                id: disconnectButton

                enabled: serialConnection.connected

                level: 5
                width: 115
                flat: false

                text: "Disconnect"
                font.pixelSize: root.fontSize
                onClicked: {
                    closeConnection();
                }
            }
        }
    }

    // Objects & Inline-Components
    component Compact: Item {

        property alias tagName: label.text
        property alias tagHeight: label.height
        property alias tag: label

        anchors {
            left: parent.left
            right: parent.right
        }

        height: controlPreferredHeight

        WeaQuick.Label {
            id: label
            height: parent.height
            verticalAlignment: Qt.AlignBottom
            font.pixelSize: root.fontSize
        }
    }
}
