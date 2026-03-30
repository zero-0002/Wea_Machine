import QtQuick 2.12
import QtQuick.Extras 1.4

CircularGauge {
    id: root

    property bool accelerating: false
    property int size: 200

    property real minimumValueAngle: -90
    property real maximumValueAngle: 180

    property real tickmarkStepSize: 10
    property real minorTickmarkCount: 10
    property real labelStepSize: 20

    implicitWidth: size
    implicitHeight: size

    minimumValue: 0
    maximumValue: 100

    value: accelerating ? maximumValue : 0
    style: CircularGaugeDarkStyle {
        id: darkStyle
        minimumValueAngle: root.minimumValueAngle
        maximumValueAngle: root.maximumValueAngle
        tickmarkStepSize: root.tickmarkStepSize
        minorTickmarkCount: root.minorTickmarkCount
        labelStepSize: root.labelStepSize
    }

    // This stops the styles being recreated when a new one is chosen.
    Behavior on value {
        NumberAnimation {
            easing.type: Easing.OutCubic
            duration: 6000
        }
    }
}
