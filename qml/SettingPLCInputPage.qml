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
                id: plcDevice
                anchors {
                    top: parent.top
                    right: parent.right
                }

                height: inputModel.height
            }

            PLCDevice {
                id: pcDevice
                anchors {
                    top: parent.top
                    left: parent.left
                }

                modelName: "PC Device"
                height: inputModel.height
            }

            PLCDigitalConfigModel {
                id: inputModel

                anchors {
                    left: pcDevice.right
                    right: plcDevice.left
                }
            }
        }
    }
}
