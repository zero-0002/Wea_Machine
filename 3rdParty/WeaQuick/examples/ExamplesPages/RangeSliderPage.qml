import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12 as Q

import com.wearily.WeaQuick 1.0 as WeaQuick
// Including ExamplePane
import "../"

ExamplePane {
    id: root

    title: "RangeSlider: Customizable handler, no need to implement logics for handler position and..."

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
                    model: rangeSliderHModel // wQuick.theme.sliderHandleColor.length
                    delegate: Column {
                        spacing: 5

                        WeaQuick.Label {
                            text: model.title
                        }

                        WeaQuick.RangeSlider {

                            LayoutMirroring.enabled: model.mirror

                            enabled: model.enabled

                            width: root.sliderLength
                            height: model.height
                            level: index % arrayGrooveColor.length

                            from: model.from
                            to: model.to
                            stepSize: model.stepSize
                            first.value: model.firstValue
                            second.value: model.secondValue

                            thickness: model.thickness

                            handlesVisible: model.handleVisible
                            handlesSize: model.handleSize
                            handlesMotion: model.handleMotion
                            handlesFlat: model.handleFlat
                            handlesShape: model.handleShape

                            spanRectVisible: !model.spanRectInvisible
                            ripplesEnabled: model.rippleEnabled && handleVisible

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

                    WeaQuick.RangeSlider {
                        id: sliderA

                        level: 4
                        width: root.sliderLength

                        masterFirst: sliderB.first
                        masterSecond: sliderB.second
                    }
                }
                // B synced with A
                Column {
                    spacing: 5

                    WeaQuick.Label {
                        text: "B: (synced with A)"
                    }

                    WeaQuick.RangeSlider {
                        id: sliderB

                        level: 5
                        width: root.sliderLength

                        masterFirst: sliderA.first
                        masterSecond: sliderA.second

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
                        text: "Synced with EditBox"
                    }

                    WeaQuick.RangeSlider {
                        id: sliderC

                        width: root.sliderLength

                        masterFirst: editBoxFirst
                        masterSecond: editBoxSecond
                        from: -1.0
                        first.value: -0.5
                        second.value: 0.5

                        Component.onCompleted: {
                            // Request to sync value with editBoxes
                            first.moved();
                            second.moved();
                        }
                    }

                    Row {
                        spacing: 2
                        width: root.sliderLength

                        WeaQuick.EditBox {
                            id: editBoxFirst

                            level: 2
                            width: root.sliderLength / 2
                            height: 27
                            color: "transparent"
                            lineEdit.horizontalAlignment: Qt.AlignLeft

                            master: sliderC.first
                            from: sliderC.from
                            stepSize: 0.05
                        }

                        WeaQuick.EditBox {
                            id: editBoxSecond

                            level: 2
                            width: root.sliderLength / 2
                            height: 27
                            color: "transparent"
                            lineEdit.horizontalAlignment: Qt.AlignRight

                            master: sliderC.second
                            from: sliderC.from
                            stepSize: 0.05
                        }
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

                        WeaQuick.RangeSlider {
                            width: 15
                            height: 250
                            level: index % arrayGrooveColor.length

                            orientation: Qt.Vertical

                            handlesShape: index % 2
                            first.value: index / arrayGrooveColor.length + 1 / arrayGrooveColor.length
                            stepSize: isCenter(index) ? 0.01 : 0.1
                            fromLimit: isCenter(index) ? 0.15 : NaN // Apply Limitation only for center one
                            toLimit: isCenter(index) ? 0.75 : NaN // Apply Limitation only for center one
                        }
                    }
                }
            }
        }
    }

    ListModel {
        id: rangeSliderHModel

        ListElement {
            title: "Level 0"

            mirror: false

            enabled: true
            height: 15

            from: 0.0
            to: 1.0
            firstValue: 0.25
            secondValue: 0.5
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

            from: 0.0
            to: 1.0
            firstValue: 0.25
            secondValue: 0.5
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

            from: 0.0
            to: 1.0
            firstValue: 0.25
            secondValue: 0.5
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

            from: 0.0
            to: 1.0
            firstValue: 0.25
            secondValue: 0.5
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

            from: 0.0
            to: 1.0
            firstValue: 0.25
            secondValue: 0.5
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

            from: 0.0
            to: 1.0
            firstValue: 0.25
            secondValue: 0.5
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

            from: 0.0
            to: 1.0
            firstValue: 0.25
            secondValue: 0.5
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

            from: 0.0
            to: 1.0
            firstValue: 0.5
            secondValue: 0.75
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

            from: 0.0
            to: 1.0
            firstValue: 0.75
            secondValue: 1.0
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

            from: 0.0
            to: 1.0
            firstValue: 0.75
            secondValue: 1.0
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

            from: 0.0
            to: 1.0
            firstValue: 0.25
            secondValue: 0.75
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

            from: 0.0
            to: 1.0
            firstValue: 0.75
            secondValue: 1.0
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

            from: 0.0
            to: 1.0
            firstValue: 0.75
            secondValue: 1.0
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

            from: 0.0
            to: 1.0
            firstValue: 0.25
            secondValue: 0.75
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

            from: 0.0
            to: 1.0
            firstValue: 0.75
            secondValue: 1.0
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
    }

    /** Utils Function **/
    function isCenter(index) {
        return index === Math.floor(wQuick.theme.sliderHandleColor.length / 2);
    }
}
