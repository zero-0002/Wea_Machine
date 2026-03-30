import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Item {
    id: root

    property int level: 1
    property int padding: 10

    property alias model: listView.model
    property alias stepViewPane: stepViewPane
    property alias stepView: listView
    property alias stepTools: stepTools

    WeaQuick.Pane {
        // Item {
        id: stepViewPane
        anchors {
            top: parent.top
            right: parent.right
            bottom: stepTools.top
            margins: padding
        }
        width: parent.width

        level: root.level
        // flat: false

        ListView {
            id: listView
            anchors {
                fill: parent
                margins: 10
            }

            clip: true
            boundsBehavior: Flickable.StopAtBounds
            spacing: 10
            model: 5

            delegate: StepItem {
                width: listView.width
                height: 300
            }
        }
    }

    // Model Tools (Save/Insert/Open/Delete/Edit)
    StepTools {
        id: stepTools
        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: padding
        }
        width: parent.width
        height: 27

        // Slots
        insertButton.onClicked: {
            stepPopup.open();
            console.log("Clicked");
        }
    }

    // Config Popup
    StepPopup {
        id: stepPopup
    }
}
