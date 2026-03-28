import QtQuick 2.12
import QtQuick.Window 2.12

import com.wearily.WeaQuick 1.0 as WeaQuick

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    WeaQuick.Pane {
        id: pane
        anchors {
            fill: parent
            margins: 15
        }
        level: 1

        WeaQuick.Button {
            anchors.centerIn: parent
            text: "Click Me"
        }
    }

    WeaQuick.GlobalContext {
        id: wQuick
    }
}
