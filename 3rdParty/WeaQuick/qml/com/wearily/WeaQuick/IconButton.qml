import QtQuick 2.12

import com.wearily.WeaQuick 1.0 as WeaQuick

/** IconButton: Transparent button which only has FontIcon with dropShadow effects at IconFont **/
WeaQuick.Button {
    id: root

    /** Properties **/
    property alias clickable: root.mouseArea.enabled

    width: height // Square

    color: "transparent"
    border.color: "transparent"
    border.width: 0

    icon: "play"
    iconLevel: level
    mouseArea.enabled: true // Required for accessing the clickable alias property

    // Applying DropShadow Animation for default/hovered/pressed icon
    iconItem.iconItem {
        layer.enabled: true

        dropShadow {
            color: iconColor
            radius: !mouseArea.containsMouse ? 1 : 10
            samples: 17
            spread: mouseArea.containsMouse ? mouseArea.containsPress ? 0.3 : 0.15 : 0.0
        }
    }

    /** Aniamtions **/
    Behavior on iconItem.iconItem.dropShadow.radius {
        NumberAnimation {
            duration: 150
        }
    }

    Behavior on iconItem.iconItem.dropShadow.spread {
        NumberAnimation {
            duration: 150
        }
    }

    Behavior on iconItem.color {

        ColorAnimation {
            duration: 150
        }
    }
}
