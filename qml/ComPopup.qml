import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

CusPopup {
    id: root

    property alias plcSerialConnection: plcSerialConfig.serialConnection
    property alias servoSerialConnection: servoSerialConfig.serialConnection

    property alias plcSerialConfig: plcSerialConfig
    property alias servoSerialConfig: servoSerialConfig

    title: "Serial Configuration"
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

                Item {
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                    height: 400

                    SerialConfig {
                        id: plcSerialConfig
                        anchors {
                            top: parent.top
                            left: parent.left
                            right: parent.right
                            bottom: plcLineFooter.top
                        }

                        title: "PLC Serial"
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

                    SerialConfig {
                        id: servoSerialConfig
                        anchors {
                            top: parent.top
                            left: parent.left
                            right: parent.right
                        }

                        title: "Servo Serial"
                    }
                }
            }
        }
    }
}
