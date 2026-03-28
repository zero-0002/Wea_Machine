import QtQuick 2.12

import com.wearily.WeaQuick 1.0 as WeaQuick

/*!
SearchEdit: Don't need to implement FilterProxyModel for simple searches.
use SearchEdit instead to have pure qml filtering
*/
LineEdit {
    id: root

    /** Enumeration **/
    enum ApplyFilterType {
        // onTextChanged
        AutoApply = 0,
        // by onAccepted
        SubmitApply = 1,
        // by User (means user need to call apply() or applyFilterFunction(text) manually)
        UserApply = 2
    }

    /** Properties **/
    property bool caseSensitive: false
    property bool inverted: false
    property int applyFilterType: SearchEdit.ApplyFilterType.AutoApply
    property var sourceData: []
    // Use this property on model or specify target
    readonly property var filteredData: applyFilterFunction(_private.text)

    /** Alias Properties **/
    property alias searchButtonClickable: searchButton.clickable
    property alias searchButtonVisible: searchButton.visible
    property alias searchButtonLevel: searchButton.level
    property alias searchButtonColor: searchButton.iconColor
    property alias searchButtonSize: searchButton.iconSize

    property alias searchButton: searchButton
    property alias verticalLine: verticalLine

    /** Virtual Functions (Reimpelment these depend on your filtering if needed **/
    property var applyFilterFunction: function (text) {
        return WeaQuick.WeaQuickUtils.arrayTextSearch(sourceData, text, caseSensitive, inverted);
    }

    /** Siganls **/
    signal searchSubmit

    /** Property assignment **/

    placeholderText: "Search..."

    textItem {
        anchors {
            leftMargin: searchButtonVisible ? verticalLine.x + verticalLine.width + 6 : 8
        }
    }

    // Search Button
    IconButton {
        id: searchButton

        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }

        level: root.levelLabel
        icon: "magnifying-glass"
        iconSize: root.font.pixelSize

        // Vertical Line
        Rectangle {
            id: verticalLine
            anchors {
                top: searchButton.top
                bottom: searchButton.bottom
                left: searchButton.right
                topMargin: 5
                bottomMargin: 5
            }
            visible: parent.visible
            width: 1

            color: root.border.color
            radius: width / 2
        }

        /** Signal Forwarding **/
        onClicked: searchSubmit()
    }

    /** Slots **/
    onTextChanged: {
        if (applyFilterType === SearchEdit.ApplyFilterType.AutoApply) {
            apply();
        }
    }

    onAccepted: {
        if (applyFilterType === SearchEdit.ApplyFilterType.SubmitApply) {
            apply();
        }
    }

    onSearchSubmit: {
        // NOTE: SearchButton always can be apply instead UserApply type and until its clickable
        apply();
    }

    /** Objects **/
    QtObject {
        id: _private
        property string text: ""
    }

    /** Functions **/
    function apply() {
        _private.text = text;
    }
}
