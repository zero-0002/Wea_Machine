import QtQuick 2.12

/*!
\brief RectangleControl: A base component for controls items
which has default states and transition. Also declares a default mouseArea, so
don't need to define MouseArea for Controls Items.

\note Make sure you pass array${colors} properties on children Items.
*/
Rectangle {
    id: root

    /** Required Properties **/
    // NOTE: Define `property alias textItem: yourItem` into the inherited Item to implement color transition automatically.

    // Pass array colors, example -> wQuick.theme.buttonBackgroundColor
    property var arrayBackgroundColor: wQuick.theme.controlBackgroundColor
    property var arrayHoveredBackgroundColor: wQuick.theme.controlHoveredBackgroundColor
    property var arraySelectedBackgroundColor: wQuick.theme.controlSelectedBackgroundColor

    property var arrayBorderColor: wQuick.theme.controlBorderColor
    property var arrayHoveredBorderColor: wQuick.theme.controlHoveredBorderColor
    property var arraySelectedBorderColor: wQuick.theme.controlSelectedBorderColor

    property var arrayBorderWidth: wQuick.theme.controlBorderWidth

    property var arrayTextColor: wQuick.theme.textColor

    /** Default Properties **/
    property int level: 0
    property int levelLabel: 0
    property int fontLevel: 0

    property bool flat: true
    property bool checkable: false
    property bool checked: false
    property bool locked: false // locking at checked states means disabling mouseArea until programally unchecked

    /** Item Alias **/
    property alias mouseArea: mouseArea
    property alias dropShadow: dropShadow
    property alias colorAnimation: bgColorAnimation

    /** Signals **/
    signal hovered(var mouse)

    visible: opacity > 0
    width: 100
    height: 30
    clip: true

    color: arrayBackgroundColor[level]
    border.color: arrayBorderColor[level]
    border.width: arrayBorderWidth[level]
    radius: 5

    // Optional Gradient (referer flat property)
    gradient: Gradient {

        GradientStop {
            color: root.flat ? root.color : Qt.lighter(root.color, 1.75)
            position: 0.0
        }

        GradientStop {
            color: root.color
            position: 1.0
        }
    }

    /** Shadows & Effects **/
    layer.enabled: true
    layer.effect: DropShadowBinder {
        dropShadowObject: dropShadow
    }

    DropShadowObject {
        id: dropShadow
        // color: "#aa000000"
        samples: 9
        radius: 4
        verticalOffset: 0.0
        horizontalOffset: 0.0
        spread: 0.0
    }

    /** States & Transitions **/
    states: [
        State {
            name: "transparent"
            when: (enabled && _private.isTransparent)
            PropertyChanges {
                target: root
                color: "transparent"
                border.color: "transparent"
                dropShadow.verticalOffset: 0.0
                dropShadow.horizontalOffset: 0.0
            }
        },
        State {
            name: "default"
            when: (enabled && !mouseArea.containsMouse && !mouseArea.containsPress && !isChecked())
            PropertyChanges {
                target: root
                color: arrayBackgroundColor[level]
                border.color: arrayBorderColor[level]
                dropShadow.verticalOffset: 0.0
                dropShadow.horizontalOffset: 0.0
            }
        },
        State {
            name: "hovered"
            when: (enabled && mouseArea.containsMouse && !mouseArea.containsPress && !isLocked())
            PropertyChanges {
                target: root
                color: arrayHoveredBackgroundColor[level]
                border.color: arrayHoveredBorderColor[level]
            }
        },
        State {
            name: "pressed"
            when: (enabled && mouseArea.containsMouse && mouseArea.containsPress && !isLocked())
            PropertyChanges {
                target: root
                color: arraySelectedBackgroundColor[level]
                border.color: arraySelectedBorderColor[level]
                dropShadow.verticalOffset: 1.0
                dropShadow.horizontalOffset: 1.0
            }
        },
        State {
            name: "locked"
            when: (enabled && isLocked())
            PropertyChanges {
                target: root
                mouseArea.cursorShape: Qt.ArrowCursor
                color: arraySelectedBackgroundColor[level]
                border.color: arraySelectedBorderColor[level]
                dropShadow.verticalOffset: 1.0
                dropShadow.horizontalOffset: 1.0
            }
        },
        State {
            name: "checked"
            when: (enabled && isChecked())
            PropertyChanges {
                target: root
                color: arraySelectedBackgroundColor[level]
                border.color: arraySelectedBorderColor[level]
                dropShadow.verticalOffset: 1.0
                dropShadow.horizontalOffset: 1.0
            }
        },
        State {
            name: "disabledTransparent"
            when: (!enabled && _private.isTransparent)
            PropertyChanges {
                target: root
                color: "transparent"
                border.color: Qt.lighter(arrayBackgroundColor[level], 0.6)
                textItem.color: Qt.darker(arrayTextColor[levelLabel], 3.0)
                dropShadow.verticalOffset: 0.0
                dropShadow.horizontalOffset: 0.0
            }
        },
        State {
            name: "disabled"
            when: !enabled && !_private.isTransparent
            PropertyChanges {
                target: root
                color: Qt.lighter(arrayBackgroundColor[level], 0.6)
                border.color: color
                textItem.color: Qt.darker(arrayTextColor[levelLabel], 3.0)
                dropShadow.verticalOffset: 0.0
                dropShadow.horizontalOffset: 0.0
            }
        }
    ]
    transitions: [
        Transition {
            ColorAnimation {
                id: bgColorAnimation
                duration: 150
            }
        }
    ]

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        acceptedButtons: Qt.AllButtons
        hoverEnabled: true

        /** Forwarding Signals **/
        onEntered: {
            root.hovered(mouseArea);
        }

        onPressed: {
            if (checkable) {
                checked = !checked;
            }
        }
    }

    QtObject {
        id: _private

        property bool isTransparent: root.color === Qt.rgba(0, 0, 0, 0)
    }

    /** Functions **/
    function isChecked() {
        return checked;
    }

    function isLocked() {
        return isChecked() && locked;
    }
}
