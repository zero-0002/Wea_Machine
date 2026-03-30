import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Item {
    id: root

    property int titleSize: 17
    property int fontSize: 13
    property int titleVAlignment: Qt.AlignVCenter
    property int titleHAlignment: Qt.AlignLeft

    property int controlLevel: 2
    property int controlWidth: 107
    property int controlHeight: 30

    property color shineLineColor: "white"

    property alias layout: layout

    implicitHeight: layout.height

    Column {
        id: layout
        y: 5
        width: parent.width
        spacing: 10

        // Positioning
        Title {
            title: "Positioning"
        }

        Grid {
            x: 5
            spacing: 7
            columns: 2
            RowCompact {
                title: "X-Pos:"

                PosEditBox {
                    id: xPos
                    editable: false
                    wheelEnabled: false
                    width: controlWidth
                    height: controlHeight
                    border.width: 0
                    color: "transparent"
                    value: 1000
                }
            }

            RowCompact {
                title: "X-Speed:"

                SpdEditBox {
                    id: xSpeed
                    editable: false
                    wheelEnabled: false
                    width: controlWidth
                    height: controlHeight
                    border.width: 0
                    color: "transparent"
                    value: 10000
                }
            }

            RowCompact {
                title: "Y-Pos:"

                PosEditBox {
                    id: yPos
                    editable: false
                    wheelEnabled: false
                    width: controlWidth
                    height: controlHeight
                    border.width: 0
                    color: "transparent"
                    value: xPos.value
                }
            }

            RowCompact {
                title: "Y-Speed:"

                SpdEditBox {
                    id: ySpeed
                    editable: false
                    wheelEnabled: false
                    width: controlWidth
                    height: controlHeight
                    border.width: 0
                    color: "transparent"
                    value: 10000
                }
            }
        }

        // Coil To be Set
        ShineLine {
            width: parent.width
            color: shineLineColor
        }

        Title {
            title: "Coils to Be SET"
        }

        StepCoilsGrid {
            id: stepSetCoilsGrid
            x: 5
            width: parent.width
            model: 11
            activeIndicators: true
        }

        // Coil To be Reset
        ShineLine {
            width: parent.width
            color: shineLineColor
        }

        Title {
            title: "Coils to Be RST"
        }

        StepCoilsGrid {
            id: stepRstCoilsGrid
            x: 5
            width: parent.width
            model: 12
        }

        // Delay
        ShineLine {
            width: parent.width
            color: shineLineColor
        }

        Title {
            title: "Delay"
        }

        Row {
            x: 5
            spacing: parent.width / 2 - controlWidth / 2 - x
            DelayEditBox {
                id: delayTargetEditBox

                width: controlWidth
                height: controlHeight

                color: "transparent"
                editable: false
                wheelEnabled: false

                value: 5.0
            }
            DelayEditBox {
                id: delayCurrentEditBox

                width: controlWidth
                height: controlHeight

                color: "transparent"
                editable: false
                wheelEnabled: false
            }
        }
    }

    // Objects & inline-components
    component Title: Item {

        property alias title: titleLabel.text
        property alias titleVAlignment: titleLabel.verticalAlignment
        property alias titleHAlignment: titleLabel.horizontalAlignment
        property alias titleLabel: titleLabel

        width: parent.width
        height: titleLabel.height

        WeaQuick.Label {
            id: titleLabel
            width: parent.width
            height: paintedHeight
            font.pixelSize: root.titleSize
            verticalAlignment: root.titleVAlignment
            horizontalAlignment: root.titleHAlignment
        }
    }

    component RowCompact: Row {

        property int padding: 0
        property int leftPadding: padding
        property int rightPadding: padding

        property alias title: titleLabelRow.text
        property alias titleVAlignment: titleLabelRow.verticalAlignment
        property alias titleHAlignment: titleLabelRow.horizontalAlignment
        property alias titleLabel: titleLabelRow

        spacing: 0

        WeaQuick.Label {
            id: titleLabelRow

            height: controlHeight
            font.pixelSize: root.fontSize
            verticalAlignment: root.titleVAlignment
            horizontalAlignment: Qt.AlignLeft
        }
    }
}
