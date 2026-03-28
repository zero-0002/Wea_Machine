import QtQuick 2.12
import QtQuick.Controls 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

ComboBox {
    id: root

    property int level: 1
    property int levelLabel: 0

    property int labelSize: 13

    width: 120
    height: 30

    wheelEnabled: true
    leftPadding: 7

    delegate: ItemDelegate {
        id: delegate

        width: root.width
        height: root.height
        highlighted: root.highlightedIndex === index

        background: WeaQuick.Pane {
            anchors.fill: parent

            level: highlighted ? root.level : (root.level + 1) % wQuick.theme.paneBackgroundColor.length
            border.width: 0
            radius: 0
        }

        contentItem: WeaQuick.Label {
            id: delegateLabel
            level: root.levelLabel
            text: modelData
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            font.pixelSize: root.labelSize
        }
    }

    background: WeaQuick.Pane {
        anchors.fill: parent
        level: root.level
        flat: false
        radius: 4
    }

    indicator: WeaQuick.IconFont {
        x: root.width - width - root.rightPadding
        y: root.topPadding + (root.availableHeight - height) / 2
        name: "angle-down"
        pixelSize: 13
    }

    contentItem: WeaQuick.Label {
        id: contentLabel
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: indicator.left
            leftMargin: root.leftPadding
            rightMargin: root.rightPadding
        }
        level: root.levelLabel
        text: root.displayText
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: root.labelSize
    }

    popup: Popup {
        y: root.height - 1
        width: root.width
        implicitHeight: contentItem.implicitHeight
        padding: 1

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: root.popup.visible ? root.delegateModel : null
            currentIndex: root.highlightedIndex

            ScrollIndicator.vertical: ScrollIndicator {}
        }

        background: Rectangle {
            border.color: wQuick.theme.paneBorderColor[root.level]
            border.width: 2
            radius: 2
        }
    }
}
