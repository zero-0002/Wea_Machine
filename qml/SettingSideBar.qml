import QtQuick 2.12
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

            level: 2
            // flat: false
            border.width: 1
            text: modelData
            font.pixelSize: 13
            locked: true // lock other states when is checked
            checked: currentIndex == index
            onClicked: currentIndex = index
        }
    }
}
