import QtQuick 2.12
import QtQuick.Layouts 1.12
import com.wearily.WeaQuick 1.0 as WeaQuick
import CustomItems 1.0

Item {
    id: root

    property TcpConnection connection: TcpConnection {
        host: lineEditHost.text
        port: editBoxPort.value
    }

    readonly property int controlPreferredWidth: 150
    readonly property int controlPreferredHeight: 27

    property int fontSize: 14

    property alias defaultPort: editBoxPort.value
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
            tagName: "Host: "

            WeaQuick.LineEdit {
                id: lineEditHost
                anchors.right: parent.right
                width: controlPreferredWidth
                text: "192.168.1.200"
                level: 2
                placeholderText: "0.0.0.0"
                font.pixelSize: root.fontSize
                horizontalAlignment: Qt.AlignHCenter
            }
        }

        Compact {
            tagName: "Port: "

            WeaQuick.EditBox {
                id: editBoxPort
                anchors.right: parent.right
                width: controlPreferredWidth
                from: 0
                to: 65535
                value: 502
                decimals: 0
                stepSize: 1
                level: 2
                flat: false
                font.pixelSize: root.fontSize
            }
        }

        // Connect/Disconnect Buttons

        Row {
            anchors.right: parent.right
            spacing: 5
            WeaQuick.Button {
                id: connectButton

                enabled: !connection.connected

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

                enabled: connection.connected

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
