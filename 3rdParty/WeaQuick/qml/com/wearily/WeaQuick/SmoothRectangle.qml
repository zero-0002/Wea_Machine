import QtQuick 2.12

/**
SmootRectangle has smooth animation on size and color and other visual properties with automatic enable/disable color
**/
Rectangle {
    id: root

    /** Properties **/
    property bool animationsEnabled: true

    /** Alias Proeprties **/
    property alias colorAnimation: colorAnimation
    property alias borderColorAnimation: borderColorAnimation
    property alias opacityAnimation: opacityAnimation
    property alias scaleAnimation: scaleAnimation
    property alias rotationAnimation: rotationAnimation

    /**
    `disableColor` property is Required to avoid binding loop.

    NOTE: `disableColor` has initial value, The binding process with `color` property will be ignored.
    NOTE: Make sure to pass value for `disableColor` after color property. Example:

    CORRECT:

    color: "red"
    disableColor: "gray"

    WRONG:
    disableColor: "gray"
    color: "red"

    See also Private & Logics section at the bottom.
    **/
    property color disableColor

    border.width: 0

    /** States & Transitions **/

    states: [
        // Disabled
        State {
            name: "disabled"
            when: !enabled

            PropertyChanges {
                target: root
                color: disableColor
                border.color: disableColor
            }
        }
    ]
    // Transitions for `disabled` state works only when colorAnimation is disabled
    transitions: [
        Transition {
            to: "disabled"
            enabled: !behaviorColor.enabled // avoid multi animationn flow

            ColorAnimation {
                duration: 150
            }
        }
    ]

    /** Animations **/

    Behavior on color {
        id: behaviorColor
        enabled: animationsEnabled
        ColorAnimation {
            id: colorAnimation
            duration: 150
        }
    }

    Behavior on border.color {
        enabled: animationsEnabled
        ColorAnimation {
            id: borderColorAnimation
            duration: colorAnimation.duration
        }
    }

    Behavior on opacity {
        enabled: animationsEnabled
        NumberAnimation {
            id: opacityAnimation
            duration: colorAnimation.duration
        }
    }

    Behavior on scale {
        enabled: animationsEnabled
        NumberAnimation {
            id: scaleAnimation
            duration: 150
        }
    }

    Behavior on rotation {
        enabled: animationsEnabled
        RotationAnimation {
            id: rotationAnimation
            duration: 150
        }
    }

    /** Private & Logics **/
    onDisableColorChanged: {
        _private.disableColorHasValueByUser = disableColor !== _private.darkColor();
    }

    onColorChanged: {
        if (_private.disableColorHasValueByUser) {
            return;
        }

        if (!enabled) {
            // Avoids value assignment loop for `color` property
            return;
        }

        disableColor = _private.darkColor();
    }

    QtObject {
        id: _private

        /** Properties **/
        property bool disableColorHasValueByUser: false

        /** Functions **/
        function darkColor() {
            return Qt.darker(color, 3.0);
        }
    }
}
