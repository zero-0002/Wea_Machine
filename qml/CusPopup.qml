import QtQuick 2.12
import QtQuick.Controls 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Popup {
    id: root

    property int popUpSpacing: 5 // spacing between Title and popUpContent
    property alias title: titleLabel.text
    property alias titleSize: titleLabel.font.pixelSize

    property alias titleLabel: titleLabel

    default property alias popUpDelegate: popUpContent.data

    parent: overlay
    padding: 10
    width: 420
    height: 550

    x: overlay.width / 2 - root.width / 2
    y: overlay.height / 2 - root.height / 2
    modal: true
    focus: false
    // closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

    background: WeaQuick.Pane {
        level: 1
        flat: false
        width: root.width
        height: root.height
        dropShadow {
            verticalOffset: 0.0
            horizontalOffset: 0.0
            radius: 12
            samples: 14
        }
    }

    contentItem: Item {
        WeaQuick.Label {
            id: titleLabel
            x: horizontalPadding
            y: topPadding

            font.pixelSize: 16
        }

        Item {
            anchors {
                top: titleLabel.bottom
                topMargin: popUpSpacing
            }
            x: leftPadding
            width: availableWidth - (leftPadding + rightPadding)
            height: availableHeight - bottomPadding - titleLabel.paintedHeight - titleLabel.y - popUpSpacing

            Item {
                id: popUpContent
                anchors.fill: parent
            }
        }
    }

    onAboutToShow: overlay.opacity = 0.4
    onAboutToHide: overlay.opacity = 0.0
}
