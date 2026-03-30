import QtQuick 2.12
import QtQuick.Layouts 1.12
import com.wearily.WeaQuick 1.0 as WeaQuick

DropDown {
    id: root

    property var arrayRunningBorderColor: ["gray", "green", "red", "orange", "cyan", "white", "black", "#888", "#444"]

    property bool running: false

    property alias title: titleLabel.text
    property alias titleSize: titleLabel.font.pixelSize
    property alias titleHAlignment: titleLabel.horizontalAlignment
    property alias titleVAlignment: titleLabel.verticalAlignment

    property alias titleLabel: titleLabel

    property alias readyIndicator: readyIndicator

    contentHeight: stepContentItem.height + topContentHeight

    level: 1
    flat: false
    shineLine.color: running ? arrayRunningBorderColor[level] : selected ? arraySelectedBorderColor[level] : "white"

    // Top Content Item
    topDelegate: RowLayout {
        anchors.fill: parent
        spacing: 10

        // Title
        WeaQuick.Label {
            id: titleLabel
            Layout.fillWidth: true
            Layout.leftMargin: 5
            Layout.rightMargin: 5

            text: "Step No.1"
            font.pixelSize: 15
            verticalAlignment: Qt.AlignVCenter
            elide: Text.ElideRight
        }

        // Ready Label
        WeaQuick.Label {
            text: "Ready"
            font.pixelSize: 14
            verticalAlignment: Qt.AlignVCenter
        }

        // Ready Indicator
        WeaQuick.StatusIndicator {
            id: readyIndicator
            Layout.rightMargin: 10

            width: 24
            height: width
            outerMargin: 2

            levelActive: 2 // green
        }
    }

    // Main Item
    contentItem: Item {
        anchors.fill: parent

        StepContentItem {
            id: stepContentItem

            x: 10 // Margin left
            width: parent.width - x * 2
            shineLineColor: root.shineLine.color

            titleSize: root.titleSize
        }
    }

    /** Animation When it is running **/
    SequentialAnimation on border.color {
        running: root.running
        loops: Animation.Infinite
        ColorAnimation {
            from: arrayBackgroundColor[level]
            to: arrayRunningBorderColor[level]
            duration: 750
        }
        ColorAnimation {
            from: arrayRunningBorderColor[level]
            to: arrayBackgroundColor[level]
            duration: 750
        }
    }
}
