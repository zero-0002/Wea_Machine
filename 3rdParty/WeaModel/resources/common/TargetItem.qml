import QtQuick 2.15
Item {
    id: target
    property real centerX
    property real centerY
    property real azimuth
    property real elevation
    property real range
    property bool selected: false

    width: 10
    height: 10
    x: centerX + range * Math.cos(azimuth * Math.PI / 180) - width / 2
    y: centerY + range * Math.sin(azimuth * Math.PI / 180) - height/ 2

    Rectangle {
        anchors.fill: parent
        color: selected ? "yellow" : "red"
        radius: width / 2
    }

}
