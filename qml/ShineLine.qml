import QtQuick 2.12
import QtGraphicalEffects 1.15

Rectangle {
    id: root

    property int orientation: Qt.Horizontal
    property int size: 0

    readonly property bool horizontal: orientation === Qt.Horizontal
    readonly property bool vertical: orientation === Qt.Vertical

    height: horizontal ? 1 : root.size
    width: horizontal ? root.size : 1

    layer.enabled: true
    layer.effect: DropShadow {
        color: root.color
        radius: 7
        spread: 0.4
        samples: 17
        verticalOffset: 0.0
        horizontalOffset: 0.0
    }

    gradient: Gradient {
        orientation: root.orientation
        GradientStop {
            position: 0.0
            color: "transparent"
        }
        GradientStop {
            position: 0.5
            color: root.color
        }
        GradientStop {
            position: 1.0
            color: "transparent"
        }
    }
}
