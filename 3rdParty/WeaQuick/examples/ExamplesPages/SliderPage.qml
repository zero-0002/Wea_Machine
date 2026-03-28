import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12 as Q

import com.wearily.WeaQuick 1.0 as WeaQuick
// Including ExamplePane
import "../"

ExamplePane {
    id: root

    title: "Slider: Customizable handler, no need to implement logics for handler position and..."

    property real sliderLength: 150 // Slider width/height at different orientation

    spacing: 40

    contentItem: ColumnLayout {
        anchors.fill: parent
        spacing: 0

        /** Horizontal Sliders **/
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            clip: true

            Grid {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10
                columns: 4
                columnSpacing: 15

                Repeater {
                    model: sliderHModel
                    delegate: Column {
                        spacing: 5

                        WeaQuick.Label {
                            text: model.title
                        }

                        WeaQuick.Slider {

                            LayoutMirroring.enabled: model.mirror

                            enabled: model.enabled

                            width: root.sliderLength
                            height: model.height
                            level: index % arrayGrooveColor.length

                            origin: model.origin
                            from: model.from
                            to: model.to
                            value: model.value
                            stepSize: model.stepSize

                            thickness: model.thickness

                            handleVisible: model.handleVisible
                            spanRectVisible: !model.spanRectInvisible
                            rippleEnabled: model.rippleEnabled && handleVisible

                            handleSize: model.handleSize
                            handleMotion: model.handleMotion
                            handleFlat: model.handleFlat
                            handleShape: model.handleShape

                            grooveRadius: model.grooveRadius < 0 ? sliderGroove.width / 2 : model.grooveRadius
                        }
                    }
                }
                /** Advanced Usage **/
                // A synced with B
                Column {
                    spacing: 5

                    WeaQuick.Label {
                        text: "A: (synced with B)"
                    }

                    WeaQuick.Slider {
                        id: sliderA

                        level: 4
                        width: root.sliderLength

                        master: sliderB
                    }
                }
                // B synced with A
                Column {
                    spacing: 5

                    WeaQuick.Label {
                        text: "B: (synced with A)"
                    }

                    WeaQuick.Slider {
                        id: sliderB

                        level: 5
                        width: root.sliderLength

                        master: sliderA

                        /** Also synchronizeFunc can be reimplement **/
                        // synchronizeFunc: function (targetValue) {
                        //     return targetValue * 0.5;
                        // }
                    }
                }
                // Sync with SpinBox
                Column {
                    spacing: 5

                    WeaQuick.Label {
                        text: "Synced with SpinBox"
                    }

                    WeaQuick.Slider {
                        id: sliderC

                        width: root.sliderLength

                        master: spinBox
                        from: -1.0
                        origin: 0.0
                        value: 0.0

                        Component.onCompleted: {
                            // Request to sync value with spinBox
                            valueModified();
                        }
                    }

                    WeaQuick.SpinBox {
                        id: spinBox

                        level: 2
                        width: root.sliderLength
                        height: 27
                        color: "transparent"

                        master: sliderC
                        from: sliderC.from
                        stepSize: 0.05
                    }
                }
            }
        }

        /** Vertical Sliders **/
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            clip: true

            Row {
                anchors.centerIn: parent
                spacing: 45

                Repeater {
                    model: wQuick.theme.sliderHandleColor.length
                    delegate: Row {
                        spacing: 5
                        Item {
                            width: 20
                            height: 20
                            y: 220
                            rotation: -90
                            WeaQuick.Label {
                                anchors.bottom: parent.bottom
                                text: isCenter(index) ? "Level %1 (Limit on 0.25~0.75)".arg(index) : "Level %1".arg(
                                                            index)
                            }
                        }

                        WeaQuick.Slider {
                            width: 15
                            height: 250
                            level: index % arrayGrooveColor.length

                            orientation: Qt.Vertical

                            handleShape: index % 2
                            value: index / arrayGrooveColor.length + 1 / arrayGrooveColor.length
                            stepSize: isCenter(index) ? 0.01 : 0.1
                            origin: isCenter(index) ? (to + from) / 2 : from
                            fromLimit: isCenter(index) ? 0.25 : NaN // Apply Limitation only for center one
                            toLimit: isCenter(index) ? 0.75 : NaN // Apply Limitation only for center one
                        }
                    }
                }
            }
        }
    }

    ListModel {
        id: sliderHModel

        ListElement {
            title: "Level 0"

            mirror: false

            enabled: true
            height: 15

            origin: 0.0
            from: 0.0
            to: 1.0
            value: 0.25
            stepSize: 0.01
            thickness: 4

            handleVisible: true
            handleSize: 12
            handleMotion: true
            handleFlat: false
            handleShape: 1 // 0 == Square, 1 == Circle

            grooveRadius: -1.0 // Negative means use default

            rippleEnabled: true
        }

        ListElement {
            title: "Level 1"

            mirror: false

            enabled: true
            height: 15

            origin: 0.0
            from: 0.0
            to: 1.0
            value: 0.25
            stepSize: 0.01
            thickness: 4

            handleVisible: true
            handleSize: 12
            handleMotion: true
            handleFlat: false
            handleShape: 1 // 0 == Square, 1 == Circle

            grooveRadius: -1.0 // Negative means use default

            rippleEnabled: true
        }

        ListElement {
            title: "Level 2"

            mirror: false

            enabled: true
            height: 15

            origin: 0.0
            from: 0.0
            to: 1.0
            value: 0.25
            stepSize: 0.01
            thickness: 4

            handleVisible: true
            handleSize: 12
            handleMotion: true
            handleFlat: false
            handleShape: 1 // 0 == Square, 1 == Circle

            grooveRadius: -1.0 // Negative means use default

            rippleEnabled: true
        }

        ListElement {
            title: "Level 3"

            mirror: false

            enabled: true
            height: 15

            origin: 0.0
            from: 0.0
            to: 1.0
            value: 0.25
            stepSize: 0.01
            thickness: 4

            handleVisible: true
            handleSize: 12
            handleMotion: true
            handleFlat: false
            handleShape: 1 // 0 == Square, 1 == Circle

            grooveRadius: -1.0 // Negative means use default

            rippleEnabled: true
        }

        ListElement {
            title: "Level 4"

            mirror: false

            enabled: true
            height: 15

            origin: 0.0
            from: 0.0
            to: 1.0
            value: 0.25
            stepSize: 0.01
            thickness: 4

            handleVisible: true
            handleSize: 12
            handleMotion: true
            handleFlat: false
            handleShape: 1 // 0 == Square, 1 == Circle

            grooveRadius: -1.0 // Negative means use default

            rippleEnabled: true
        }

        ListElement {
            title: "Level 5"

            mirror: false

            enabled: true
            height: 15

            origin: 0.0
            from: 0.0
            to: 1.0
            value: 0.25
            stepSize: 0.01
            thickness: 4

            handleVisible: true
            handleSize: 12
            handleMotion: true
            handleFlat: false
            handleShape: 1 // 0 == Square, 1 == Circle

            grooveRadius: -1.0 // Negative means use default

            rippleEnabled: true
        }

        ListElement {
            title: "Level 6"

            mirror: false

            enabled: true
            height: 15

            origin: 0.0
            from: 0.0
            to: 1.0
            value: 0.25
            stepSize: 0.01
            thickness: 4

            handleVisible: true
            handleSize: 12
            handleMotion: true
            handleFlat: false
            handleShape: 1 // 0 == Square, 1 == Circle

            grooveRadius: -1.0 // Negative means use default

            rippleEnabled: true
        }

        ListElement {
            title: "Disabled"

            mirror: false

            enabled: false
            height: 15

            origin: 0.0
            from: 0.0
            to: 1.0
            value: 0.5
            stepSize: 0.01
            thickness: 4

            handleVisible: true
            handleSize: 12
            handleMotion: true
            handleFlat: false
            handleShape: 1 // 0 == Square, 1 == Circle

            grooveRadius: -1.0 // Negative means use default

            rippleEnabled: true
        }

        ListElement {
            title: "Square Handle"

            mirror: false

            enabled: true
            height: 15

            origin: 0.0
            from: 0.0
            to: 1.0
            value: 0.75
            stepSize: 0.01
            thickness: 4

            handleVisible: true
            handleSize: 12
            handleMotion: true
            handleFlat: false
            handleShape: 0 // 0 == Square, 1 == Circle

            grooveRadius: -1.0 // Negative means use default

            rippleEnabled: true
        }

        ListElement {
            title: "No Motion"

            mirror: false

            enabled: true
            height: 15

            origin: 0.0
            from: 0.0
            to: 1.0
            value: 0.75
            stepSize: 0.01
            thickness: 4

            handleVisible: true
            handleSize: 12
            handleMotion: false
            handleFlat: false
            handleShape: 0 // 0 == Square, 1 == Circle

            grooveRadius: -1.0 // Negative means use default

            rippleEnabled: true
        }

        ListElement {
            title: "No Motion/Ripple"

            mirror: false

            enabled: true
            height: 15

            origin: 0.0
            from: 0.0
            to: 1.0
            value: 0.75
            stepSize: 0.01
            thickness: 4

            handleVisible: true
            handleSize: 12
            handleMotion: false
            handleFlat: false
            handleShape: 0 // 0 == Square, 1 == Circle

            grooveRadius: -1.0 // Negative means use default

            rippleEnabled: false
        }

        ListElement {
            title: "Flat Handle"

            mirror: false

            enabled: true
            height: 15

            origin: 0.0
            from: 0.0
            to: 1.0
            value: 0.75
            stepSize: 0.01
            thickness: 4

            handleVisible: true
            handleSize: 12
            handleMotion: true
            handleFlat: true
            handleShape: 1 // 0 == Square, 1 == Circle

            grooveRadius: -1.0 // Negative means use default

            rippleEnabled: true
        }

        ListElement {
            title: "Large Handle"

            mirror: false

            enabled: true
            height: 15

            origin: 0.0
            from: 0.0
            to: 1.0
            value: 0.75
            stepSize: 0.01
            thickness: 4

            handleVisible: true
            handleSize: 16
            handleMotion: true
            handleFlat: false
            handleShape: 1 // 0 == Square, 1 == Circle

            grooveRadius: -1.0 // Negative means use default

            rippleEnabled: true
        }

        ListElement {
            title: "Invisible Handle"

            mirror: false

            enabled: true
            height: 15

            origin: 0.0
            from: 0.0
            to: 1.0
            value: 0.75
            stepSize: 0.01
            thickness: 10 // Makes Groove larger

            handleVisible: false
            handleSize: 12
            handleMotion: true
            handleFlat: false
            handleShape: 1 // 0 == Square, 1 == Circle

            grooveRadius: -1.0 // Negative means use default

            rippleEnabled: true
        }

        ListElement {
            title: "Invisible Span"

            mirror: false

            enabled: true
            height: 15

            origin: 0.0
            from: 0.0
            to: 1.0
            value: 0.75
            stepSize: 0.01
            thickness: 4

            handleVisible: true
            handleSize: 12
            handleMotion: true
            handleFlat: false
            handleShape: 1 // 0 == Square, 1 == Circle

            grooveRadius: -1.0 // Negative means use default

            spanRectInvisible: true

            rippleEnabled: true
        }

        ListElement {
            title: "Mirror"

            mirror: true

            enabled: true
            height: 15

            origin: 0.0
            from: 0.0
            to: 1.0
            value: 0.75
            stepSize: 0.01
            thickness: 4

            handleVisible: true
            handleSize: 12
            handleMotion: true
            handleFlat: false
            handleShape: 1 // 0 == Square, 1 == Circle

            grooveRadius: -1.0 // Negative means use default

            rippleEnabled: true
        }

        ListElement {
            title: "Center Origin"

            mirror: false

            enabled: true
            height: 15

            origin: 0.0
            from: -1.0
            to: 1.0
            value: 0.5
            stepSize: 0.01
            thickness: 4

            handleVisible: true
            handleSize: 12
            handleMotion: true
            handleFlat: false
            handleShape: 1 // 0 == Square, 1 == Circle

            grooveRadius: -1.0 // Negative means use default

            rippleEnabled: true
        }
    }

    /** Utils Function **/
    function isCenter(index) {
        return index === Math.floor(wQuick.theme.sliderHandleColor.length / 2);
    }
}
