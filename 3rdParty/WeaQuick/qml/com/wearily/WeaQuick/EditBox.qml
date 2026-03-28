import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12 as Q

/*
Reimplemeting using RectangleControl makes more flexible than overriding SpinBox
*/
RectangleControl {
    id: root

    /** Alias Properties **/

    // Current Item Properties
    property alias font: lineEdit.font
    property alias selectByMouse: lineEdit.selectByMouse

    // SpinBox Properties
    property alias displayText: spinBox.displayText
    property alias editable: spinBox.editable
    property alias inputMethodComposing: spinBox.inputMethodComposing
    property alias inputMethodHints: spinBox.inputMethodHints
    property alias wrap: spinBox.wrap
    property alias locale: spinBox.locale
    property alias validator: spinBox.validator
    property alias textFromValue: spinBox.textFromValue
    property alias valueFromText: spinBox.valueFromText
    property alias background: spinBox.background
    property alias contentItem: spinBox.contentItem
    property alias down: spinBox.down
    property alias up: spinBox.up

    // Items Properties
    property alias spinBox: spinBox
    property alias lineEdit: lineEdit
    // REQUIRED property of RectangleControl which must be define
    property alias textItem: lineEdit.textItem

    // Overriding SpinBox properties as real instead of int type
    property real from: 0.0
    property real to: 1.0
    property real value: 0.0
    property real stepSize: 0.01

    property int decimals: 2
    property string suffix: "" // Automatic suffix (no need to reimplement textFromValue & valueFromText for it.
    property bool wheelEnabled: true

    /** Synchronization properties **/

    // For example master: otherEditBox or otherEditBox.spinBox (but make sure it has valueModified signal)
    property QtObject master
    // NOTE: make sure to convert the realValue -> spinBox.value with int type.
    property var synchronizeFunc: function (targetValue) {
        // By default has 1, 1 scale but user can reimplement this as anything (make sure to return it)
        return doubleToInt(targetValue, root.master.decimals);
    }

    // SpinBox signal
    signal valueModified

    // Current Item signals
    signal wheel(var mouse)

    /** Properties assignment **/
    implicitWidth: 110
    implicitHeight: 30

    /** Virtual Functions (User can reimplement these **/
    textFromValue: function (value, locale) {
        return defaultTextFromValue(value, locale) + suffix;
    }
    valueFromText: function (text, locale) {
        // Removing suffix to make text total as number
        text = text.replace(suffix.trim(), "");
        return defaultValueFromText(text, locale);
    }

    // There is no Int Validator at this situation
    validator: DoubleValidator {
        bottom: Math.min(spinBox.from, spinBox.to)
        top: Math.max(spinBox.from, spinBox.to)
    }

    // Main Item
    Q.SpinBox {
        id: spinBox
        anchors {
            fill: parent
            margins: 2
        }

        editable: true

        /** Root value dependent properties must be calculate for origianl properties **/
        from: doubleToInt(root.from)
        to: doubleToInt(root.to)
        // NOTE: If stepSize is less than the 1.0 it will round to 0 and bug occure.
        stepSize: Math.max(doubleToInt(root.stepSize), 1)

        /** Reimplementing Value Item **/
        contentItem: LineEdit {
            id: lineEdit
            anchors {
                fill: parent
                margins: 1
            }
            z: 2 // z must be upper than background and lower than indicators buttons

            level: root.level
            levelLabel: root.levelLabel
            fontLevel: root.fontLevel
            border.width: 0
            radius: 0
            color: "transparent"

            text: root.displayText
            placehodlerItem.visible: false
            readOnly: !root.editable
            selectByMouse: true
            validator: spinBox.validator

            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
        }

        /** Reimplementing Background Item as empty Item **/
        background: Item {
            id: backgroundItem
            anchors.fill: parent
        }

        /** Reimplementing Indicators Item as empty Item **/
        down.indicator: Item {}
        up.indicator: Item {}

        /** Signal Forwarding **/
        onValueModified: {
            root.valueModified();
        }
    }

    /** Connections **/
    // Synchronization connections
    Connections {
        target: root.master
        ignoreUnknownSignals: true

        /** Slots uses OR process for example Slider has moved signal and SpinBox has valueModified signal **/

        // onValueModified/onMoved instead of onValueChanged because it has no binding loop.

        function onValueModified() {
            spinBox.value = synchronizeFunc(root.master.value);
        }

        function onMoved() {
            spinBox.value = synchronizeFunc(root.master.value);
        }
    }

    // RectangleControl event forwarding
    Connections {
        target: root.mouseArea

        function onWheel(mouse) {
            if (wheelEnabled) {
                root.wheel(mouse);
            }
        }
    }

    // Slots
    onWheel: {
        if (mouse.angleDelta.y > 0) {
            root.increase();
        } else {
            root.decrease();
        }
    }

    Component.onCompleted: {
        spinBox.value = doubleToInt(root.value);
        root.value = Qt.binding(function () {
            return intToDouble(spinBox.value);
        });
    }

    /** Functions **/

    /*!
    *  \brief setValue: setting the spinBox.value by passing the root.value scaled
    *  \note root.value cannot be changed after initialization (see Component.onCompleted).
    */
    function setValue(realValue, decimals = root.decimals) {
        spinBox.value = doubleToInt(realValue, decimals);
    }

    function defaultTextFromValue(value, locale) {
        return Number(intToDouble(value)).toLocaleString(locale, 'f', root.decimals);
    }

    function defaultValueFromText(text, locale) {
        return doubleToInt(Number.fromLocaleString(locale, text));
    }

    /*!
    *  \return doubleValue * decimal places
    */
    function doubleToInt(source, decimals = root.decimals) {
        return source * Math.pow(10, decimals);
    }

    /*!
    *  \return intValue / decimal places
    */
    function intToDouble(source, decimals = root.decimals) {
        return source / Math.pow(10, decimals);
    }

    // SpinBox functions
    function increase() {
        spinBox.increase();
        spinBox.valueModified();
    }

    function decrease() {
        spinBox.decrease();
        spinBox.valueModified();
    }
}
