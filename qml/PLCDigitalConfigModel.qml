import QtQuick 2.12

Column {
    id: root

    property bool isOutput: false
    property alias model: repeater.model

    spacing: 10

    Repeater {
        id: repeater
        model: 28
        delegate: PLCDelayConfig {
            width: parent.width
            digitalName: (isOutput ? "Y%1" : "X%1").arg(index)
            plcIndicator {
                active: index % 2 === 0
                blinking: true
                blinkInterval: 1000
            }
            pcIndicator {
                active: index % 2 === 0
                blinking: true
                blinkInterval: 2000
            }
        }
    }
}
