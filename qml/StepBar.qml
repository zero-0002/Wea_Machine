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

        // Component {
        //     id: highlight
        //     Rectangle {
        //         width: 180
        //         height: 40
        //         color: "lightsteelblue"
        //         radius: 5
        //         y: listView.currentItem.y
        //         Behavior on y {
        //             SpringAnimation {
        //                 spring: 3
        //                 damping: 0.2
        //             }
        //         }
        //     }
        // }

        ListView {
            id: listView

            anchors {
                fill: parent
                margins: 10
            }

            // highlight: highlight
            // highlightFollowsCurrentItem: false
            focus: true

            clip: true
            currentIndex: -1
            boundsBehavior: Flickable.StopAtBounds
            spacing: 10
            model: stepModel

            delegate: StepItem {
                width: listView.width

                // title: model.title
                title: model.name
                running: stepModel.currentRunning === index
                modelItem: stepModel.steps[index]
                // readyIndicator.active: model.active
                autoDeselectSibling: true
                onSelectedChanged: {
                    if (selected) {
                        listView.currentIndex = index;
                    } else {
                        if (listView.currentIndex === index) {
                            listView.currentIndex = -1;
                        }
                    }
                }
            }

            /** Animation && Transitions **/
            moveDisplaced: Transition {
                NumberAnimation {
                    properties: "x,y"
                    duration: 150
                }
            }

            move: Transition {
                NumberAnimation {
                    properties: "x,y"
                    duration: 150
                }
            }

            removeDisplaced: Transition {
                NumberAnimation {
                    properties: "x,y"
                    duration: 1000
                    easing.type: Easing.InOutElastic
                }
            }

            remove: Transition {
                ParallelAnimation {
                    NumberAnimation {
                        property: "scale"
                        to: 0
                        duration: 1000
                        easing.type: Easing.InBounce
                    }
                }
            }

            /** Objects && Functions **/
            function moveUp() {
                if (listView.currentIndex > 0) {
                    listView.model.move(listView.currentIndex, listView.currentIndex - 1);
                }
            }

            function moveDown() {
                if (listView.currentIndex < listView.count - 1) {
                    listView.model.move(listView.currentIndex, listView.currentIndex + 1);
                }
            }

            function removeCurrent() {
                removeItem(currentIndex);
            }

            function removeItem(index) {
                if (index > listView.count - 1 || index < 0) {
                    return;
                }

                if (index === listView.currentIndex) {
                    listView.currentIndex = -1;
                }

                listView.model.remove(index);
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
        enabled: !stepModel.running
        width: parent.width
        height: 27

        dependentEnabled: listView.currentIndex > -1
        moveUpButton.enabled: dependentEnabled && listView.currentIndex > 0
        moveDownButton.enabled: dependentEnabled && listView.currentIndex < listView.count - 1

        // Slots
        insertButton.onClicked: {
            stepPopup.open();
        }

        moveUpButton.onClicked: {
            listView.moveUp();
        }

        moveDownButton.onClicked: {
            listView.moveDown();
        }

        editButton.onClicked: {
            // TODO: update Modal with currentItem data
            stepPopup.open();
        }

        deleteButton.onClicked: {
            listView.removeCurrent();
        }

        openButton.onPressed: {
            stepModel.clear();
        }
        openButton.onClicked: {
            openFileDialog.open();
        }

        saveButton.onClicked: {
            saveFileDialog.open();
        }
    }

    /** Other Connections **/
    Connections {
        target: openFileDialog
        function onAccepted() {
            stepModel.loadFromJsonFile(openFileDialog.currentFile);
        }
    }

    Connections {
        target: saveFileDialog
        function onAccepted() {
            stepModel.saveToJsonFile(saveFileDialog.currentFile);
        }
    }
}
