import QtQuick 2.0

QtObject {
    id: root

    /** DropShadow Properties **/
    property bool cached: false
    property color color: "black"
    property real horizontalOffset: 0.0
    property real verticalOffset: 0.0
    property int radius: 0
    property int samples: 9
    property real spread: 0.0 // Property must be in range of 0.0~1.0
    property bool transparentBorder: true
}
