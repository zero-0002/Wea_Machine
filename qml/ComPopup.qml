import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

/// TODO: bind real data with ComPopup model
CusPopup {
    id: root

    property alias model: listView.model

    title: "Serial Configuration"
    popUpDelegate: Item {
        anchors.fill: parent

        ListView {
            id: listView
            anchors {
                fill: parent
                topMargin: 20
            }

            clip: true
            boundsBehavior: Flickable.StopAtBounds
            spacing: 10

            delegate: Item {
                x: 15 // Margin
                width: listView.width - 15
                height: 400

                SerialConfig {
                    // anchors.fill: parent
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        bottom: line.top
                    }

                    title: modelData.title
                }

                ShineLine {
                    id: line
                    y: parent.height - height - 10
                    width: listView.width - x
                    visible: index < listView.model.length - 1
                }
            }
        }
    }
}
