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

    property alias homingSwitch: swHoming
    property alias positionEditBox: editBoxPos
    property alias speedEditBox: editBoxSpd
    property alias accelerationEditBox: editBoxAcc
    property alias decelerationEditBox: editBoxDec

    spacing: 10

    // Homing
    RowCompact {
        title: "Homing: "

        WeaQuick.Switch {
            id: swHoming
            anchors {
                right: parent.right
                rightMargin: parent.rightPadding
            }

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

            enabled: !swHoming.checked
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

            enabled: !swHoming.checked
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

            enabled: !swHoming.checked
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

            enabled: !swHoming.checked
            level: controlLevel
            width: controlWidth
            height: controlHeight
        }
    }

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
