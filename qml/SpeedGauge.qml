import QtQuick 2.12

ItemGauge {
    id: root

    title: "Servo Speed"
    editBoxGauge {
        decimals: 1
        from: 0.0
        to: 1500.0
        suffix: " rpm"
    }

    gaugeItem: CusCircularGauge {
        id: gauge
        anchors.fill: parent

        minimumValue: 0
        maximumValue: 1500

        labelStepSize: 150
        tickmarkStepSize: 75
        minimumValueAngle: -135
        maximumValueAngle: 135
    }
}
