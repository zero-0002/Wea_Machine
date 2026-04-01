import QtQuick 2.12
import QtQuick.Layouts 1.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Item {
    id: root

    property bool manualActive: false

    property int fontSize: 13
    property int titleSize: 15

    property int controlHeight: 27

    property alias title: titleLabel.text
    property alias titleVAlignment: titleLabel.verticalAlignment
    property alias titleHAlignment: titleLabel.horizontalAlignment
    property alias titleLabel: titleLabel

    /** Outputs Alias **/
    property alias gotoPosXControl: gotoPosXControl
    property alias gotoPosYControl: gotoPosYControl
    property alias submitButton: submitButton

    implicitHeight: layout.height + 15

    ColumnLayout {
        id: layout
        x: 10
        width: parent.width - x * 2

        spacing: 15

        // Title
        WeaQuick.Label {
            id: titleLabel
            Layout.fillWidth: true
            font.pixelSize: 17
            verticalAlignment: Qt.AlignVCenter
            horizontalAlignment: Qt.AlignHCenter
            text: "Go to Position"
        }

        ShineLine {
            Layout.fillWidth: true
            color: "orange"
        }

        // Servo X
        GotoPosControl {
            id: gotoPosXControl
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: 10
            title: "X-Axis Servo:"
            controlHeight: root.controlHeight
            positionSwitch.enabled: manualActive
        }

        // Servo Y
        GotoPosControl {
            id: gotoPosYControl
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: 10
            title: "Y-Axis Servo:"
            controlHeight: root.controlHeight
            positionSwitch.enabled: manualActive
        }

        // Perform Button
        CusDelayButton {
            id: submitButton
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: 10
            height: controlHeight

            enabled: gotoPosXControl.positionActive || gotoPosYControl.positionActive && manualActive

            level: 2
            text: "Go"
        }
    }
}
