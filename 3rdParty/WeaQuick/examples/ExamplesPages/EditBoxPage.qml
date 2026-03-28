import QtQuick 2.15
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12 as Q

import com.wearily.WeaQuick 1.0 as WeaQuick
// Including ExamplePane
import "../"

ExamplePane {
    id: root

    property var locales: [Qt.locale("en_EN"), Qt.locale(
            "fa_FA"), Qt.locale("de_DE")]

    title: "EditBox: Base component of Value Input box components"
    spacing: 30

    contentItem: Grid {
        spacing: 25
        anchors.horizontalCenter: parent.horizontalCenter
        Repeater {
            model: editBoxModel
            delegate: Column {
                spacing: 5
                WeaQuick.Label {
                    text: model.title
                }

                WeaQuick.EditBox {
                    level: index % arrayBackgroundColor.length
                    levelLabel: index % arrayBackgroundColor.length

                    enabled: model.enabled
                    width: implicitWidth * model.scale
                    height: implicitHeight * model.scale
                    font.pixelSize: 12 * model.scale
                    color: model.transparent ? "transparent" : color

                    from: model.from
                    value: model.value
                    to: model.to
                    stepSize: model.stepSize
                    decimals: model.decimals

                    suffix: model.suffix
                    wrap: model.wrap
                    locale: model.localeIndex === -1 ? Qt.locale(
                                                           ) : locales[model.localeIndex]

                    /** Monitor **/
                    // onValueChanged: {
                    //     console.warn("ValueChanged: ", value)
                    // }
                }
            }
        }

        /** Advanced Usage **/
        // Group 1
        Column {
            spacing: 5
            WeaQuick.Label {
                text: "A: (synced with B)"
            }

            WeaQuick.EditBox {
                id: editBoxA
                level: 1
                width: implicitWidth
                height: implicitHeight

                master: editBoxB

                from: 0
                to: 1000
                value: 10

                stepSize: 0.1
                decimals: 1
                suffix: " cm"
            }
        }

        Column {
            spacing: 5
            WeaQuick.Label {
                text: "B: (synced with A)"
            }

            WeaQuick.EditBox {
                id: editBoxB
                level: 1

                width: implicitWidth
                height: implicitHeight

                master: editBoxA

                from: 0
                to: 10000
                value: 100
                stepSize: 1
                decimals: 0

                suffix: " mm"
            }
        }

        // Group 2
        Column {
            spacing: 5
            WeaQuick.Label {
                text: "C: (synced with D)"
            }

            WeaQuick.EditBox {
                id: editBoxC
                level: 2
                width: implicitWidth
                height: implicitHeight

                master: editBoxD
                from: 0
                to: 359.999
                value: 180.0

                stepSize: 0.01
                decimals: 3

                suffix: " deg"

                // RadToDeg calculation for synchronizing
                synchronizeFunc: function (targetValue) {
                    return doubleToInt(targetValue * 180.0 / Math.PI)
                }

                Component.onCompleted: {
                    // requesting editBoxD to synchronize when initialized
                    valueModified()
                }
            }
        }

        Column {
            spacing: 5
            WeaQuick.Label {
                text: "D: (synced with C)"
            }

            WeaQuick.EditBox {
                id: editBoxD
                level: 2
                width: implicitWidth
                height: implicitHeight

                master: editBoxC
                from: 0
                to: Math.PI * 2
                stepSize: 0.0001
                decimals: 5

                suffix: " rad"

                // DegToRad calculation for synchronizing
                synchronizeFunc: function (targetValue) {
                    return doubleToInt(targetValue * Math.PI / 180.0)
                }
            }
        }
    }

    /** EditBox Items Model **/
    ListModel {
        id: editBoxModel
        ListElement {
            from: 0
            to: 100
            value: 25
            decimals: 0
            stepSize: 1
            localeIndex: -1
            enabled: true
            suffix: ""
            title: "Level 0"
            wrap: false
            scale: 1.0
        }
        ListElement {
            from: 0
            to: 1.0
            value: 0.25
            decimals: 2
            stepSize: 0.01
            localeIndex: -1
            enabled: true
            suffix: ""
            title: "Level 1"
            wrap: false
            scale: 1.0
        }
        ListElement {
            from: -1000
            to: 1000
            value: 0
            decimals: 0
            stepSize: 10
            localeIndex: -1
            enabled: true
            suffix: ""
            title: "Level 2"
            wrap: false
            scale: 1.0
        }
        ListElement {
            from: -10.0
            to: 10.0
            value: -0.1234
            decimals: 4
            stepSize: 0.0025
            localeIndex: -1
            enabled: true
            suffix: ""
            title: "Level 3"
            wrap: false
            scale: 1.0
        }
        ListElement {
            from: 0
            to: 1000000
            value: 1000
            decimals: 0
            stepSize: 10000
            localeIndex: -1
            enabled: true
            suffix: ""
            title: "Level 4"
            wrap: false
            scale: 1.0
        }
        ListElement {
            from: 0
            to: 1000000
            value: 123456
            decimals: 1
            stepSize: 10000
            localeIndex: -1
            enabled: false
            suffix: ""
            title: "Disabled"
            wrap: false
            scale: 1.0
        }
        ListElement {
            from: 0.0
            to: 359.99
            value: 45.0
            decimals: 2
            stepSize: 0.01
            localeIndex: -1
            enabled: true
            suffix: "° deg"
            title: "Deg suffix"
            wrap: false
            scale: 1.0
        }
        ListElement {
            from: 0
            to: 6.28318530717958647692
            value: 3.14159265358979323846
            decimals: 5
            stepSize: 0.00025
            localeIndex: -1
            enabled: true
            suffix: " rad"
            title: "Rad suffix"
            wrap: false
            scale: 1.0
        }
        ListElement {
            from: 0
            to: 300
            value: 60
            decimals: 0
            stepSize: 2
            localeIndex: -1
            enabled: true
            suffix: " km/h"
            title: "Speed suffix"
            wrap: false
            scale: 1.0
        }
        ListElement {
            from: 0
            to: 50000
            value: 1000
            decimals: 2
            stepSize: 75
            localeIndex: 0
            enabled: true
            suffix: " kg"
            title: "Locale En"
            wrap: false
            scale: 1.0
        }
        ListElement {
            from: 0
            to: 50000
            value: 1000
            decimals: 2
            stepSize: 75
            localeIndex: 1
            enabled: true
            suffix: " kg"
            title: "Locale Fa"
            wrap: false
            scale: 1.0
        }
        ListElement {
            from: 0
            to: 50000
            value: 1000
            decimals: 2
            stepSize: 75
            localeIndex: 2
            enabled: true
            suffix: " kg"
            title: "Locale De"
            wrap: false
            scale: 1.0
        }
        ListElement {
            from: 0
            to: 100
            value: 25
            decimals: 0
            stepSize: 1
            localeIndex: -1
            enabled: true
            suffix: ""
            title: "Large"
            wrap: false
            scale: 1.2
        }
        ListElement {
            from: 0
            to: 100
            value: 25
            decimals: 0
            stepSize: 1
            localeIndex: -1
            enabled: true
            suffix: ""
            title: "Small"
            wrap: false
            scale: 0.9
        }
        ListElement {
            from: 0
            to: 100
            value: 25
            decimals: 3
            stepSize: 0.125
            localeIndex: -1
            enabled: true
            suffix: " %"
            title: "Transparent"
            transparent: true
            wrap: false
            scale: 1.0
        }
        ListElement {
            from: -1.0
            to: 1.0
            value: 0.95
            decimals: 2
            stepSize: 0.05
            localeIndex: -1
            enabled: true
            suffix: ""
            title: "Wrap Inc/Dec"
            wrap: true
            scale: 1.0
        }
    }
}
