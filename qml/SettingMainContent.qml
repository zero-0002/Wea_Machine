import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

WeaQuick.Pane {
    id: root

    property int currentIndex: 0
    property var settingPages: [plcInputSettingPage, plcOutputSettingPage, servoXSettingPage, servoYSettingPage]

    Component {
        id: plcInputSettingPage
        SettingPLCInputPage {}
    }

    Component {
        id: plcOutputSettingPage
        SettingPLCOuputPage {}
    }
    Component {
        id: servoXSettingPage
        Item {
            WeaQuick.Label {
                anchors.centerIn: parent
                font.pixelSize: 25
                text: "X-Axis Servo Setting"
            }
        }
    }
    Component {
        id: servoYSettingPage
        Item {
            WeaQuick.Label {
                anchors.centerIn: parent
                font.pixelSize: 25
                text: "Y-Axis Servo Setting"
            }
        }
    }

    Loader {
        anchors.fill: parent
        sourceComponent: settingPages[currentIndex]
    }
}
