import QtQuick 2.12
import QtQuick.Controls 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Flickable {
    id: root

    property var plcIOItem
    property alias startStep: swStepStart.checked
    property alias stopMethod: cmbStopMethod.currentIndex
    property alias signalFwdMethod: cmbSignalFwdMethod.currentIndex
    property alias stopTargetsModel: gridIoChkStop.model
    property alias resultStopTargetsModel: gridIoChkStop.resultModel
    property alias signalFwdTargetsModel: gridIoChkSignalFwd.model
    property alias resultSignalFwdTargetsModel: gridIoChkSignalFwd.resultModel

    property alias displayByTag: swDisplayByTag.checked

    property alias gridStopTargets: gridIoChkStop
    property alias gridSignalFwdTargets: gridIoChkSignalFwd

    property int titleSize: 17
    property int fontSize: 15
    property int titleVAlignment: Qt.AlignVCenter
    property int titleHAlignment: Qt.AlignHCenter

    property int controlLevel: 2
    property int controlWidth: 185
    property int controlHeight: 33

    property alias spacing: layout.spacing

    clip: true
    contentWidth: width
    contentHeight: layout.height
    boundsBehavior: Flickable.StopAtBounds

    Column {
        id: layout
        width: parent.width
        spacing: 20

        // Step Name
        RowCompact {
            title: "Display Coils by Tag: "
            WeaQuick.Switch {
                id: swDisplayByTag
                anchors {
                    right: parent.right
                    rightMargin: parent.rightPadding
                }

                indicatorWidth: 45
                indicatorHeight: 22
                handleShape: WeaQuick.Handle.HandleShape.Circular
                handleSize: 16
                checked: true
            }
        }

        // Spacer
        ShineLine {
            width: parent.width
            color: "orange"
        }

        // Step Start Interrupt
        RowCompact {
            title: "Step Start Interrupt: "
            WeaQuick.Switch {
                id: swStepStart
                anchors {
                    right: parent.right
                    rightMargin: parent.rightPadding
                }

                indicatorWidth: 45
                indicatorHeight: 22
                handleShape: WeaQuick.Handle.HandleShape.Circular
                handleSize: 16
                checked: plcIOItem ? plcIOItem.hasStepStartInterrupt : false
            }
        }

        // Spacer
        Spacer {
            height: 2
        }

        // Stop Interrupts
        Title {
            title: "Stop Interrupt Targets"
        }

        // Stop Method
        RowCompact {
            title: "Stop Method: "
            CusComboBox {
                id: cmbStopMethod
                anchors {
                    right: parent.right
                    rightMargin: parent.rightPadding
                }

                width: controlWidth
                model: ["Latched Coil Reset", "Force Reset",]
                currentIndex: plcIOItem ? plcIOItem.stopMethod : 0
            }
        }

        IOsCheckBox {
            id: gridIoChkStop
            enabled: !swStepStart.checked
            width: parent.width
            // model: stopTargetsModel
            model: writeToStopTargets()
        }

        // Signal Forward Interrupts
        Title {
            title: "Signal Forward Interrupt Targets"
        }

        // Signal Forward Method
        RowCompact {
            title: "Forwarding Method: "
            CusComboBox {
                id: cmbSignalFwdMethod
                anchors {
                    right: parent.right
                    rightMargin: parent.rightPadding
                }

                width: controlWidth
                model: ["SET/RESET", "SET Only", "RESET Only", "Togglable"]
                currentIndex: plcIOItem ? plcIOItem.signalForwardMethod : 0
            }
        }

        IOsCheckBox {
            id: gridIoChkSignalFwd
            enabled: !swStepStart.checked
            width: parent.width
            // model: signalFwdTargetsModel
            model: writeToSignalFwdTargets()
        }

        // Spacer
        Spacer {
            height: 2
        }
    }
    onDisplayByTagChanged: {
        stopTargetsModel = writeToStopTargets();
        signalFwdTargetsModel = writeToSignalFwdTargets();
    }

    onPlcIOItemChanged: {
        gridIoChkStop.refreshSize();
        // gridIoChkStop.resetCheckedStates();

        gridIoChkSignalFwd.refreshSize();
        // gridIoChkSignalFwd.resetCheckedStates();

        stopTargetsModel = writeToStopTargets();
        signalFwdTargetsModel = writeToSignalFwdTargets();
    }

    // Objects & inline-components
    component Title: Column {

        property alias title: titleLabel.text
        property alias titleVAlignment: titleLabel.verticalAlignment
        property alias titleHAlignment: titleLabel.horizontalAlignment
        property alias titleLabel: titleLabel

        property alias shineColor: shineLine.color
        property alias shineWidth: shineLine.width
        property alias shineLine: shineLine

        width: parent.width
        height: controlHeight
        spacing: 7

        WeaQuick.Label {
            id: titleLabel
            width: parent.width
            height: parent.height
            font.pixelSize: root.titleSize
            verticalAlignment: root.titleVAlignment
            horizontalAlignment: root.titleHAlignment
        }

        ShineLine {
            id: shineLine
            width: parent.width
            color: "orange"
        }
    }

    component RowCompact: Item {

        property int padding: 0
        property int leftPadding: padding
        property int rightPadding: padding

        property alias title: titleLabelRow.text
        property alias titleVAlignment: titleLabelRow.verticalAlignment
        property alias titleHAlignment: titleLabelRow.horizontalAlignment
        property alias titleLabel: titleLabelRow

        width: parent.width
        height: controlHeight

        WeaQuick.Label {
            id: titleLabelRow
            // x: leftPadding
            anchors {
                left: parent.left
                leftMargin: parent.leftPadding
            }

            width: parent.width
            height: parent.height
            font.pixelSize: root.fontSize
            verticalAlignment: root.titleVAlignment
            horizontalAlignment: Qt.AlignLeft
        }
    }

    component Spacer: Item {
        width: 1
        height: 1
    }
}
