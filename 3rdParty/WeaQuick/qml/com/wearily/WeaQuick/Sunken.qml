import QtQuick 2.12

Item {
    id: root

    /** WeaQuick Default Properties **/
    property var arrayOuterColor: wQuick.theme.sunkenOuterColor
    property var arrayInnerColor: wQuick.theme.sunkenInnerColor

    property int level: 0

    /** Sunken Properties **/
    property int radius: 10
    property int borderWidth: 1
    property int outerMargin: 3

    /** Alias Properties **/
    property alias backgroundColor: background.color
    property alias outerColor: outer.color
    property alias innerColor: inner.color

    property alias backgroundGradient: background.gradient
    property alias outerGradient: outer.gradient
    property alias innerGradient: inner.gradient

    property alias backgroundRadius: background.radius
    property alias outerRadius: outer.radius
    property alias innerRadius: inner.radius

    property alias background: background
    property alias outer: outer
    property alias inner: inner

    /** Delegate Properties **/
    property alias backgroundDelegate: backgroundDelegate.data
    property alias outerDelegate: outerDelegate.data
    property alias innerDelegate: innerDelegate.data
    property alias overlayDelegate: overlayDelegate.data

    width: 70
    height: 45

    /// NOTE: Components ordering are important! else we can use `z` property to handle.

    SmoothRectangle {
        id: background

        width: root.width
        height: root.height

        radius: root.radius
        color: inner.color
        gradient: Gradient {

            GradientStop {
                color: Qt.darker(background.color, 2.0)
                position: 0.0
            }

            GradientStop {
                color: Qt.lighter(background.color, 1.2)
                position: 1.0
            }
        }
    }

    // Reimplementable Item referer `background` component
    Item {
        id: backgroundDelegate
        anchors.fill: parent
    }

    SmoothRectangle {
        id: outer

        anchors {
            fill: parent
            margins: outerMargin
        }

        radius: root.radius
        color: arrayOuterColor[level]

        // Reimplementable Item referer `outer` component
        Item {
            id: outerDelegate
            anchors.fill: parent
        }

        SmoothRectangle {
            id: inner

            anchors {
                fill: parent
                margins: borderWidth
            }

            radius: root.radius
            color: arrayInnerColor[level]
            gradient: Gradient {

                GradientStop {
                    color: Qt.lighter(inner.color, 1.15)
                    position: 0.0
                }

                GradientStop {
                    color: Qt.darker(inner.color, 1.4)
                    position: 1.0
                }
            }

            // Reimplementable Item referer `inner` component
            Item {
                id: innerDelegate
                anchors.fill: parent
            }
        }
    }

    // Reimplementable Overlay Item
    Item {
        id: overlayDelegate
        anchors.fill: parent
    }
}
