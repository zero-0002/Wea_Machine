import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Item {
    id: root

    implicitHeight: 35

    property alias title: appTitle.text

    property alias appTitle: appTitle
    property alias pageButtonsItem: pageButtonsItem

    signal pageChanged(var index)
    signal openPopUp(var index)

    // Left
    WeaQuick.WaveText {
        id: appTitle
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 10
        }

        font {
            pixelSize: 16
            italic: true
        }

        text: "wearily"
        frequency: 95
        amplitude: 0.01
    }

    // H-Center
    PageButtons {
        id: pageButtonsItem
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }

        pageButtons: [
            {
                iconName: "house"
            },
            {
                iconName: "gamepad-modern"
            },
            {
                iconName: "gear"
            },
        ]

        popUpButtons: [
            {
                iconName: "plug"
            },
        ]

        onCurrentIndexChanged: {
            pageChanged(currentIndex);
        }

        onPopUpRequest: {
            openPopUp(index);
        }
    }

    // Right
    AppStatusIndicators {
        id: right
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: 10
        }

        model: [
            {
                name: "Alarms",
                iconName: "warning",
                levelActive: 1 // yellow
                             ,
                active: _alarmModel.count > 0,
                blinking: true
            },
            // PLC
            {
                name: "PLC Communication State",
                iconName: "plug-circle-check",
                levelActive: 0 // red
                             ,
                active: true,
                blinking: false
            },
            // Servo
            {
                // iconName: "plug-circle-exclamation",
                name: "Servo Communication State",
                iconName: "plug-circle-check",
                levelActive: servoModbusCom.serialConn.connected ? 2 : 0,
                active: true,
                blinking: false
            }
            // {
            //     iconName: "plug-circle-xmark",
            //     levelActive: 2 // green
            //                  ,
            //     active: true,
            //     blinking: false
            // },
            ,
        ]
    }
}
