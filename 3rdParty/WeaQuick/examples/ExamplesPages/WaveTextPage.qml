import QtQuick 2.12

import com.wearily.WeaQuick 1.0 as WeaQuick
// Including ExamplePane
import "../"

ExamplePane {
    id: root

    title: "WaveText: simple WeaQuick.Label with ShaderEffect"

    spacing: 40

    contentItem: Column {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 20

        Repeater {
            model: wQuick.theme.textColor.length
            delegate: WeaQuick.WaveText {
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Qt.AlignHCenter

                level: index
                // fontLevel: index % arrayTextFont.length
                font {
                    pixelSize: (1.25 + (index * index / (arrayTextColor.length * 3))) * 15
                    italic: index < 4
                }
                text: "Hello WeaQuick"

                // WeaQuick Properties
                frequency: 30 * (index / wQuick.theme.textColor.length)
                amplitude: index / wQuick.theme.textColor.length * 0.01 + 0.001
            }
        }
    }
}
