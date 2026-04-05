import QtQuick 2.12
import QtQuick.Layouts 1.12
import com.wearily.WeaQuick 1.0 as WeaQuick

BorderRectangle {
    id: root

    property bool manualActive: false

    property int titleSize: 15
    property int fontSize: 13
    property int titleVAlignment: Qt.AlignBottom
    property int titleHAlignment: Qt.AlignLeft

    property int controlHeight: 27

    /** Output Alias **/
    property alias speedXControl: speedXControl
    property alias speedYControl: speedYControl
    property alias submitButton: submitButton

    title: "Speed"
    level: 0

    height: layout.height + 50 // 50 means Spacer

    Column {
        id: layout
        x: 10
        width: parent.width - x * 2
        spacing: 0

        ShineLine {
            width: parent.width
            color: "orange"
        }

        // Spacer
        Item {
            width: 1
            height: 15
        }

        // Servo X
        WeaQuick.Label {
            width: parent.width
            height: controlHeight
            font.pixelSize: root.titleSize
            horizontalAlignment: root.titleHAlignment
            verticalAlignment: root.titleVAlignment
            text: "X-Axis Servo"
        }

        SpeedControl {
            id: speedXControl

            x: 10
            width: parent.width - x * 2
            height: controlHeight
            value: servoXDevice.jogSpeed
        }

        // Spacer
        Item {
            width: 1
            height: 25
        }

        // Servo Y
        WeaQuick.Label {
            width: parent.width
            height: controlHeight
            font.pixelSize: root.titleSize
            horizontalAlignment: root.titleHAlignment
            verticalAlignment: root.titleVAlignment
            text: "Y-Axis Servo"
        }

        SpeedControl {
            id: speedYControl

            x: 10
            width: parent.width - x * 2
            height: controlHeight
        }

        // Spacer
        Item {
            width: 1
            height: 25
        }

        // Perform Button
        WeaQuick.Button {
            id: submitButton
            x: parent.width - width - 10
            height: controlHeight

            enabled: manualActive

            level: 2
            text: "Submit"
            border.width: 1
            onClicked: {
                servoXDevice.pushJogSpeed(speedXControl.value);
            }
        }
    }
}
