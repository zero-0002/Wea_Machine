import QtQuick 2.12
import QtQuick.Layouts 1.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Item {
    id: root

    property int fontSize: 13
    property int titleSize: 15

    property int controlHeight: 27

    property alias title: titleLabel.text
    property alias titleVAlignment: titleLabel.verticalAlignment
    property alias titleHAlignment: titleLabel.horizontalAlignment
    property alias titleLabel: titleLabel

    /** Outputs Alias **/
    property alias manualActive: manualModeControl.enableOther

    property alias servoOnXControl: servoOnXControl
    property alias servoOnYControl: servoOnYControl
    property alias manualModeControl: manualModeControl

    ColumnLayout {
        id: layout
        anchors {
            fill: parent
            margins: 10
        }

        spacing: 15

        // Title
        WeaQuick.Label {
            id: titleLabel
            Layout.fillWidth: true
            font.pixelSize: 17
            verticalAlignment: Qt.AlignVCenter
            horizontalAlignment: Qt.AlignHCenter
            text: "Axis Control"
        }

        ShineLine {
            Layout.fillWidth: true
            color: "orange"
        }

        // Manual Mode
        HomingControl {
            id: manualModeControl

            property bool enableOther: homingSwitch.checked

            Layout.fillWidth: true
            Layout.leftMargin: 10
            title: "Manual mode:"

            homingSwitch.checkable: false
            homingSwitch.checked: loginPopup.success

            homingSwitch.onPressed: {
                // Opening Login Modal
                if (!loginPopup.success) {
                    loginPopup.open();
                }
            }
        }

        // Servo X
        HomingControl {
            id: servoOnXControl
            Layout.fillWidth: true
            Layout.leftMargin: 10
            title: "X-Axis Servo ON:"
            homingSwitch.enabled: manualModeControl.enableOther

            homingSwitch.checkable: false
            homingSwitch.checked: servoXDevice.di1
            homingSwitch.onPressed: {
                servoXDevice.pushDi1(!homingSwitch.checked);
            }
        }

        // Servo Y
        HomingControl {
            id: servoOnYControl
            Layout.fillWidth: true
            Layout.leftMargin: 10
            title: "Y-Axis Servo ON:"
            homingSwitch.enabled: manualModeControl.enableOther

            homingSwitch.checkable: false
            homingSwitch.checked: servoYDevice.di1
            homingSwitch.onPressed: {
                servoYDevice.pushDi1(!homingSwitch.checked);
            }
        }

        Joystick {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10

            joystickLeft.enabled: servoOnXControl.homingActive
            joystickRight.enabled: servoOnXControl.homingActive
            joystickTop.enabled: servoOnYControl.homingActive
            joystickDown.enabled: servoOnYControl.homingActive

            joystickTopLeft.enabled: servoOnXControl.homingActive && servoOnYControl.homingActive
            joystickTopRight.enabled: servoOnXControl.homingActive && servoOnYControl.homingActive
            joystickDownLeft.enabled: servoOnXControl.homingActive && servoOnYControl.homingActive
            joystickDownRight.enabled: servoOnXControl.homingActive && servoOnYControl.homingActive

            /** Slots **/
            // X Axs
            joystickLeft.onPressed: {
                // Forward
                servoXDevice.pushDi9(true);
            }
            joystickLeft.onReleased: {
                // Forward
                servoXDevice.pushDi9(false);
            }
            joystickRight.onPressed: {
                // Reverse
                servoXDevice.pushDi10(true);
            }
            joystickRight.onReleased: {
                // Reverse
                servoXDevice.pushDi10(false);
            }

            // Y Axis
            joystickTop.onPressed: {
                // Forward
                servoYDevice.pushDi9(true);
            }
            joystickTop.onReleased: {
                // Forward
                servoYDevice.pushDi9(false);
            }
            joystickDown.onPressed: {
                // Reverse
                servoYDevice.pushDi10(true);
            }
            joystickDown.onReleased: {
                // Reverse
                servoYDevice.pushDi10(false);
            }

            // Both Axes
            joystickTopLeft.onPressed: {
                // Forward
                servoXDevice.pushDi9(true);
                servoYDevice.pushDi9(true);
            }
            joystickTopLeft.onReleased: {
                // Forward
                servoXDevice.pushDi9(false);
                servoYDevice.pushDi9(false);
            }
            joystickTopRight.onPressed: {
                // Reverse
                servoXDevice.pushDi10(true);
                // Forward
                servoYDevice.pushDi9(true);
            }
            joystickTopRight.onReleased: {
                // Reverse
                servoXDevice.pushDi10(false);
                // Forward
                servoYDevice.pushDi9(false);
            }

            joystickDownLeft.onPressed: {
                // Forward
                servoXDevice.pushDi9(true);
                // Reverse
                servoYDevice.pushDi10(true);
            }
            joystickDownLeft.onReleased: {
                // Forward
                servoXDevice.pushDi9(false);
                // Reverse
                servoYDevice.pushDi10(false);
            }
            joystickDownRight.onPressed: {
                // Reverse
                servoXDevice.pushDi10(true);
                servoYDevice.pushDi10(true);
            }
            joystickDownRight.onReleased: {
                // Reverse
                servoXDevice.pushDi10(false);
                servoYDevice.pushDi10(false);
            }
        }
    }
}
