import QtQuick 2.12
import QtQuick.Controls 2.12 as Q
import com.wearily.WeaQuick 1.0 as WeaQuick

// TODO: add CustomItem implementation for handle (properties from Handle should be inside of an Item)

Q.Slider {
    id: root

    /** Default WeaQuick Properties **/
    property var arrayGrooveColor: wQuick.theme.sliderGrooveColor // Default rectangle
    property var arraySpanRectColor: wQuick.theme.sliderSpanRectColor
    property var arrayLimitColor: wQuick.theme.sliderLimitColor

    property int level: 0

    /** Slider Properties **/
    property real handleSize: 12 // By default is square (width == height)
    property real fromLimit: NaN // It can be greater than `from` value
    property real toLimit: NaN // It can be less than `to` value
    property real thickness: 4 // Thickness of the Groove Rectangle
    property real origin: root.from
    // normalized position values (0.0~1.0)
    readonly property real fromLimitPosition: WeaQuick.WeaQuickUtils.normalize(fromLimit, from, to)
    readonly property real toLimitPosition: WeaQuick.WeaQuickUtils.normalize(toLimit, from, to)
    readonly property real originPosition: WeaQuick.WeaQuickUtils.normalize(origin, from, to)

    // For example master: otherSlider or otherEditBox, otherSpinBox (but make sure it has valueModified signal)
    property QtObject master
    property var synchronizeFunc: function (targetValue) {
        // By default has 1, 1 scale but user can reimplement this as anything (make sure to return it)
        return targetValue;
    }

    /** Alias Properties **/
    property alias handleWidth: handle.width
    property alias handleHeight: handle.height

    /** Default Handle Properties **/
    property alias handleVisible: handleItem.visible
    property alias handleLevel: handleItem.level
    property alias handleMotion: handleItem.motion
    property alias handleFlat: handleItem.flat
    property alias handleShape: handleItem.shape

    property alias grooveVisible: groove.visible
    property alias grooveRadius: groove.radius

    property alias spanRectVisible: spanRect.visible

    property alias rippleSize: ripple.size
    property alias rippleActive: ripple.active
    property alias rippleEnabled: ripple.enabled

    property alias sliderHandle: handleItem
    property alias sliderGroove: groove
    property alias sliderSpanRect: spanRect
    property alias ripple: ripple

    // NOTE: Reimplement handerItem instead handler on the background
    default property alias handleItem: handleItem.data

    /** Signals **/

    // Same as moved signal (because slider can synchronize with all WeaQuick Controls)
    signal valueModified

    /** Initial values **/

    width: 300
    height: 15

    wheelEnabled: true

    handle: Item {
        id: handle
        width: root.handleSize
        height: root.handleSize

        // Position for horizontal Type
        x: root.leftPadding + (root.horizontal ? root.visualPosition * (root.availableWidth - width) : (
                                                     root.availableWidth - width) / 2)
        y: root.topPadding + (root.horizontal ? (root.availableHeight - height) / 2 : root.visualPosition * (
                                                    root.availableHeight - height))
        // Default Handler
		Handle {
            id: handleItem
            anchors.fill: parent
            handleHasFocus: root.visualFocus
            handlePressed: root.pressed
            handleHovered: root.hovered
            size: root.handleSize
            level: root.level
        }

        // Optional Ripple
        CircularRipple {
            id: ripple
            size: root.handleSize * 2
            // enabled: handleItem.visible
            active: root.pressed || root.hovered || root.visualFocus
            hasFocused: !handleItem.animationRunning && root.pressed
            targetColor: handleItem.color
        }
    }

    // Groove Rectangle
    background: SmoothRectangle {
        id: groove
        x: root.leftPadding + (root.horizontal ? 0 : (root.availableWidth - width) / 2)
        y: root.topPadding + (root.horizontal ? (root.availableHeight - height) / 2 : 0)
        implicitWidth: root.horizontal ? 200 : 48
        implicitHeight: root.horizontal ? 48 : 200
        width: root.horizontal ? root.availableWidth : root.thickness
        height: root.horizontal ? root.thickness : root.availableHeight
        scale: root.horizontal && root.mirrored ? -1 : 1
        radius: width / 2

        color: arrayGrooveColor[level]
        disableColor: "gray"

        // Limit Rectangle
        SmoothRectangle {
            id: limitRect

            x: root.horizontal ? root.fromLimitPosition * parent.width : (parent.width - width) / 2
            y: root.horizontal ? (parent.height - height) / 2 : (1.0 - root.toLimitPosition) * parent.height
            width: root.horizontal ? (root.toLimitPosition - root.fromLimitPosition) * parent.width : root.thickness
            height: root.horizontal ? root.thickness : (root.toLimitPosition - root.fromLimitPosition) * parent.height
            radius: groove.radius

            color: arrayLimitColor[level]
            disableColor: "black"
        }

        // Span Rectangle (Value)
        SmoothRectangle {
            id: spanRect
            x: root.horizontal ? Math.min(root.position, root.originPosition) * parent.width : (parent.width - width)
                                 / 2
            y: root.horizontal ? (parent.height - height) / 2 : Math.min(root.visualPosition, 1.0
                                                                         - root.originPosition) * parent.height
            width: root.horizontal ? Math.abs(root.position - root.originPosition) * parent.width : root.thickness
            height: root.horizontal ? root.thickness : Math.abs(root.position - root.originPosition) * parent.height
            radius: groove.radius

            color: arraySpanRectColor[level]
            disableColor: "darkGray"
        }
    }

    /** Signals & Slots **/

    // Synchronization connections
    Connections {
        target: root.master
        ignoreUnknownSignals: true

        /** Slots uses OR process for example Slider has moved signal and SpinBox has valueModified signal **/

        // onValueModified/onMoved instead of onValueChanged because it has no binding loop.

        function onValueModified() {
            root.value = synchronizeFunc(root.master.value);
        }

        function onMoved() {
            root.value = synchronizeFunc(root.master.value);
        }
    }

    // Applying clamp limitation
    onValueChanged: {
        const min = root.fromLimit;
        const max = root.toLimit;
        if (isNaN(min) || isNaN(max)) {
            return;
        }

        root.value = WeaQuick.WeaQuickUtils.clamp(value, min, max);
    }
}
