import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

CusPopup {
    id: root

    enum ConfigMethod {
        Insert = 0,
        Edit
    }

    property int configMethod: StepPopup.ConfigMethod.Insert
    property int currentSelectedIndex: -1

    property int levelButton: 5

    property alias cancelButton: cancelButton
    property alias okButton: okButton

    property alias buttonsLayout: buttonsLayout

    signal ok
    signal cancel

    topPadding: 15
    title: "Step Configuration"
    width: 550
    height: 700

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

            StepConfigView {
                id: stepConfigView
                anchors.fill: parent
                currentStepIndex: root.currentSelectedIndex
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
                    close();
                    ok();
                }
            }
        }
    }

    onOk: {
        applyStepIntoModel();
    }

    /** Functions **/
    function applyStepIntoModel() {
        switch (configMethod) {
        case StepPopup.ConfigMethod.Insert:
            return appendStepIntoModel();
        case StepPopup.ConfigMethod.Edit:
            return editStepIntoModel(currentSelectedIndex);
        default:
            break;
        }
    }

    function appendStepIntoModel() {
        stepModel.addItem(stepConfigView.getCurrentStepValues());
    }

    function editStepIntoModel(index) {
        stepModel.editItem(index, stepConfigView.getCurrentStepValues());
    }
}
