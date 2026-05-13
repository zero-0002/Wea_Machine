import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Column {
    id: root

    property int fontSize: 15
    property int titleVAlignment: Qt.AlignVCenter
    property int titleHAlignment: Qt.AlignHCenter

    property int controlLevel: 2
    property int controlWidth: 150
    property int controlHeight: 33

    property double positionValue: 0.0
    property double speedValue: 200.0
    property double accValue: 200
    property double decValue: 200

    property alias positionActiveSwitch: swPosActive
    property alias servoOnSwitch: swServoOn
    property alias homingSwitch: swHoming
    property alias positionEditBox: editBoxPos
    property alias speedEditBox: editBoxSpd
    property alias accelerationEditBox: editBoxAcc
    property alias decelerationEditBox: editBoxDec

    spacing: 10

    // Position Active
    RowCompact {
        title: "Positioning Active: "

        WeaQuick.Switch {
            id: swPosActive
            anchors {
                right: parent.right
                rightMargin: parent.rightPadding
            }

            indicatorWidth: 45
            indicatorHeight: 22
            handleShape: WeaQuick.Handle.HandleShape.Circular
            handleSize: 16
            checked: true
        }
    }

    // ServoON
    RowCompact {
        title: "Servo ON: "

        WeaQuick.Switch {
            id: swServoOn
            anchors {
                right: parent.right
                rightMargin: parent.rightPadding
            }

            enabled: swPosActive.checked
            indicatorWidth: 45
            indicatorHeight: 22
            handleShape: WeaQuick.Handle.HandleShape.Circular
            handleSize: 16
            checked: true
        }
    }

    // Homing
    RowCompact {
        title: "Homing: "

        WeaQuick.Switch {
            id: swHoming
            anchors {
                right: parent.right
                rightMargin: parent.rightPadding
            }

            enabled: swServoOn.checked && swServoOn.enabled
            indicatorWidth: 45
            indicatorHeight: 22
            handleShape: WeaQuick.Handle.HandleShape.Circular
            handleSize: 16
        }
    }

    // Position
    RowCompact {
        title: "Position: "

        PosEditBox {
            id: editBoxPos
            anchors {
                right: parent.right
                rightMargin: parent.rightPadding
            }

            enabled: !swHoming.checked && swHoming.enabled
            level: controlLevel
            width: controlWidth
            height: controlHeight
        }
    }

    // Speed
    RowCompact {
        title: "Speed: "

        SpdEditBox {
            id: editBoxSpd
            anchors {
                right: parent.right
                rightMargin: parent.rightPadding
            }

            enabled: !swHoming.checked && swHoming.enabled
            level: controlLevel
            width: controlWidth
            height: controlHeight
        }
    }

    // Acceleration
    RowCompact {
        title: "Acceleration: "

        RampEditBox {
            id: editBoxAcc
            anchors {
                right: parent.right
                rightMargin: parent.rightPadding
            }

            enabled: !swHoming.checked && swHoming.enabled
            level: controlLevel
            width: controlWidth
            height: controlHeight
        }
    }

    // Deceleration
    RowCompact {
        title: "Deceleration: "

        RampEditBox {
            id: editBoxDec
            anchors {
                right: parent.right
                rightMargin: parent.rightPadding
            }

            enabled: !swHoming.checked && swHoming.enabled
            level: controlLevel
            width: controlWidth
            height: controlHeight
        }
    }

    /** Slots **/
    onPositionValueChanged: positionEditBox.spinBox.value = positionEditBox.doubleToInt(positionValue)
    onSpeedValueChanged: speedEditBox.spinBox.value = speedEditBox.doubleToInt(speedValue)
    onAccValueChanged: accelerationEditBox.spinBox.value = accelerationEditBox.doubleToInt(accValue)
    onDecValueChanged: decelerationEditBox.spinBox.value = decelerationEditBox.doubleToInt(decValue)

    // Object & Inline-Components
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
}
