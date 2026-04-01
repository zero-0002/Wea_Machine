import QtQuick 2.12
import QtQuick.Controls 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Flickable {
    id: root

    property bool manualActive: false

    property int titleSize: 17
    property int fontSize: 15
    property int titleVAlignment: Qt.AlignVCenter
    property int titleHAlignment: Qt.AlignHCenter

    property int controlLevel: 2
    property int controlWidth: 150
    property int controlHeight: 33

    property alias spacing: layout.spacing

    clip: true
    contentWidth: width
    contentHeight: layout.height
    boundsBehavior: Flickable.StopAtBounds

    ScrollBar.vertical: CusScrollBar {}
    Column {
        id: layout
        width: parent.width
        spacing: 0

        // Homing Panel
        HomingPanel {
            id: homingPanel
            width: parent.width
            manualActive: root.manualActive
        }

        // Goto Position Panel
        GotoPosPanel {
            id: gotoPosPanel
            width: parent.width
            manualActive: root.manualActive
        }

        // ACC/DEC Panel
        RampPanel {
            id: rampPanel
            width: parent.width
            manualActive: root.manualActive
        }

        // Torque Panel
        TorquePanel {
            id: torquePanel
            width: parent.width
            manualActive: root.manualActive
        }

        // Speed Panel
        SpeedPanel {
            id: speedPanel
            width: parent.width
            manualActive: root.manualActive
        }
    }

    // Objects & inline-components
    component Title: Column {

        property alias title: titleLabel.text
        property alias titleVAlignment: titleLabel.verticalAlignment
        property alias titleHAlignment: titleLabel.horizontalAlignment
        property alias titleLabel: titleLabel

        property alias shineColor: shineLine.color
        property alias shineWidth: shineLine.width
        property alias shineLine: shineLine

        width: parent.width
        height: controlHeight
        spacing: 7

        WeaQuick.Label {
            id: titleLabel
            width: parent.width
            height: parent.height
            font.pixelSize: root.titleSize
            verticalAlignment: root.titleVAlignment
            horizontalAlignment: root.titleHAlignment
        }

        ShineLine {
            id: shineLine
            width: parent.width
            color: "orange"
        }
    }

    component RowCompact: Item {

        property int padding: 0
        property int leftPadding: padding
        property int rightPadding: padding

        property alias title: titleLabelRow.text
        property alias titleVAlignment: titleLabelRow.verticalAlignment
        property alias titleHAlignment: titleLabelRow.horizontalAlignment
        property alias titleLabel: titleLabelRow

        width: parent.width
        height: controlHeight

        WeaQuick.Label {
            id: titleLabelRow
            // x: leftPadding
            anchors {
                left: parent.left
                leftMargin: parent.leftPadding
            }

            width: parent.width
            height: parent.height
            font.pixelSize: root.fontSize
            verticalAlignment: root.titleVAlignment
            horizontalAlignment: Qt.AlignLeft
        }
    }

    component Spacer: Item {
        width: 1
        height: 1
    }
}
