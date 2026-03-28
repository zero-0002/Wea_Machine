import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12 as Q

/// TODO: Add Normal Icon which uses Image component at base and load that with Loader (iconFont, iconPixmap, .etc).
RectangleControl {
    id: root

    /** Properties **/


    /*
        display : enumeration -> Referer AbstractButton Display
        AbstractButton.IconOnly
        AbstractButton.TextOnly
        AbstractButton.TextBesideIcon (default)
        AbstractButton.TextUnderIcon
    */
    property int display: Q.AbstractButton.TextBesideIcon
    property bool invert: true
    property int cursorShape: Qt.PointingHandCursor

    /** Alias Properties **/
    property alias text: label.text
    property alias textColor: label.color // RECOMMEND to use levelLabel instead
    property alias font: label.font // RECOMMEND to use fontLevel instead
    property alias icon: icon.name
    property alias iconSize: icon.pixelSize
    property alias iconLevel: icon.level
    property alias iconColor: icon.color // RECOMMEND to use iconLevel instead
    property alias iconMap: icon.iconMap
    property alias spacing: layout.spacing
    property alias layoutDirection: layout.layoutDirection
    property alias textVerticalAlignment: label.verticalAlignment
    property alias textHorizontalAlignment: label.horizontalAlignment
    property alias iconVerticalAlignment: icon.verticalAlignment
    property alias iconHorizontalAlignment: icon.horizontalAlignment

    property alias label: label
    property alias iconItem: icon
    property alias layoutItem: layout

    /** Signals **/
    signal canceled(var mouse)
    signal clicked(var mouse)
    signal doubleClicked(var mouse)
    signal pressAndHold(var mouse)
    signal pressed(var mouse)
    signal released(var mouse)
    signal toggled(var mouse)

    /** REQUIRED Inherited Properties START **/
    property alias textItem: label
    arrayBackgroundColor: wQuick.theme.buttonBackgroundColor
    arrayHoveredBackgroundColor: wQuick.theme.buttonHoveredBackgroundColor
    arraySelectedBackgroundColor: wQuick.theme.buttonSelectedBackgroundColor
    arrayBorderColor: wQuick.theme.buttonBorderColor
    arrayHoveredBorderColor: wQuick.theme.buttonHoveredBorderColor
    arraySelectedBorderColor: wQuick.theme.buttonSelectedBorderColor
    arrayBorderWidth: wQuick.theme.buttonBorderWidth
    arrayTextColor: wQuick.theme.textColor

    // Reimplement properties values
    mouseArea.cursorShape: enabled
                           && mouseArea.enabled ? root.cursorShape : Qt.ArrowCursor

    /** Components **/
    RowLayout {
        id: layout
        anchors {
            fill: parent
            margins: 0
        }
        spacing: 8
        clip: true

        IconFont {
            id: icon
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.preferredWidth: 5
            verticalAlignment: Qt.AlignVCenter
            horizontalAlignment: !label.visible ? Qt.AlignHCenter : layout.layoutDirection
                                                  === Qt.LeftToRight ? Qt.AlignRight : Qt.AlignLeft
            visible: name.length > 0
            name: ""
            // level: iconLevel
        }

        Label {
            id: label
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.preferredWidth: 10
            verticalAlignment: Qt.AlignVCenter
            horizontalAlignment: !icon.visible ? Qt.AlignHCenter : layout.layoutDirection
                                                 === Qt.LeftToRight ? Qt.AlignLeft : Qt.AlignRight
            visible: text || text !== ""
            level: root.levelLabel
            fontLevel: root.fontLevel
        }
    }

    /** Making a forward connection between RectangleControl mouseArea signals and root signals. **/
    Connections {
        target: mouseArea

        /** Forwarding Signals **/
        function onCanceled(mouse) {
            root.canceled(mouse)
        }

        function onClicked(mouse) {
            root.clicked(mouse)
        }

        function onDoubleClicked(mouse) {
            root.doubleClicked(mouse)
        }

        function onPressAndHold(mouse) {
            root.pressAndHold(mouse)
        }

        function onPressed(mouse) {
            root.pressed(mouse)
        }

        function onReleased(mouse) {
            root.released(mouse)
        }
    }
}
