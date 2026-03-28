import QtQuick 2.12
import QtQuick.Layouts 1.12

import com.wearily.WeaQuick 1.0 as WeaQuick
// Including ExamplePane
import "../"

ExamplePane {
    id: root

    title: "Simple CheckBox component which has default colors and common properties"
    spacing: 40

    contentItem: Grid {
        anchors {
            horizontalCenter: parent.horizontalCenter
            margins: 50
        }

        rowSpacing: 20
        columnSpacing: 35

        columns: 4

        // Simple Types
        Repeater {
            model: wQuick.theme.checkBoxBackgroundColor.length
            WeaQuick.CheckBox {
                level: index
                levelLabel: level % arrayTextColor.length
                text: "level %1".arg(level)
                checked: true
            }
        }

        // More interactives
        WeaQuick.CheckBox {
            text: "unchecked"
            textAtToggled: "checked"
        }

        // Custom Color
        WeaQuick.CheckBox {
            color: "purple"
        }

        // Default
        WeaQuick.CheckBox {
            defaultType: true
            text: "Default Qt"
        }

        // Gradient Indicator
        WeaQuick.CheckBox {
            checked: true
            text: "Gradient"
            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: "red"
                }
                GradientStop {
                    position: 0.33
                    color: "yellow"
                }
                GradientStop {
                    position: 1.0
                    color: "green"
                }
            }
        }

        // tristate checkBox
        WeaQuick.CheckBox {
            checked: true
            tristate: true
            text: "tristate"

            gradient: Gradient {
                GradientStop {
                    color: "white"
                    position: 0.0
                }
                GradientStop {
                    color: "steelblue"
                    position: 1.0
                }
            }
        }

        // Indicator size
        WeaQuick.CheckBox {
            checked: true
            text: "Bigger"

            gradient: Gradient {
                GradientStop {
                    color: "white"
                    position: 0.0
                }
                GradientStop {
                    color: "orange"
                    position: 1.0
                }
            }

            indicator.width: 25
            indicator.height: 25
        }

        // Indicator size
        WeaQuick.CheckBox {
            checked: true
            text: "Smaller"

            gradient: Gradient {
                GradientStop {
                    color: "white"
                    position: 0.0
                }
                GradientStop {
                    color: "red"
                    position: 1.0
                }
            }

            indicator.width: 15
            indicator.height: 15
        }

        // Font size
        WeaQuick.CheckBox {
            checked: true
            text: "Bigger text"
            font.pixelSize: 15

            gradient: Gradient {
                GradientStop {
                    color: "pink"
                    position: 0.0
                }
                GradientStop {
                    color: "red"
                    position: 1.0
                }
            }
        }

        // Font size
        WeaQuick.CheckBox {
            checked: true
            text: "Smaller text"
            font.pixelSize: 9

            gradient: Gradient {
                GradientStop {
                    color: "red"
                    position: 0.0
                }
                GradientStop {
                    color: "white"
                    position: 1.0
                }
            }
        }

        // Disabled
        WeaQuick.CheckBox {
            checked: true
            text: "Disabled"

            enabled: false

            gradient: Gradient {
                GradientStop {
                    color: "red"
                    position: 0.0
                }
                GradientStop {
                    color: "white"
                    position: 1.0
                }
            }
        }
    }
}
