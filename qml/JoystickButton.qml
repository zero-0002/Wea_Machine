import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

WeaQuick.Button {
    id: root

    enum Direction {
        Top = 0,
        Bottom,
        Left,
        Right,
        TopLeft = 4,
        TopRight,
        BottomLeft,
        BottomRight
    }

    property int direction: JoystickButton.Direction.Top
    property bool rotateOnlyIcon: true

    arrayBorderColor: ["orange", "orange", "orange", "orange", "orange", "orange"]
    border.width: 1
    flat: false
    level: 5
    iconColor: "orange"
    iconSize: 14

    icon: getIcon(direction)
    iconItem.rotation: rotateOnlyIcon ? getAngle() : 0
    rotation: rotateOnlyIcon ? 0 : getAngle()

    function getAngle() {
        return direction >= 4 ? -45 : 0;
    }

    function getIcon(direction) {
        switch (direction) {
        case JoystickButton.Direction.Top:
            return "angles-up";
        case JoystickButton.Direction.Bottom:
            return "angles-down";
        case JoystickButton.Direction.Left:
            return "angles-left";
        case JoystickButton.Direction.Right:
            return "angles-right";
        case JoystickButton.Direction.TopLeft:
            return "angles-up";
        case JoystickButton.Direction.TopRight:
            return "angles-right";
        case JoystickButton.Direction.BottomLeft:
            return "angles-left";
        case JoystickButton.Direction.BottomRight:
            return "angles-down";
        default:
            return "";
        }
    }
}
