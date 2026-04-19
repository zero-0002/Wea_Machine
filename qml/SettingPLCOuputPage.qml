import QtQuick 2.12
import QtQuick.Controls 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Item {
    id: root

    Flickable {
        id: view
        anchors {
            fill: parent
            margins: 35
            leftMargin: 0
            topMargin: 0
        }

        clip: true
        contentWidth: width
        contentHeight: plcDevice.height
        boundsBehavior: Flickable.StopAtBounds

        ScrollBar.vertical: CusScrollBar {}
        Item {
            anchors {
                fill: parent
                margins: 10
                topMargin: 0
                rightMargin: 15
            }

            PLCDevice {
                id: pcDevice
                anchors {
                    top: parent.top
                    right: parent.right
                }

                modelName: "PC Device"
                height: outputModel.height
            }

            PLCDevice {
                id: plcDevice
                anchors {
                    top: parent.top
                    left: parent.left
                }

                height: outputModel.height
            }

            PLCDigitalConfigModel {
                id: outputModel

                isOutput: true

                anchors {
                    left: plcDevice.right
                    right: pcDevice.left
                }
            }
        }
    }
}
