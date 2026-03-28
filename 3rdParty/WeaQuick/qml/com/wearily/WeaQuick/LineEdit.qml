import QtQuick 2.12

RectangleControl {
    id: root

    /** Alias Properties **/

    // Current Item Properties
    property alias font: textInput.font
    property alias textColor: textInput.color

    // TextInput forward
    property alias text: textInput.text
    property alias acceptableInput: textInput.acceptableInput
    property alias activeFocusOnPress: textInput.activeFocusOnPress
    property alias autoScroll: textInput.autoScroll
    property alias bottomPadding: textInput.bottomPadding
    property alias canPaste: textInput.canPaste
    property alias canRedo: textInput.canRedo
    property alias canUndo: textInput.canUndo
    property alias contentHeight: textInput.contentHeight
    property alias contentWidth: textInput.contentWidth
    property alias cursorDelegate: textInput.cursorDelegate
    property alias cursorPosition: textInput.cursorPosition
    property alias cursorRectangle: textInput.cursorRectangle
    property alias cursorVisible: textInput.cursorVisible
    property alias displayText: textInput.displayText
    property alias echoMode: textInput.echoMode
    property alias effectiveHorizontalAlignment: textInput.effectiveHorizontalAlignment
    property alias horizontalAlignment: textInput.horizontalAlignment
    property alias inputMask: textInput.inputMask
    property alias inputMethodComposing: textInput.inputMethodComposing
    property alias inputMethodHints: textInput.inputMethodHints
    property alias leftPadding: textInput.leftPadding
    property alias length: textInput.length
    property alias maximumLength: textInput.maximumLength
    property alias mouseSelectionMode: textInput.mouseSelectionMode
    property alias overwriteMode: textInput.overwriteMode
    property alias padding: textInput.padding
    property alias passwordCharacter: textInput.passwordCharacter
    property alias passwordMaskDelay: textInput.passwordMaskDelay
    property alias persistentSelection: textInput.persistentSelection
    property alias preeditText: textInput.preeditText
    property alias readOnly: textInput.readOnly
    property alias renderType: textInput.renderType
    property alias rightPadding: textInput.rightPadding
    property alias selectByMouse: textInput.selectByMouse
    property alias selectedText: textInput.selectedText
    property alias selectedTextColor: textInput.selectedTextColor
    property alias selectionColor: textInput.selectionColor
    property alias selectionEnd: textInput.selectionEnd
    property alias selectionStart: textInput.selectionStart
    property alias topPadding: textInput.topPadding
    property alias validator: textInput.validator
    property alias verticalAlignment: textInput.verticalAlignment
    property alias wrapMode: textInput.wrapMode

    // Placeholder text forward
    property alias placeholderText: placeholder.text
    property alias placeholderColor: placeholder.color

    /** Item Alias **/
    property alias textInputItem: textInput
    property alias placehodlerItem: placeholder

    signal accepted
    signal editingFinished
    signal textEdited

    /** REQUIRED Inherited Properties START **/
    property alias textItem: textInput
    arrayBackgroundColor: wQuick.theme.editBackgroundColor
    arrayHoveredBackgroundColor: wQuick.theme.editHoveredBackgroundColor
    arraySelectedBackgroundColor: wQuick.theme.editSelectedBackgroundColor
    arrayBorderColor: wQuick.theme.editBorderColor
    arrayHoveredBorderColor: wQuick.theme.editHoveredBorderColor
    arraySelectedBorderColor: wQuick.theme.editSelectedBorderColor
    arrayBorderWidth: wQuick.theme.editBorderWidth
    arrayTextColor: wQuick.theme.textColor

    // Reimplement properties values
    mouseArea {
        acceptedButtons: Qt.NoButton
        cursorShape: root.readOnly ? Qt.ArrowCursor : Qt.IBeamCursor
    }

    // Components
    TextInput {
        id: textInput
        anchors {
            fill: parent
            margins: 4
            leftMargin: 8
            rightMargin: 8
        }

        clip: true

        font {
            // NOTE: pointSize isn't available anymore! (use pixelSize instead)
            family: wQuick.theme.labelFont[fontLevel].family
            pixelSize: wQuick.theme.labelFont[fontLevel].pixelSize
            weight: wQuick.theme.labelFont[fontLevel].weight
            bold: wQuick.theme.labelFont[fontLevel].bold
            italic: wQuick.theme.labelFont[fontLevel].italic
        }
        color: wQuick.theme.textColor[levelLabel]
        verticalAlignment: Qt.AlignVCenter

        Label {
            id: placeholder
            anchors.fill: parent

            visible: parent.text.length == 0

            fontLevel: root.fontLevel
            font.pixelSize: root.font.pixelSize
            color: root.enabled ? wQuick.theme.placeholderColor[levelLabel] : parent.color
            verticalAlignment: parent.verticalAlignment
            horizontalAlignment: parent.horizontalAlignment

            text: "Enter..."
        }

        /** Slot **/
        Keys.onEscapePressed: {
            focus = false;
        }

        /** Forwarding Signals **/
        onAccepted: root.accepted()
        onEditingFinished: root.editingFinished()
        onTextEdited: root.textEdited()
        onTextChanged: root.textChanged()
    }

    /** Functions **/
    function clear() {
        return textInput.clear();
    }

    function copy() {
        return textInput.copy();
    }

    function cut() {
        return textInput.cut();
    }

    function deselect() {
        return textInput.deselect();
    }

    function ensureVisible(position) {
        return textInput.ensureVisible(position);
    }

    function getText(start, end) {
        return textInput.getText(start, end);
    }

    function insert(position, text) {
        return textInput.insert(position, text);
    }

    function isRightToLeft(start, end) {
        return textInput.isRightToLeft(start, end);
    }

    function moveCursorSelection(position, mode) {
        return textInput.moveCursorSelection(position, mode);
    }

    function paste() {
        return textInput.paste();
    }

    function positionAt(x, y, position) {
        return textInput.positionAt(x, y, position);
    }

    function positionToRectangle(pos) {
        return textInput.positionToRectangle(pos);
    }

    function redo() {
        return textInput.redo();
    }

    function remove(start, end) {
        return textInput.remove(start, end);
    }

    function select(start, end) {
        return textInput.select(start, end);
    }

    function selectAll() {
        return textInput.selectAll();
    }

    function selectWord() {
        return textInput.selectWord();
    }

    function undo() {
        return textInput.undo();
    }
}
