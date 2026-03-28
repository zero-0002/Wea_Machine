import QtQuick 2.12
import QtQuick.Controls 2.12 as Q
import com.wearily.WeaQuick 1.0 as WeaQuick

// TODO: add CustomItem implementation for handle (properties from Handle should be inside of an Item)

Q.RangeSlider {
    id: root

    /** Default WeaQuick Properties **/
    property var arrayGrooveColor: wQuick.theme.sliderGrooveColor // Default rectangle
    property var arraySpanRectColor: wQuick.theme.sliderSpanRectColor
    property var arrayLimitColor: wQuick.theme.sliderLimitColor

    property int level: 0

    /** Slider Properties **/
    property real handlesSize: 12 // By default is square (width == height)
    property bool handlesVisible: true
    property bool handlesMotion: true
    property bool handlesFlat: false
    property int handlesShape: Handle.HandleShape.Square
    property bool ripplesEnabled: true

    property real fromLimit: NaN // It can be greater than `from` value
    property real toLimit: NaN // It can be less than `to` value
    property real thickness: 4 // Thickness of the Groove Rectangle

    // normalized position values (0.0~1.0)
    readonly property real fromLimitPosition: WeaQuick.WeaQuickUtils.normalize(fromLimit, from, to)
    readonly property real toLimitPosition: WeaQuick.WeaQuickUtils.normalize(toLimit, from, to)

    // For example master: otherSlider or otherEditBox, otherSpinBox (but make sure it has valueModified signal)
    property QtObject masterFirst
    property QtObject masterSecond

    property var synchronizeFunc: function (targetValue) {
        // By default has 1, 1 scale but user can reimplement this as anything (make sure to return it)
        return targetValue;
    }

    /** Alias Properties **/

    /** Default Handle Properties **/
    property alias firstHandleWidth: firstHandle.width
    property alias firstHandleHeight: firstHandle.height
    property alias firstHandleVisible: firstHandleItem.visible
    property alias firstHandleLevel: firstHandleItem.level
    property alias firstHandleMotion: firstHandleItem.motion
    property alias firstHandleFlat: firstHandleItem.flat
    property alias firstHandleShape: firstHandleItem.shape

    property alias secondHandleWidth: secondHandle.width
    property alias secondHandleHeight: secondHandle.height
    property alias secondHandleVisible: secondHandleItem.visible
    property alias secondHandleLevel: secondHandleItem.level
    property alias secondHandleMotion: secondHandleItem.motion
    property alias secondHandleFlat: secondHandleItem.flat
    property alias secondHandleShape: secondHandleItem.shape

    property alias grooveVisible: groove.visible
    property alias grooveRadius: groove.radius

    property alias spanRectVisible: spanRect.visible

    property alias firstRippleSize: firstRipple.size
    property alias firstRippleActive: firstRipple.active
    property alias firstRippleEnabled: firstRipple.enabled

    property alias secondRippleSize: secondRipple.size
    property alias secondRippleActive: secondRipple.active
    property alias secondRippleEnabled: secondRipple.enabled

    property alias sliderFirstHandle: firstHandleItem
    property alias sliderSecondHandle: secondHandleItem
    property alias sliderGroove: groove
    property alias sliderSpanRect: spanRect
    property alias firstRipple: firstRipple
    property alias secondRipple: secondRipple

    // NOTE: Reimplement handerItem instead handler on the background
    property alias firstHandleItem: firstHandleItem.data
    property alias secondHandleItem: secondHandleItem.data

    /** Initial values **/

    width: 300
    height: 15

    first.handle: Item {
        id: firstHandle
        width: root.handlesSize
        height: root.handlesSize

        // Position for horizontal Type
        x: root.leftPadding + (root.horizontal ? root.first.visualPosition * (root.availableWidth - width) : (
                                                     root.availableWidth - width) / 2)
        y: root.topPadding + (root.horizontal ? (root.availableHeight - height) / 2 : root.first.visualPosition * (
                                                    root.availableHeight - height))
        // Default Handler
        Handle {
            id: firstHandleItem
            anchors.fill: parent
            visible: root.handlesVisible
            handleHasFocus: activeFocus
            handlePressed: first.pressed
            handleHovered: first.hovered
            motion: root.handlesMotion
            flat: root.handlesFlat
            shape: root.handlesShape
            size: root.handlesSize
            level: root.level
        }

        // Optional Ripple
        CircularRipple {
            id: firstRipple
            enabled: root.ripplesEnabled
            size: root.handlesSize * 2
            active: first.pressed || first.hovered || activeFocus
            hasFocused: !firstHandleItem.animationRunning && first.pressed
            targetColor: firstHandleItem.color
        }
    }

    second.handle: Item {
        id: secondHandle
        width: root.handlesSize
        height: root.handlesSize

        // Position for horizontal Type
        x: root.leftPadding + (root.horizontal ? root.second.visualPosition * (root.availableWidth - width) : (
                                                     root.availableWidth - width) / 2)
        y: root.topPadding + (root.horizontal ? (root.availableHeight - height) / 2 : root.second.visualPosition * (
                                                    root.availableHeight - height))
        // Default Handler
        Handle {
            id: secondHandleItem
            anchors.fill: parent
            visible: root.handlesVisible
            handleHasFocus: activeFocus
            handlePressed: second.pressed
            handleHovered: second.hovered
            motion: root.handlesMotion
            flat: root.handlesFlat
            shape: root.handlesShape
            size: root.handlesSize
            level: root.level
        }

        // Optional Ripple
        CircularRipple {
            id: secondRipple
            enabled: root.ripplesEnabled
            size: root.handlesSize * 2
            active: second.pressed || second.hovered || activeFocus
            hasFocused: !secondHandleItem.animationRunning && second.pressed
            targetColor: secondHandleItem.color
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
            x: root.horizontal ? root.first.position * parent.width : 0
            y: root.horizontal ? 0 : root.second.visualPosition * parent.height
            width: root.horizontal ? root.second.position * parent.width - root.first.position * parent.width :
                                     root.thickness
            height: root.horizontal ? root.thickness : root.second.position * parent.height - root.first.position
                                      * parent.height

            radius: groove.radius

            color: arraySpanRectColor[level]
            disableColor: "darkGray"
        }
    }

    /** Signals & Slots **/

    // Synchronization connections
    Connections {
        target: root.masterFirst
        ignoreUnknownSignals: true

        /** Slots uses OR process for example Slider has moved signal and SpinBox has valueModified signal **/

        // onValueModified/onMoved instead of onValueChanged because it has no binding loop.

        function onValueModified() {
            first.value = synchronizeFunc(root.masterFirst.value);
        }

        function onMoved() {
            first.value = synchronizeFunc(root.masterFirst.value);
        }
    }

    Connections {
        target: root.masterSecond
        ignoreUnknownSignals: true

        /** Slots uses OR process for example Slider has moved signal and SpinBox has valueModified signal **/

        // onValueModified/onMoved instead of onValueChanged because it has no binding loop.

        function onValueModified() {
            second.value = synchronizeFunc(root.masterSecond.value);
        }

        function onMoved() {
            second.value = synchronizeFunc(root.masterSecond.value);
        }
    }

    // Applying clamp limitation

    first.onValueChanged: {
        applyFirstLimitation();
    }

    second.onValueChanged: {
        applySecondLimitation();
    }

    Component.onCompleted: {
        applyLimitations();
    }

    /** Functions **/
    function applyLimitations() {
        applyFirstLimitation();
        applySecondLimitation();
    }

    function applyFirstLimitation() {
        const min = root.fromLimit;
        const max = root.toLimit;
        if (isNaN(min) || isNaN(max)) {
            return;
        }

        first.value = WeaQuick.WeaQuickUtils.clamp(first.value, min, max);
    }

    function applySecondLimitation() {
        const min = root.fromLimit;
        const max = root.toLimit;
        if (isNaN(min) || isNaN(max)) {
            return;
        }

        second.value = WeaQuick.WeaQuickUtils.clamp(second.value, min, max);
    }
}
