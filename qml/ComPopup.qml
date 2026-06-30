import QtQuick 2.12
import QtQuick.Layouts 1.12
import com.wearily.WeaQuick 1.0 as WeaQuick

CusPopup {
    id: root

    property alias communicationType: cboxComType.currentIndex // 0 = SERIAL, 1 = TCP

    property alias plcTcpConnection: plcTcpConfig.connection
    property alias plcSerialConnection: plcSerialConfig.connection

    property alias servoTcpConnectionX: servoTcpConfigX.connection
    property alias servoTcpConnectionY: servoTcpConfigY.connection
    property alias servoSerialConnection: servoSerialConfig.connection

    property alias plcTcpConfig: plcTcpConfig
    property alias plcSerialConfig: plcSerialConfig

    property alias servoTcpConfigX: servoTcpConfigX
    property alias servoTcpConfigY: servoTcpConfigY
    property alias servoSerialConfig: servoSerialConfig

    title: "Communication"
    popUpDelegate: Item {
        anchors.fill: parent

        Flickable {
            id: flickable

            anchors {
                fill: parent
                topMargin: 20
            }

            clip: true
            boundsBehavior: Flickable.StopAtBounds
            contentWidth: width
            contentHeight: layout.height

            Column {
                id: layout
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: 15
                }
                spacing: 15

                CusComboBox {
                    id: cboxComType // TCP, SERIAL
                    anchors {
                        right: parent.right
                    }

                    width: 150
                    model: ["Serial", "TCP"]
                }

                Item {
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                    height: plcTcpConfig.visible ? 240 : 400

                    // TCP
                    TcpConfig {
                        id: plcTcpConfig
                        anchors {
                            top: parent.top
                            left: parent.left
                            right: parent.right
                            bottom: plcLineFooter.top
                        }
                        visible: cboxComType.currentIndex === 1
                        title: "PLC TCP"
                    }

                    // SERIAL
                    SerialConfig {
                        id: plcSerialConfig
                        anchors {
                            top: parent.top
                            left: parent.left
                            right: parent.right
                            bottom: plcLineFooter.top
                        }
                        visible: cboxComType.currentIndex === 0
                        title: "PLC Serial"
                        baudRateComboBox.currentIndex: 4
                    }

                    ShineLine {
                        id: plcLineFooter
                        anchors {
                            left: parent.left
                            right: parent.right
                        }
                        y: parent.height - height - 10
                    }
                }

                Item {
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                    height: 400

                    ColumnLayout {
                        anchors {
                            top: parent.top
                            left: parent.left
                            right: parent.right
                        }
                        visible: cboxComType.currentIndex === 1
                        height: 400
                        spacing: 15

                        // TCP X
                        TcpConfig {
                            id: servoTcpConfigX
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            defaultPort: 503
                            title: "X-Servo Tcp"
                            visible: cboxComType.currentIndex === 1
                        }

                        ShineLine {
                            Layout.fillWidth: true
                            visible: cboxComType.currentIndex === 1
                        }

                        // TCP Y
                        TcpConfig {
                            id: servoTcpConfigY
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            defaultPort: 504
                            title: "Y-Servo Tcp"
                            visible: cboxComType.currentIndex === 1
                        }
                    }

                    // SERIAL
                    SerialConfig {
                        id: servoSerialConfig
                        anchors {
                            top: parent.top
                            left: parent.left
                            right: parent.right
                        }

                        title: "Servo Serial"
                        visible: cboxComType.currentIndex === 0
                    }
                }
            }
        }
    }
}
