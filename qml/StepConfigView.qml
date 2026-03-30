import QtQuick 2.12
import QtQuick.Controls 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Flickable {
    id: root

    property int titleSize: 17
    property int fontSize: 15
    property int titleVAlignment: Qt.AlignVCenter
    property int titleHAlignment: Qt.AlignHCenter

    property int controlLevel: 2
    property int controlWidth: 150
    property int controlHeight: 33

    property alias spacing: layout.spacing

    clip: true
    contentWidth: width
    contentHeight: layout.height
    boundsBehavior: Flickable.StopAtBounds

    Column {
        id: layout
        width: parent.width
        spacing: 20

        // Step Name
        WeaQuick.LineEdit {
            id: stepName

            width: controlWidth
            height: controlHeight
            level: controlLevel
            font.pixelSize: fontSize - 1
            flat: false

            placeholderText: "Step Name"
        }

        // Condition To Start
        Title {
            title: "Condition to Start"
        }

        RowCompact {
            title: "Bitwise Condition: "
            CusComboBox {
                id: conditionComboBox
                anchors {
                    right: parent.right
                    rightMargin: parent.rightPadding
                }
                width: controlWidth
                model: ["AND", "OR", "XOR"]
            }
        }

        IOsCheckBox {
            id: gridIoCheckBox
            width: parent.width
            model: 28
        }

        // X-Axis Servo
        Title {
            title: "X-Axis Servo"
        }

        ServoStep {
            id: servoXStep

            width: parent.width
            spacing: layout.spacing

            fontSize: root.fontSize
            titleVAlignment: root.titleVAlignment
            titleHAlignment: root.titleHAlignment
            controlLevel: root.controlLevel
            controlWidth: root.controlWidth
            controlHeight: root.controlHeight
        }

        // X-Axis Servo
        Title {
            title: "Y-Axis Servo"
        }

        ServoStep {
            id: servoYStep

            width: parent.width
            spacing: layout.spacing

            fontSize: root.fontSize
            titleVAlignment: root.titleVAlignment
            titleHAlignment: root.titleHAlignment
            controlLevel: root.controlLevel
            controlWidth: root.controlWidth
            controlHeight: root.controlHeight
        }

        // Coils
        Title {
            title: "Coils Set/Reset"
        }

        CoilsStep {
            id: coilsStep

            width: parent.width
            spacing: layout.spacing

            fontSize: root.fontSize
            titleVAlignment: root.titleVAlignment
            titleHAlignment: root.titleHAlignment
            controlLevel: root.controlLevel
            controlWidth: root.controlWidth
            controlHeight: root.controlHeight

            model: [
                {
                    name: "Blowpin"
                },
                {
                    name: "Hydraulic UP"
                },
                {
                    name: "Hydraulic DOWN"
                },
                {
                    name: "Y3"
                },
                {
                    name: "Y4"
                },
                {
                    name: "Y5"
                },
                {
                    name: "Y6"
                },
                {
                    name: "Y7"
                },
                {
                    name: "Y8"
                },
                {
                    name: "Y9"
                },
                {
                    name: "Y10"
                },
                {
                    name: "Y11"
                },
            ]
        }

        // Spacer
        ShineLine {
            width: parent.width
            color: "orange"
        }

        // Delay
        RowCompact {
            title: "Wait for next step:"
            DelayEditBox {
                id: delayEditBox
                anchors {
                    right: parent.right
                    rightMargin: parent.rightPadding
                }
                width: controlWidth
                height: controlHeight
                level: controlLevel
            }
        }

        // Spacer
        Spacer {
            height: 2
        }
    }

    // Objects & inline-components
    component Title: Column {

        property alias title: titleLabel.text
        property alias titleVAlignment: titleLabel.verticalAlignment
        property alias titleHAlignment: titleLabel.horizontalAlignment
        property alias titleLabel: titleLabel

        property alias shineColor: shineLine.color
        property alias shineWidth: shineLine.width
        property alias shineLine: shineLine

        width: parent.width
        height: controlHeight
        spacing: 7

        WeaQuick.Label {
            id: titleLabel
            width: parent.width
            height: parent.height
            font.pixelSize: root.titleSize
            verticalAlignment: root.titleVAlignment
            horizontalAlignment: root.titleHAlignment
        }

        ShineLine {
            id: shineLine
            width: parent.width
            color: "orange"
        }
    }

    component RowCompact: Item {

        property int padding: 0
        property int leftPadding: padding
        property int rightPadding: padding

        property alias title: titleLabelRow.text
        property alias titleVAlignment: titleLabelRow.verticalAlignment
        property alias titleHAlignment: titleLabelRow.horizontalAlignment
        property alias titleLabel: titleLabelRow

        width: parent.width
        height: controlHeight

        WeaQuick.Label {
            id: titleLabelRow
            // x: leftPadding
            anchors {
                left: parent.left
                leftMargin: parent.leftPadding
            }

            width: parent.width
            height: parent.height
            font.pixelSize: root.fontSize
            verticalAlignment: root.titleVAlignment
            horizontalAlignment: Qt.AlignLeft
        }
    }

    component Spacer: Item {
        width: 1
        height: 1
    }
}
