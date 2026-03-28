import QtQuick 2.12
import QtQuick.Layouts 1.12

Item {
    id: root

    property alias xAxisGauge: xAxisGaugePane
    property alias yAxisGauge: yAxisGaugePane

    RowLayout {
        anchors.fill: parent
        spacing: 5

        GaugePane {
            id: xAxisGaugePane
            Layout.fillHeight: true
            Layout.fillWidth: true

            // level: 0
            title: "Servo X-Axis"
        }

        GaugePane {
            id: yAxisGaugePane
            Layout.fillHeight: true
            Layout.fillWidth: true
            // level: 0

            rowLayout.layoutDirection: Qt.RightToLeft
            title: "Servo Y-Axis"
        }
    }
}
