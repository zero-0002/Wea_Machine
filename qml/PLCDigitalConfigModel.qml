import QtQuick 2.12

Column {
    id: root

    property bool isOutput: false
    property alias model: repeater.model

    spacing: 10

    Repeater {
        id: repeater
        model: isOutput ? _plcIOModel.outputs : _plcIOModel.inputs
        delegate: PLCSettingDelegateConfig {
            width: parent.width
            // digitalName: (isOutput ? "Y%1" : "X%1").arg(index)
            pcIndicator.active: isOutput ? modelData.coilActive : modelData.active
            blinkEditBox.visible: isOutput
            modelItem: modelData
            onWriteRequest: {
                modelData.writeToSettings();
            }

            // plcIndicator {
            //     active: index % 2 === 0
            //     blinking: true
            //     blinkInterval: 1000
            // }
            // pcIndicator {
            //     active: index % 2 === 0
            //     blinking: true
            //     blinkInterval: 2000
            // }
        }
    }
}
