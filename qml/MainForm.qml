import QtQuick 2.15
import com.wearily.WeaQuick 1.0 as WeaQuick

Item {
    id: root

    WeaQuick.Pane {
        anchors {
            fill: parent
            margins: 15
        }

        WeaQuick.Button {
            anchors.centerIn: parent
            text: "Click Me"
        }
    }

    WeaQuick.GlobalContext {
        id: wQuick
    }
}
