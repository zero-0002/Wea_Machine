import QtQuick 2.12
import QtQuick.Layouts 1.12

import com.wearily.WeaQuick 1.0 as WeaQuick
// Including ExamplePane
import "../"

ExamplePane {
    id: root

    title: "Simple Button Example"

    spacing: 15

    contentItem: ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 20
        WeaQuick.Button {
            text: "Play"
        }
        WeaQuick.Button {
            text: "Play"
            icon: FontAwesome.icons.play
        }
        WeaQuick.Button {
            text: "Play"
            icon: FontAwesome.icons.play
            layoutDirection: Qt.RightToLeft
        }
        WeaQuick.Button {
            icon: FontAwesome.icons.play
        }
        WeaQuick.Button {
            text: "Transparent"
            color: "transparent"
            onPressed: text = "Pressed"
            onReleased: text = "Transparent"
        }
        WeaQuick.Button {
            text: "Disabled"
            enabled: false
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }
}
