import QtQuick 2.12
import QtQuick.Controls 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

CusPopup {
    id: root

    // REQUIRED
    property alias plcIOItem: interruptConfigView.plcIOItem
    property alias displayByTag: interruptConfigView.displayByTag
    property alias startStep: interruptConfigView.startStep
    property alias stopTargetsModel: interruptConfigView.stopTargetsModel
    property alias resultStopTargetsModel: interruptConfigView.resultStopTargetsModel
    property alias signalFwdTargetsModel: interruptConfigView.signalFwdTargetsModel
    property alias resultSignalFwdTargetsModel: interruptConfigView.resultSignalFwdTargetsModel

    property int levelButton: 5

    property alias cancelButton: cancelButton
    property alias okButton: okButton

    property alias buttonsLayout: buttonsLayout

    signal ok
    signal cancel

    topPadding: 15
    title: "%1 Interrupt Configuration".arg(plcIOItem ? plcIOItem.name : "")
    width: 500
    height: 600
    closePolicy: Popup.NoAutoClose

    popUpDelegate: Item {
        anchors.fill: parent

        Item {
            id: mainContent
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: buttonsLayout.top
                margins: 20
            }

            InterruptConfigView {
                id: interruptConfigView
                anchors.fill: parent
            }
        }

        // Buttons
        Row {
            id: buttonsLayout
            anchors {
                bottom: parent.bottom
                right: parent.right
                rightMargin: 20
            }
            spacing: 10
            layoutDirection: Qt.RightToLeft

            WeaQuick.Button {
                id: cancelButton
                level: root.levelButton
                flat: false
                text: "Cancel"
                border.width: 1
                onClicked: {
                    close();
                    cancel();
                }
            }

            WeaQuick.Button {
                id: okButton
                level: root.levelButton
                flat: false
                text: "Ok"
                border.width: 1
                onClicked: {
                    ok();
                    close();
                }
            }
        }
    }
    /** Slots **/
    // onAboutToShow: {
    //     interruptConfigView.stopTargetsModel = [];
    //     interruptConfigView.signalFwdTargetsModel = [];
    // }
    onOpened: {
        /*        interruptConfigView.gridStopTargets.refreshSize();
        interruptConfigView.gridStopTargets.resetCheckedStates();

        interruptConfigView.gridSignalFwdTargets.refreshSize();
        interruptConfigView.gridSignalFwdTargets.resetCheckedStates();

        interruptConfigView.stopTargetsModel = writeToStopTargets();
        interruptConfigView.signalFwdTargetsModel = writeToSignalFwdTargets()*/;
    }

    onOk: {
        writeBackModels();
    }

    // /** Functions **/
    function writeToStopTargets() {
        var res = [];
        if (plcIOItem) {
            var outputs = _plcIOModel.outputs;
            for (var i = 0; i < outputs.length; ++i) {
                var plcItem = outputs[i];
                var enb = i !== plcIOItem.ioIndex || plcIOItem.type === 0; // 0 type means InputType
                var chkd = enb && plcIOItem.containsAtStopTargets(i);
                res.push({
                             name: displayByTag ? plcItem.displayName : plcItem.name,
                             checked: chkd,
                             enabled: enb
                         });
            }
        }
        return res;
    }
    function writeToSignalFwdTargets() {
        var res = [];
        if (plcIOItem) {
            var outputs = _plcIOModel.outputs;
            for (var i = 0; i < outputs.length; ++i) {
                var plcItem = outputs[i];
                var enb = i !== plcIOItem.ioIndex || plcIOItem.type
                        === 0; // && plcItem.containsAtSignalFwdTargets(plcIOItem.ioIndex);


                var chkd = enb && plcIOItem.containsAtSignalFwdTargets(i);
                res.push({
                             name: displayByTag ? plcItem.displayName : plcItem.name,
                             checked: chkd,
                             enabled: enb
                         });
            }
        }
        return res;
    }

    function writeBackModels() {
        if (!plcIOItem || plcIOItem === undefined || plcIOItem === null) {
            console.warn("Invalid plcIOItem value for InterruptPopup!");
            return;
        }
        console.log("Writing interrupts to plc...");

        // Step Start
        plcIOItem.hasStepStartInterrupt = interruptConfigView.startStep;

        // Stop Targets
        plcIOItem.stopInterruptTargets = interruptConfigView.resultStopTargetsModel;

        // Signal Fwd Targets
        plcIOItem.signalForwardInterruptTargets = interruptConfigView.resultSignalFwdTargetsModel;

        // Stop Method
        plcIOItem.stopMethod = interruptConfigView.stopMethod;

        // Signal Forward Method
        plcIOItem.signalForwardMethod = interruptConfigView.signalFwdMethod;
    }
}
