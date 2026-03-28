import QtQuick 2.12

ItemGauge {
    id: root

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
    }
}
