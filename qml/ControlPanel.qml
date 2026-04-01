import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Item {
    id: root

    property int level: 1
    property int padding: 10

    property alias panelView: panelView
    property alias axisControlPanel: axisControlPanel

    PanelView {
        id: panelView
        anchors {
            top: parent.top
            right: parent.right
            bottom: axisControlPanel.top
            margins: padding
        }
        width: parent.width
        manualActive: axisControlPanel.manualActive
    }

    // Footer (Maybe Joystick)
    AxisControlPanel {
        id: axisControlPanel
        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: padding
        }
        width: parent.width
        height: 375
    }
}
