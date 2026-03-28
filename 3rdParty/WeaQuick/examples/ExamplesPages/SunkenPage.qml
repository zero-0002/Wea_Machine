import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12 as Q
import QtQuick.Extras 1.2 as QE
import com.wearily.WeaQuick 1.0 as WeaQuick
// Including ExamplePane
import "../"

ExamplePane {
    id: root

    title: "Sunken: Supports Inner/Outer Item delegation"

    spacing: 15

    // Inline Component
    component Compact: Column {

        property alias title: label.text

        spacing: 5

        WeaQuick.Label {
            id: label
        }
    }

    contentItem: Grid {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 40
        columns: 4

        Repeater {
            model: wQuick.theme.sunkenOuterColor.length

            delegate: Compact {

                title: "Level %1".arg(index)
                WeaQuick.Sunken {
                    id: sunken
                    level: index
                    radius: width / 3.0 - index
                }
            }
        }

        // Reimplementing Examples

        Compact {
            title: "Background\nDelegate"

            WeaQuick.Sunken {
                id: bgDelegate

                level: 2

                width: 50
                height: 50
                radius: width / 2

                backgroundDelegate: Rectangle {
                    anchors.fill: parent
                    color: "red"
                    radius: bgDelegate.radius
                }
            }
        }

        Compact {
            title: "Outer\nDelegate"

            WeaQuick.Sunken {
                id: outerDelegate

                level: 2

                width: 50
                height: 50
                radius: width / 2
                borderWidth: 2

                outerDelegate: Rectangle {
                    anchors.fill: parent
                    color: "red"
                    radius: outerDelegate.radius
                }
            }
        }

        Compact {
            title: "Inner\nDelegate"

            WeaQuick.Sunken {
                id: innerDelegate

                level: 2

                width: 50
                height: 50
                radius: width / 2

                innerDelegate: Rectangle {
                    anchors.fill: parent
                    color: "red"
                    radius: innerDelegate.radius
                }
            }
        }

        Compact {
            title: "Overlay\nDelegate"

            WeaQuick.Sunken {
                id: overlayDelegate

                level: 2

                width: 50
                height: 50
                radius: width / 2

                overlayDelegate: Rectangle {
                    anchors.fill: parent
                    color: "red"
                    radius: overlayDelegate.radius
                }
            }
        }
    }
}
