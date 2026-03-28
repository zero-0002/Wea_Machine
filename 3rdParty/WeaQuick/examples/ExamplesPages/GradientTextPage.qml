import QtQuick 2.12

import com.wearily.WeaQuick 1.0 as WeaQuick
// Including ExamplePane
import "../"

ExamplePane {
    id: root

    title: "Gradient: simple WeaQuick.Label with ShaderEffect"

    spacing: 40

    contentItem: Column {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 20

        Repeater {
            model: gradientModel
            delegate: WeaQuick.GradientText {
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Qt.AlignHCenter

                level: index
                // fontLevel: index % arrayTextFont.length
                font {
                    pixelSize: (1.25 + (index * index / (arrayTextColor.length * 3))) * 15
                    italic: index < 4
                }
                text: "Hello WeaQuick"

                // GradientText Properties
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: model.stopColor0
                    }
                    GradientStop {
                        position: 1.0
                        color: model.stopColor1
                    }
                    // Add more GradientStop if need
                }
            }
        }
    }

    ListModel {
        id: gradientModel

        ListElement {
            stopColor0: "pink"
            stopColor1: "red"
        }
        ListElement {
            stopColor0: "red"
            stopColor1: "orange"
        }
        ListElement {
            stopColor0: "pink"
            stopColor1: "orange"
        }
        ListElement {
            stopColor0: "yellow"
            stopColor1: "green"
        }
        ListElement {
            stopColor0: "white"
            stopColor1: "yellow"
        }
        ListElement {
            stopColor0: "white"
            stopColor1: "steelblue"
        }
        ListElement {
            stopColor0: "white"
            stopColor1: "cyan"
        }
        ListElement {
            stopColor0: "cyan"
            stopColor1: "steelblue"
        }
        ListElement {
            stopColor0: "cyan"
            stopColor1: "blue"
        }
    }
}
