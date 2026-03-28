import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12 as Q

import com.wearily.WeaQuick 1.0 as WeaQuick
// Including ExamplePane
import "../"

ExamplePane {
    id: root

    title: "Swicth"

    spacing: 15

    // Inline Component
    component CompactSwitch: Column {

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
            model: wQuick.theme.switchUncheckedBackgroundColor.length

            delegate: CompactSwitch {

                title: "Level %1".arg(index)
                WeaQuick.Switch {
                    level: index % arrayCheckedBackgroundColor.length

                    checked: true
                    handleShape: index % 2
                }
            }
        }

        // Qt Switch
        CompactSwitch {
            title: "Qt Default"

            Q.Switch {
                id: qtDefault
                height: 30
            }
        }

        /** Special Configs **/

        CompactSwitch {
            title: "Disabled"

            WeaQuick.Switch {
                enabled: false
            }
        }

        CompactSwitch {
            title: "Motion"

            WeaQuick.Switch {
                handleShape: WeaQuick.Handle.HandleShape.Circular
                handleMotion: true
                checked: true
            }
        }

        CompactSwitch {
            title: "No Ripple"

            WeaQuick.Switch {
                handleShape: WeaQuick.Handle.HandleShape.Circular
                rippleEnabled: false
            }
        }

        CompactSwitch {
            title: "Flat"

            WeaQuick.Switch {
                handleShape: WeaQuick.Handle.HandleShape.Circular
                handleFlat: true
                checked: true
            }
        }

        CompactSwitch {
            title: "Handle Level"

            WeaQuick.Switch {
                level: 4
                levelHandle: 3
                checked: true
            }
        }

        CompactSwitch {
            title: "Larger"

            WeaQuick.Switch {
                level: 3
                indicatorWidth: 60
                indicatorHeight: 30
            }
        }

        CompactSwitch {
            title: "Smaller"

            WeaQuick.Switch {
                level: 1
                indicatorWidth: 38
                indicatorHeight: 17
                checked: true
            }
        }

        CompactSwitch {
            title: "Larger Handle"

            WeaQuick.Switch {
                handleShape: WeaQuick.Handle.HandleShape.Circular
                handleSize: 27
            }
        }

        CompactSwitch {
            title: "Smaller Handle"

            WeaQuick.Switch {
                level: 1
                handleShape: WeaQuick.Handle.HandleShape.Circular
                handleSize: 11
                checked: true
            }
        }

        CompactSwitch {
            title: "Text Visible"

            WeaQuick.Switch {
                textVisible: true
            }
        }

        CompactSwitch {
            title: "Custom Text"

            WeaQuick.Switch {
                level: 4
                textVisible: true
                uncheckedText: "OFF"
                checkedText: "ON"
                checked: true
            }
        }

        CompactSwitch {
            title: "Custom Handle"

            // NOTE: no need to implement x/y position for custom handle
            WeaQuick.Switch {
                id: swCusHandle

                level: 3
                checked: true

                // Making Custom Handle pretty
                handleShape: WeaQuick.Handle.HandleShape.Circular
                handleMotion: true
                handleBigScale: 1.75
                // Binding handle.scale (with transition) to its parent (because handle is invisible but inner logics are active)
                handleItem.scale: handleScale

                handleVisible: false // REQUIRED for reimplementing handleDelegate
                handleDelegate: WeaQuick.IconFont {
                    pixelSize: swCusHandle.handleSize
                    name: "alien"
                }
            }
        }

        CompactSwitch {
            title: "Mirror"

            WeaQuick.Switch {
                LayoutMirroring.enabled: true
                handleShape: WeaQuick.Handle.HandleShape.Circular
            }
        }

        CompactSwitch {
            spacing: 20

            title: "Vertical"

            WeaQuick.Switch {
                rotation: -90

                handleShape: WeaQuick.Handle.HandleShape.Circular
            }
        }

        CompactSwitch {
            spacing: 20

            title: "V Mirror"

            WeaQuick.Switch {
                LayoutMirroring.enabled: true

                rotation: -90
                handleShape: WeaQuick.Handle.HandleShape.Circular
            }
        }
    }
}
