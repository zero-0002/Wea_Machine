import QtQuick 2.12

ItemGauge {
    id: root

    property alias gauge: gauge

    layoutSpacing: 15
    title: "Servo Torque"
    editBoxGauge {
        decimals: 0
        from: 0
        to: 100
        suffix: " %"
    }

    gaugeItem: CusCircularGauge {
        id: gauge
        anchors.fill: parent

        labelStepSize: 10
        tickmarkStepSize: 20
        minimumValueAngle: -135
        maximumValueAngle: 65
    }
}
