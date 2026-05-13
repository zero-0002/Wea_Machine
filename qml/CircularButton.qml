import QtQuick 2.12

IconicButton {
    id: root

    radius: width / 2
    colorAnimation.duration: 0

    arrayHoveredBackgroundColor: checked ? arraySelectedBackgroundColor : arrayBackgroundColor
    arrayBorderColor: ["orange"]
    arrayHoveredBorderColor: checked ? arraySelectedBorderColor : arrayBorderColor
    arraySelectedBorderColor: checked ? ["green"] : arrayBorderColor

    // color: getColor()
    // border.color: getColor()
    iconColor: enabled ? getColor() : "darkGray"

    icon: checked ? "pause" : "play"

    function getColor() {
        return checked ? "green" : "orange";
    }
}
