import QtQuick 2.12
import QtQuick.Layouts 1.12
import com.wearily.WeaQuick 1.0 as WeaQuick

DropDown {
    id: root

    signal playRequest
    signal pauseRequest

    property var modelItem: ({})

    property var arrayRunningBorderColor: ["gray", "green", "red", "orange", "cyan", "white", "black", "#888", "#444"]

    property bool running: false

    property alias title: titleLabel.text
    property alias titleSize: titleLabel.font.pixelSize
    property alias titleHAlignment: titleLabel.horizontalAlignment
    property alias titleVAlignment: titleLabel.verticalAlignment

    property alias titleLabel: titleLabel

    property alias playStepButton: playStepButton

    contentHeight: loaderContentItem.height + topContentHeight

    level: 1
    flat: false
    shineLine.color: running ? arrayRunningBorderColor[level] : selected ? arraySelectedBorderColor[level] : "white"
    border.color: selectable && selected ? arraySelectedBorderColor[level] : running ? arrayRunningBorderColor[level] :
                                                                                       arrayBorderColor[level]

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
            text: playStepButton.checked ? "Stop" : "Run"
            font.pixelSize: 14
            verticalAlignment: Qt.AlignVCenter
        }

        // Ready Indicator
        CircularButton {
            id: playStepButton
            Layout.rightMargin: 10

            checked: root.running
            onClicked: {
                if (!checked) {
                    playRequest();
                } else {
                    pauseRequest();
                }
            }
        }
    }

    // Main Item
    loaderContentItem {
        anchors {
            left: mainContent.left
            right: mainContent.right
            margins: 10
        }
    }
    contentItem: Component {
        StepContentItem {
            id: stepContentItem
            shineLineColor: root.shineLine.color
            titleSize: root.titleSize
            modelItem: root.modelItem
        }
    }
}
