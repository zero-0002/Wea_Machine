import QtQuick 2.12
import QtQuick.Extras 1.4

CircularGauge {
    id: root

    property bool accelerating: false

    // property alias minimumValue: minimumValueSlider.value
    // property alias maximumValue: maximumValueSlider.value
    // property alias minimumValueAngle: minimumAngleSlider.value
    // property alias maximumValueAngle: maximumAngleSlider.value
    property int size: 200
    property int labelStepSize: 100

    implicitWidth: size
    implicitHeight: size

    minimumValue: 0
    maximumValue: 1500

    value: accelerating ? maximumValue : 0
    style: CircularGaugeDarkStyle {
        id: darkStyle
        minimumValueAngle: -90
        maximumValueAngle: 180
        labelStepSize: root.labelStepSize
    }

    // This stops the styles being recreated when a new one is chosen.

    // Called to update the style after the user has edited a property.
    // Connections {
    //     target: darkStyle
    //     function onMinimumValueAngleChanged() {
    //         __style.minimumValueAngle = customizerItem.minimumValueAngle;
    //     }
    //     function onMaximumValueAngleChanged() {
    //         __style.maximumValueAngle = customizerItem.maximumValueAngle;
    //     }
    //     function onLabelStepSizeChanged() {
    //         __style.tickmarkStepSize = __style.labelStepSize = customizerItem.labelStepSize;
    //     }
    // }
    Behavior on value {
        NumberAnimation {
            easing.type: Easing.OutCubic
            duration: 6000
        }
    }
}
