import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

WeaQuick.Pane {
    id: root

    property var arrayBackgroundColor: wQuick.theme.paneBackgroundColor
    property var arraySelectedBackgroundColor: wQuick.theme.paneBackgroundColor
    property var arrayBorderColor: wQuick.theme.paneBorderColor
    property var arraySelectedBorderColor: ["white", "orange", "yellow", "green", "red", "gray", "darkGray", "#111",
        "#888"]

    property alias expand: dropDownButton.toggled
    property bool selectable: true
    property bool selected: false
    property bool autoDeselectSibling: false

    readonly property bool expanded: expand
    readonly property bool collapsed: !expand

    property alias dropDownButtonSize: dropDownButton.pixelSize
    property alias dropDownButtonColor: dropDownButton.color

    property real contentHeight: 300 // Required in most case
    property alias topContentHeight: topContent.height

    property alias dropDownButton: dropDownButton
    property alias topContent: topContent
    property alias shineLine: shineLine
    property alias mouseArea: mouseArea
    property alias contentHeightAnimation: contentHeightAnimation

    /** Delegate Properties **/
    property alias topDelegate: topDelegate.data
    property alias contentItem: loaderContentItem.sourceComponent
    readonly property alias mainContent: mainContent
    property alias loaderContentItem: loaderContentItem

    clip: true

    color: selectable && selected ? arraySelectedBackgroundColor[level] : arrayBackgroundColor[level]
    border.color: selectable && selected ? arraySelectedBorderColor[level] : arrayBorderColor[level]

    // implicitHeight: topContent.height + mainContent.height
    height: topContent.height + mainContent.height

    /** Top Content **/
    Rectangle {
        id: topContent
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        color: "transparent"
        height: 40

        RotaryButton {
            id: dropDownButton
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: height
            }

            name: "sort-down" // Icon name
            pixelSize: 17
        }

        // Top Remain Content
        Item {
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
                right: dropDownButton.left
                margins: 5
            }

            Item {
                id: topDelegate
                anchors.fill: parent
            }

            // Selecting
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                enabled: root.enabled && selectable
                acceptedButtons: Qt.LeftButton

                onClicked: {
                    selected = !selected;
                }
            }
        }
    }

    ShineLine {
        id: shineLine
        visible: mainContent.visible
        anchors {
            top: topContent.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: 1
        }

        width: parent.width * 0.9
    }

    Item {
        id: mainContent
        anchors {
            top: shineLine.bottom
            left: parent.left
            right: parent.right
            margins: 5
        }
        visible: opacity > 0
        opacity: height / contentHeight
        height: expanded ? contentHeight : 0

        Component {
            id: compContentItem
            Item {}
        }

        // Lazy loading content only when has expanded
        Loader {
            id: loaderContentItem
            active: expanded
            sourceComponent: compContentItem
        }

        /** Objects **/
        Behavior on height {
            NumberAnimation {
                id: contentHeightAnimation
                duration: 150
            }
        }
    }

    /** Objects && Slots **/

    onSelectedChanged: {
        if (autoDeselectSibling && selected) {
            deselctSiblings();
        }
    }

    /** Functions **/
    function select() {
        selected = true;
    }

    function deselect() {
        selected = false;
    }

    function collapseItem() {
        expand = false;
    }

    function expandItem() {
        expand = true;
    }

    function deselctSiblings() {
        const siblings = getSibling();

        for (var i = 0; i < siblings.length; ++i) {
            const sibling = siblings[i];
            if (sibling === this || sibling.expanded === undefined) {
                // Continue if isn't DropDown or if its this content
                continue;
            }

            sibling.deselect();
        }
    }

    function getSibling() {
        return parent.children;
    }
}
