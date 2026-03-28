import QtQuick 2.12
import QtQuick.Controls 2.12 as Q

import com.wearily.WeaQuick 1.0

EditBox {
    id: root

    /** Properties **/
    property bool mirror: false // Swap incButton and decButton position
    property int indicatorLevel: (level + 1) % arrayBackgroundColor.length
    property bool indicatorTransparent: false // It makes indicators color as "transparent"
    property int indicatorTextSize: 10
    property bool iconVisible: true
    property int iconSize: 11 // PixelSize
    property int iconLevel: 0

    /** Alias Properties **/

    // Increase button
    property alias incLevel: incButton.level
    property alias incText: incButton.text
    property alias incTextLevel: incButton.levelLabel
    property alias incTextColor: incButton.textColor // RECOMMEND to use incIconLevel instead
    property alias incIcon: incButton.icon
    property alias incIconLevel: incButton.iconLevel
    property alias incIconColor: incButton.iconColor // RECOMMEND to use incIconLevel instead
    property alias incIconSize: incButton.iconSize
    property alias incIconMap: incButton.iconMap

    // Decrease button
    property alias decLevel: decButton.level
    property alias decText: decButton.text
    property alias decTextLevel: decButton.levelLabel
    property alias decTextColor: decButton.textColor // RECOMMEND to use incIconLevel instead
    property alias decIcon: decButton.icon
    property alias decIconLevel: decButton.iconLevel
    property alias decIconColor: decButton.iconColor // RECOMMEND to use decIconLevel instead
    property alias decIconSize: decButton.iconSize
    property alias decIconMap: decButton.iconMap

    property alias incIconItem: incButton.iconItem
    property alias decIconItem: decButton.iconItem

    /** Reimplementing Increase button Item **/
    up.indicator: Button {
        id: incButton
        parent: root
        anchors {
            top: parent.top
            bottom: parent.bottom
            // See states AnchorChanges for left/right anchors
            margins: 5
        }
        z: 3 // Should be upper than LineEdit
        level: indicatorLevel

        font.pixelSize: root.indicatorTextSize
        color: root.indicatorTransparent ? "transparent" : color
        icon: "plus-large"
        iconItem.visible: root.iconVisible
        iconSize: root.iconSize
        iconLevel: root.iconLevel

        radius: 2
        border.width: 0
        width: height

        /** Slot Properties **/
        onPressed: increase()
        onPressAndHold: _private.startTimer(true)
        onReleased: _private.stopTimer()
        onCanceled: _private.stopTimer()
    }

    /** Reimplementing Decrease button Item **/
    down.indicator: Button {
        id: decButton
        parent: root
        anchors {
            top: parent.top
            bottom: parent.bottom
            // See states AnchorChanges for left/right anchors
            margins: 5
        }
        z: 3 // Should be upper than LineEdit
        level: indicatorLevel

        font.pixelSize: root.indicatorTextSize
        color: root.indicatorTransparent ? "transparent" : color
        icon: "minus"
        iconItem.visible: root.iconVisible
        iconSize: root.iconSize
        iconLevel: root.iconLevel

        radius: 2
        border.width: 0
        width: height

        onPressed: decrease()
        onPressAndHold: _private.startTimer(false)
        onReleased: _private.stopTimer()
        onCanceled: _private.stopTimer()
    }

    /** States and Tranisitions **/
    StateGroup {

        states: [
            // Default Indicators Position
            State {
                name: "normal"
                when: !root.mirror

                // Increase Button to right
                AnchorChanges {
                    target: incButton
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        right: parent.right
                    }
                }

                // Increase Button to left
                AnchorChanges {
                    target: decButton
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        left: parent.left
                    }
                }

                // Also LineEdit component margin should swap
                PropertyChanges {
                    target: lineEdit
                    anchors {
                        leftMargin: decButton.width
                        rightMargin: incButton.width
                    }
                }
            },
            // Mirrrored Indicators Position
            State {
                name: "mirror"
                when: root.mirror

                // Increase Button to left
                AnchorChanges {
                    target: incButton
                    anchors {
                        left: parent.left
                    }
                }

                // Increase Button to right
                AnchorChanges {
                    target: decButton
                    anchors {
                        right: parent.right
                    }
                }

                // Also LineEdit component margin should swap
                PropertyChanges {
                    target: lineEdit
                    anchors {
                        leftMargin: incButton.width
                        rightMargin: decButton.width
                    }
                }
            }
        ]

        transitions: [
            //animate our anchor changes
            Transition {
                AnchorAnimation {
                    duration: 150
                }
            }
        ]
    }

    /** Private and Logics **/
    QtObject {
        id: _private

        /** Auto Increase & Decrease logic **/
        property bool direction: true // True === increase else decrease
        property Timer timerAutoModify: Timer {
            running: false
            repeat: true
            interval: 100
            onTriggered: {
                if (_private.direction) {
                    increase();
                } else {
                    decrease();
                }
            }
        }
        /** Private Functions **/
        function startTimer(direction) {
            _private.direction = direction;
            timerAutoModify.running = true;
        }

        function stopTimer() {
            timerAutoModify.running = false;
        }
    }
}
