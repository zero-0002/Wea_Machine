import QtQuick 2.12
import Qt.labs.settings 1.1
import com.wearily.WeaQuick 1.0 as WeaQuick

Column {
    id: root

    property int currentIndex: 0
    property alias model: repeater.model

    spacing: 5

    Repeater {
        id: repeater
        model: ["PLC Digital Inputs", "PLC Digital Outputs", "X-Axis Servo", "Y-Axis Servo",]

        delegate: WeaQuick.Button {
            width: parent.width
            height: 35

            arraySelectedBackgroundColor: WeaQuick.WeaQuickUtils.darker(Array(6).fill("orange"), 1.35)
            level: 5
            flat: checked
            border.width: 1
            text: modelData
            font.pixelSize: 13
            locked: true // lock other states when is checked
            checked: currentIndex == index
            onClicked: currentIndex = index
        }
    }

    // AppSetting
    Settings {
        property alias currentSettingPageIndex: root.currentIndex
    }
}
