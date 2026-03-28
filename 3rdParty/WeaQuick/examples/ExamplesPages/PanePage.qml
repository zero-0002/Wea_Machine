import QtQuick 2.12
import QtQuick.Layouts 1.12

import com.wearily.WeaQuick 1.0 as WeaQuick
// Including ExamplePane
import "../"

ExamplePane {
    id: root

    title: "Pane Components in different levels.\n" + "Use Pane component for panels and etc.\n"
           + "Panes also has default DropShadow which are configurable."

    spacing: 5

    contentItem: Item {
        anchors.fill: parent
        WeaQuick.Pane {
            id: mainPane
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            level: 0
            WeaQuick.Pane {
                anchors.fill: parent
                anchors.margins: 35
                level: 1
                WeaQuick.Pane {
                    anchors.fill: parent
                    anchors.margins: 35
                    level: 2
                    WeaQuick.Pane {
                        anchors.fill: parent
                        anchors.margins: 35
                        level: 3
                        WeaQuick.Pane {
                            anchors.fill: parent
                            anchors.margins: 35
                            level: 4
                            WeaQuick.Pane {
                                anchors.fill: parent
                                anchors.margins: 35
                                level: 5
                                WeaQuick.Pane {
                                    anchors.fill: parent
                                    anchors.margins: 35
                                    level: 6
                                    WeaQuick.Pane {
                                        anchors.fill: parent
                                        anchors.margins: 35
                                        level: 7
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
