import QtQuick 2.12

SmoothRectangle {
    id: root

    /** Enumerations **/
    enum HandleShape {
        Square = 0,
        Circular
    }

    /** Default WeaQuick Properties **/
    property var arrayHandleColor: wQuick.theme.sliderHandleColor
    property int level: 0

	/** Default Qt Handle Properties **/
    property bool handleHasFocus: false
    property bool handlePressed: false
    property bool handleHovered: false

    /** Default Property **/
    property bool motion: true // Scale Motion active
    property bool flat: false // Flat color or gradient
	property int shape: Handle.HandleShape.Square
    property real bigScale: 1.35
    property real squareRadius: 3
    property real size: 10 // By default shape is square (width === height)

    width: root.size
    height: root.size

    color: arrayHandleColor[level]
	radius: shape === Handle.HandleShape.Square ? root.squareRadius : width / 2
    scale: motion ? handlePressed ? bigScale : 1.0 : 1.0

    /** SmoothRectangle Properties **/
    disableColor: "gray"
    scaleAnimation.duration: 250

    // Optional Gradient
    gradient: Gradient {
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
