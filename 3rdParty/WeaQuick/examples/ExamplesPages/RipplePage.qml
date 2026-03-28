import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12 as Q

import com.wearily.WeaQuick 1.0 as WeaQuick
// Including ExamplePane
import "../"

ExamplePane {
    id: root

    title: "Ripple: makes an simple effect for sourceItem while at hovered and pressed"

    spacing: 40

    contentItem: Grid {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 45
        columns: 3

        // Circular Ripple
        Column {
            spacing: 5

            WeaQuick.Label {
                text: "Circular Ripple\nsourceItem: Rectangle"
            }

            Item {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 15
                height: 15
                // Simple Item
                Rectangle {
                    id: sourceItem
                    anchors.centerIn: parent
                    width: 10
                    height: 10
                    color: "cyan"

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                    }
                }

                WeaQuick.CircularRipple {
                    active: mouseArea.containsMouse || mouseArea.containsPress
                    hasFocused: mouseArea.containsPress
                    targetColor: sourceItem.color
                }
            }
        }

        // Circular Ripple
        Column {
            spacing: 5

            WeaQuick.Label {
                text: "Circular Ripple\nsourceItem: WeaQuick.IconFont"
            }

            Item {
                anchors.horizontalCenter: parent.horizontalCenter
                width: iconFont.implicitWidth
                height: iconFont.implicitHeight

                WeaQuick.IconFont {
                    id: iconFont
                    anchors.centerIn: parent
                    pixelSize: 20
                    name: "apple-whole"
                    color: "green"

                    MouseArea {
                        id: mouseAreaIconFont
                        anchors.fill: parent
                        hoverEnabled: true
                    }
                }

                WeaQuick.CircularRipple {
                    width: iconFont.implicitWidth * 1.5
                    height: iconFont.implicitHeight * 1.5
                    active: mouseAreaIconFont.containsMouse || mouseAreaIconFont.containsPress
                    hasFocused: mouseAreaIconFont.containsPress
                    targetColor: iconFont.color
                }
            }
        }
    }
}
