import QtQuick 2.12
import QtQuick.Layouts 1.12

import com.wearily.WeaQuick 1.0 as WeaQuick
// Including ExamplePane
import "../"

ExamplePane {
    id: root

    property var locales: [Qt.locale("en_EN"), Qt.locale(
            "fa_FA"), Qt.locale("de_DE")]
    property bool mirror: false

    title: "SpinBox: inherited from EditBox with indicators overridden.\n"
           + "Press 'white-space' Key to make mirror all indicators."
    spacing: 40

    contentItem: Grid {

        spacing: 25
        anchors.horizontalCenter: parent.horizontalCenter

        Repeater {
            model: spinBoxModel
            delegate: Column {
                spacing: 5
                WeaQuick.Label {
                    text: model.title
                }

                WeaQuick.SpinBox {
                    level: index % arrayBackgroundColor.length
                    levelLabel: index % arrayBackgroundColor.length
                    iconLevel: index % arrayTextColor.length

                    /** EditBox Properties **/
                    enabled: model.enabled
                    width: 135 * model.scale
                    height: 28 * model.scale
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

                    /** SpinBox Properties **/
                    mirror: root.mirror ^ model.mirror
                    incText: model.incText === undefined ? incText : model.incText
                    decText: model.decText === undefined ? decText : model.decText
                    iconVisible: model.incText === undefined
                                 && model.decText === undefined
                    incIcon: model.incIcon === undefined ? incIcon : model.incIcon
                    decIcon: model.decIcon === undefined ? decIcon : model.decIcon

                    /** Monitor **/
                    // onValueChanged: {
                    //     console.warn("ValueChanged: ", value)
                    // }
                }
            }
        }
    }

    /** EditBox Items Model **/
    ListModel {
        id: spinBoxModel
        ListElement {
            from: 0
            to: 100
            value: 0
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
            value: 1.0
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
        ListElement {
            from: -1.0
            to: 1.0
            value: 0.95
            decimals: 2
            stepSize: 0.05
            localeIndex: -1
            enabled: true
            suffix: ""
            title: "Other icons"
            wrap: false
            scale: 1.0
            incIcon: "angle-up"
            decIcon: "angle-down"
        }
        ListElement {
            from: 0.0
            to: 1.0
            value: 0.5
            decimals: 2
            stepSize: 0.1
            localeIndex: -1
            enabled: true
            suffix: ""
            title: "Text indicator"
            wrap: false
            scale: 1.0
            incText: "inc"
            decText: "dec"
        }
        ListElement {
            from: 0.0
            to: 1.0
            value: 0.5
            decimals: 2
            stepSize: 0.1
            localeIndex: -1
            enabled: true
            suffix: ""
            title: "Mirror +-"
            wrap: false
            scale: 1.0
            mirror: true
        }
    }

    // Mirror shortcut
    Shortcut {
        sequence: " "
        onActivated: root.mirror = !root.mirror
    }
}
