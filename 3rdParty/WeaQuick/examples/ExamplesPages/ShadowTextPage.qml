import QtQuick 2.12

import com.wearily.WeaQuick 1.0 as WeaQuick
// Including ExamplePane
import "../"

ExamplePane {
    id: root

    title: "ShadowText: simple WeaQuick.Label with ShaderEffect"

    spacing: 40

    contentItem: Column {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 20

        Repeater {
            model: wQuick.theme.textColor.length
            delegate: WeaQuick.ShadowText {
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Qt.AlignHCenter

                level: index
                // fontLevel: index % arrayTextFont.length
                font {
                    pixelSize: (1.25 + (index * index / (arrayTextColor.length * 3))) * 15
                    italic: index < 4
                }
                text: "Hello WeaQuick"

                /** ShadowText properties **/
                animationAngleRunning: font.italic
                angle: Math.PI / 4.0
                offset: Qt.point(-15.0 * Math.sin(angle), 10.0 * Math.cos(angle))
            }
        }
    }
}
