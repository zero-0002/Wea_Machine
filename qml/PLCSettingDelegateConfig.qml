import QtQuick 2.12
import QtQuick.Layouts 1.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Item {
    id: root

    property string digitalName: ""
    property alias plcIndicatorSize: plcIndicator.width

    property alias delayEditBox: delayEditBox
    property alias plcIndicator: plcIndicator
    property alias pcIndicator: pcIndicator
    property alias line: line

    implicitHeight: 70

    Rectangle {
        id: line

        anchors.verticalCenter: parent.verticalCenter

        width: parent.width
        height: 1
        color: "orange"
    }

    Compact {
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: 10
        }

        title: digitalName

        WeaQuick.StatusIndicator {
            id: pcIndicator

            width: 30
            height: 30
            radius: width / 2

            level: 3
        }
    }

    Column {
        anchors {
            top: parent.top
            bottom: parent.bottom

            horizontalCenter: parent.horizontalCenter

            bottomMargin: delayEditBox.height
        }
        spacing: 3

        WeaQuick.Label {
            font.pixelSize: 14
            text: "On Delay Timer"
            width: 120
            horizontalAlignment: Qt.AlignHCenter
        }

        DelayEditBox {
            id: delayEditBox
            width: 120
            height: 30
            level: 2
            border.width: 1
            font.pixelSize: 14
            arrayBackgroundColor: ["black", "black", "black"]
        }
    }

    Compact {
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            rightMargin: 10
        }

        title: digitalName
        layoutDirection: Qt.RightToLeft

        WeaQuick.StatusIndicator {
            id: plcIndicator

            width: 30
            height: 30
            radius: width / 2

            level: 0
        }
    }

    // Object && inline-component

    component Compact: Row {

        property alias title: titleLabel.text
        property alias titleLabel: titleLabel

        spacing: 5

        WeaQuick.Label {
            id: titleLabel
            y: -5
            width: 50
            font.pixelSize: 14
            verticalAlignment: Qt.AlignTop
            horizontalAlignment: parent.layoutDirection === Qt.RightToLeft ? Qt.AlignRight : Qt.AlignLeft
        }
    }
}
