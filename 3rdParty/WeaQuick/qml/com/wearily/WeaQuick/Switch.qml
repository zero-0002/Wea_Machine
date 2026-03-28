import QtQuick 2.12
import QtQuick.Controls 2.12 as Q

Q.Switch {
    id: root

    /** Default WeaQuick Properties **/
    property var arrayUncheckedBackgroundColor: wQuick.theme.switchUncheckedBackgroundColor
    property var arrayCheckedBackgroundColor: wQuick.theme.switchCheckedBackgroundColor
    property var arrayUncheckedBorderColor: wQuick.theme.switchUncheckedBorderColor
    property var arrayCheckedBorderColor: wQuick.theme.switchCheckedBorderColor
    property var arrayUncheckedHandleColor: wQuick.theme.switchUncheckedHandleColor
    property var arrayCheckedHandleColor: wQuick.theme.switchCheckedHandleColor

    property int level: 0
    property alias levelHandle: handle.level
    property alias levelLable: label.level

    /** Properties **/
    property string uncheckedText: "O "
    property string checkedText: " |"

    property int offsetLabel: (indicator.height - label.height) / 2
    property int offsetHandle: (indicator.height - handle.height) / 2

    /** Positional Properties **/
    readonly property real labelPosition: Math.max(offsetLabel, Math.min(indicator.width - offsetLabel - label.width, (
                                                                             1.0 - visualPosition) * indicator.width - (
                                                                             label.width / 2)))
    readonly property real handlePosition: Math.max(offsetHandle, Math.min(indicator.width - offsetHandle - handle.width,
                                                                           root.visualPosition * indicator.width - (
                                                                               handle.width / 2)))

    /** Alias Properties **/
    property alias indicatorWidth: swIndicator.width
    property alias indicatorHeight: swIndicator.height

    property alias textVisible: label.visible
    property alias textFont: label.font

    property alias handleVisible: handle.visible
    property alias handleSize: handle.size
    property alias handleRadius: handle.squareRadius
    property alias handleMotion: handle.motion
    property alias handleFlat: handle.flat
    property alias handleShape: handle.shape
    property alias handleBigScale: handle.bigScale
    readonly property alias handleScale: handle.scale

    property alias rippleSize: ripple.size
    property alias rippleActive: ripple.active
    property alias rippleEnabled: ripple.enabled

    // property alias indicator: swIndicator NOTE: no need to define this property (its already exists)
    property alias handleItem: handleItem
    property alias label: label
    property alias handle: handle
    property alias ripple: ripple
    property alias handlePositionAnimation: handlePosAnimation

    default property alias handleDelegate: handleItem.data

    // Default Qt Text Item
    contentItem.visible: false

    width: 60
    height: 30

    text: root.checked ? root.checkedText : root.uncheckedText

    // Switch Background
    indicator: SmoothRectangle {
        id: swIndicator

        x: text ? (root.mirrored ? root.width - width - root.rightPadding : root.leftPadding) : root.leftPadding + (
                      root.availableWidth - width) / 2
        y: root.topPadding + (root.availableHeight - height) / 2

        // Default size
        width: 44
        height: 22
        radius: handle.shape === Handle.HandleShape.Circular ? width / 2 : handle.radius

        color: root.checked ? arrayCheckedBackgroundColor[level] : arrayUncheckedBackgroundColor[level]
        disableColor: "#222"

        border.color: root.checked ? arrayCheckedBorderColor[level] : arrayUncheckedBorderColor[level]
        border.width: 1

        colorAnimation.duration: 250

        // Inner Text Label
        Label {
            id: label

            visible: false // invisible by default

            x: root.labelPosition
            y: (parent.height - height) / 2

            font.pixelSize: 11
            text: root.text
        }

        // Switch Indicator Handle
        Item {
            id: handleItem
            x: root.handlePosition
            y: (parent.height - height) / 2

            width: handle.width
            height: handle.height

            // Can be useful for custom handleDelegation
            // scale: handle.scale

            Handle {
                id: handle

                // NOTE: Make sure to invisible `handle` when `handleDelegate` has been override.
                // visible: handleItem.data.length === 2

                /** Color Style Properties **/
                arrayHandleColor: root.checked ? arrayCheckedHandleColor : arrayUncheckedHandleColor

                handlePressed: root.checked
                handleHovered: root.hovered
                handleHasFocus: root.visualFocus

                motion: false
                size: indicatorHeight * 0.75
                squareRadius: 4
                bigScale: 1.45
            }

            // Optional Ripple
            CircularRipple {
                id: ripple
                size: root.handleSize * 2.0
                // enabled: handleItem.visible
                active: root.pressed || root.hovered || root.visualFocus
                hasFocused: !handle.animationRunning && root.pressed
                targetColor: handle.color
            }

            /** Animations **/
            Behavior on x {
                enabled: !root.pressed
                SmoothedAnimation {
                    id: handlePosAnimation
                    duration: 300
                }
            }
        }
    }
}
