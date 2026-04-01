import QtQuick 2.12

Rectangle {
    id: root

    /** Properties **/
    property bool flat: true
    property int level: 0

    /** Alias Properties **/
    property alias dropShadow: dropShadow
    property alias gradientOrientation: gradientItem.orientation

    /** Property Assignments **/
    width: 300
    height: 300
    radius: 7.5
    color: wQuick.theme.paneBackgroundColor[level]
    border.color: wQuick.theme.paneBorderColor[level]

    /** Shadows & Effects **/
    layer.enabled: true
    layer.effect: DropShadowBinder {
        dropShadowObject: dropShadow
    }

    DropShadowObject {
        id: dropShadow
        color: "#aa000000"
        samples: 4
        radius: 3
        verticalOffset: 4.0
        horizontalOffset: 2.0
        spread: .05
    }

    // Optional Gradient by default disabled (flat property)
    gradient: Gradient {
        id: gradientItem
        GradientStop {
            color: root.flat ? root.color : Qt.lighter(root.color, 1.75)
            position: 0.0
        }

        GradientStop {
            color: root.color
            position: 1.0
        }
    }
}
