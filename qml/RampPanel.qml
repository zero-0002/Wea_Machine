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
    property alias rampXControl: rampXControl
    property alias rampYControl: rampYControl
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
            text: "Acc/Dec"
        }

        ShineLine {
            Layout.fillWidth: true
            color: "orange"
        }

        // Servo X
        WeaQuick.Label {
            Layout.fillWidth: true
            font.pixelSize: root.titleSize
            verticalAlignment: root.titleVAlignment
            text: "X-Axis Servo"
        }

        RampControl {
            id: rampXControl
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: 10
        }

        // Servo Y
        WeaQuick.Label {
            Layout.fillWidth: true
            font.pixelSize: root.titleSize
            verticalAlignment: root.titleVAlignment
            text: "Y-Axis Servo"
        }

        RampControl {
            id: rampYControl

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: 10
        }

        // Perform Button
        WeaQuick.Button {
            id: submitButton
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: 10
            height: controlHeight
            border.width: 1

            enabled: manualActive

            level: 2
            text: "Submit"
        }
    }
}
