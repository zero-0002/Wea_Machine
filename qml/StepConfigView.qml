import QtQuick 2.12
import QtQuick.Controls 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Flickable {
    id: root

    property int currentStepIndex: -1
    property var currentStepItem: isIndexValid() ? stepModel.getItem(currentStepIndex) : undefined

    property int titleSize: 17
    property int fontSize: 15
    property int titleVAlignment: Qt.AlignVCenter
    property int titleHAlignment: Qt.AlignHCenter

    property int controlLevel: 2
    property int controlWidth: 150
    property int controlHeight: 33

    property alias displayByTag: swDisplayByTag.checked

    property alias spacing: layout.spacing

    property alias gridIoCheckBox: gridIoCheckBox

    property alias stepNameEdit: stepName
    property alias bitwiseEnableSwitch: swBitwiseCondtion
    property alias bitwiseMethodBox: conditionComboBox
    property alias bitwiseCheckBoxes: gridIoCheckBox

    property alias servoXStep: servoXStep
    property alias servoYStep: servoYStep

    property alias outputCoilsStep: coilsStep

    property alias delayEditBox: delayEditBox

    clip: true
    contentWidth: width
    contentHeight: layout.height
    boundsBehavior: Flickable.StopAtBounds

    Column {
        id: layout
        width: parent.width
        spacing: 20

        // Step Name
        WeaQuick.LineEdit {
            id: stepName

            width: controlWidth
            height: controlHeight
            level: controlLevel
            font.pixelSize: fontSize - 1
            flat: false

            placeholderText: "Step Name"
            text: isItemValid() ? currentStepItem.name : ""
        }

        RowCompact {
            title: "Display by Tag: "
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

        // Condition To Start
        Title {
            title: "Condition to Start"
        }

        RowCompact {
            title: "Bitwise Condition Enable: "
            WeaQuick.Switch {
                id: swBitwiseCondtion
                anchors {
                    right: parent.right
                    rightMargin: parent.rightPadding
                }

                indicatorWidth: 45
                indicatorHeight: 22
                handleShape: WeaQuick.Handle.HandleShape.Circular
                handleSize: 16
                checked: isItemValid() ? currentStepItem.bitwiseEnable : false
            }
        }

        RowCompact {
            title: "Bitwise Condition: "
            CusComboBox {
                id: conditionComboBox
                anchors {
                    right: parent.right
                    rightMargin: parent.rightPadding
                }
                enabled: swBitwiseCondtion.checked
                width: controlWidth
                model: ["AND", "OR", "XOR"]

                currentIndex: isItemValid() ? currentStepItem.bitwiseMethod : 0
            }
        }

        IOsCheckBox {
            id: gridIoCheckBox
            width: parent.width
            enabled: swBitwiseCondtion.checked
            model: {
                var result = [];

                const plciomodel = _plcIOModel;
                const stepitem = root.currentStepItem;
                const len = plciomodel.count;
                for (var i = 0; i < len; ++i) {
                    const role = displayByTag ? 259 : 258; // DisplayNameRole and NameRole
                    const itemName = plciomodel.data(plciomodel.index(i, 0), role);
                    const isChecked = isItemValid() ? stepitem.containsConditionBits(i) : false;
                    result.push({
                                    name: itemName,
                                    checked: isChecked && enabled,
                                    enabled: enabled
                                });
                }
                return result;
            }

            onModelChanged: {
                refreshSize();
            }
        }

        // X-Axis Servo
        Title {
            title: "X-Axis Servo"
        }

        ServoStep {
            id: servoXStep

            width: parent.width
            spacing: layout.spacing

            fontSize: root.fontSize
            titleVAlignment: root.titleVAlignment
            titleHAlignment: root.titleHAlignment
            controlLevel: root.controlLevel
            controlWidth: root.controlWidth
            controlHeight: root.controlHeight

            positionActiveSwitch.checked: isItemValid() ? currentStepItem.xPosActive : false
            servoOnSwitch.checked: isItemValid() ? currentStepItem.xServoOn : true
            homingSwitch.checked: isItemValid() ? currentStepItem.xServoHome : false
            positionValue: isItemValid() ? currentStepItem.xServoPos : 0
            speedValue: isItemValid() ? currentStepItem.xServoSpeed : 250
            accValue: isItemValid() ? currentStepItem.xServoAcc : 200
            decValue: isItemValid() ? currentStepItem.xServoDec : 200
        }

        // X-Axis Servo
        Title {
            title: "Y-Axis Servo"
        }

        ServoStep {
            id: servoYStep

            width: parent.width
            spacing: layout.spacing

            fontSize: root.fontSize
            titleVAlignment: root.titleVAlignment
            titleHAlignment: root.titleHAlignment
            controlLevel: root.controlLevel
            controlWidth: root.controlWidth
            controlHeight: root.controlHeight

            positionActiveSwitch.checked: isItemValid() ? currentStepItem.yPosActive : false
            servoOnSwitch.checked: isItemValid() ? currentStepItem.yServoOn : true
            homingSwitch.checked: isItemValid() ? currentStepItem.yServoHome : false
            positionValue: isItemValid() ? currentStepItem.yServoPos : 0
            speedValue: isItemValid() ? currentStepItem.yServoSpeed : 250
            accValue: isItemValid() ? currentStepItem.yServoAcc : 200
            decValue: isItemValid() ? currentStepItem.yServoDec : 200
        }

        // Coils
        Title {
            title: "Coils Set/Reset"
        }

        CoilsStep {
            id: coilsStep

            width: parent.width
            spacing: layout.spacing

            fontSize: root.fontSize
            titleVAlignment: root.titleVAlignment
            titleHAlignment: root.titleHAlignment
            controlLevel: root.controlLevel
            controlWidth: root.controlWidth
            controlHeight: root.controlHeight

            displayByTag: swDisplayByTag.checked
            model: {
                var result = [];

                const plcoutputs = _plcIOModel.outputs;
                var stepitem = root.currentStepItem;
                const len = plcoutputs.length;
                for (var i = 0; i < len; ++i) {
                    const output = plcoutputs[i];
                    const itemName = displayByTag ? output.displayName : output.name; // DisplayNameRole and NameRole
                    const isChecked = isItemValid() ? stepitem.containsPlcOutput(i) : false;
                    result.push({
                                    name: itemName,
                                    checked: isChecked && enabled,
                                    enabled: enabled
                                });
                }
                return result;
            }
        }

        // Spacer
        ShineLine {
            width: parent.width
            color: "orange"
        }

        // Delay
        RowCompact {
            title: "Wait for next step:"
            DelayEditBox {
                id: delayEditBox
                anchors {
                    right: parent.right
                    rightMargin: parent.rightPadding
                }
                width: controlWidth
                height: controlHeight
                level: controlLevel

                value: isItemValid() ? currentStepItem.delay : 0.0
                spinBox.value: isItemValid() ? doubleToInt(currentStepItem.delay) : 0.0
            }
        }

        // Spacer
        Spacer {
            height: 2
        }
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

    /** Functions **/
    function getCurrentStepValues() {
        return {
            "id": stepModel.count,
            "name": stepConfigView.stepNameEdit.text,
            "bitwiseenable": stepConfigView.bitwiseEnableSwitch.checked,
            "bitwisemethod": stepConfigView.bitwiseMethodBox.currentIndex,
            "xposactive": stepConfigView.servoXStep.positionActiveSwitch.checked,
            "xservoon": stepConfigView.servoXStep.servoOnSwitch.checked,
            "xservohome": stepConfigView.servoXStep.homingSwitch.checked,
            "xservopos": stepConfigView.servoXStep.positionEditBox.value,
            "xservospd": stepConfigView.servoXStep.speedEditBox.value,
            "xservoacc": stepConfigView.servoXStep.accelerationEditBox.value,
            "xservodec": stepConfigView.servoXStep.decelerationEditBox.value,
            "yposactive": stepConfigView.servoYStep.positionActiveSwitch.checked,
            "yservoon": stepConfigView.servoYStep.servoOnSwitch.checked,
            "yservohome": stepConfigView.servoYStep.homingSwitch.checked,
            "yservopos": stepConfigView.servoYStep.positionEditBox.value,
            "yservospd": stepConfigView.servoYStep.speedEditBox.value,
            "yservoacc": stepConfigView.servoYStep.accelerationEditBox.value,
            "yservodec": stepConfigView.servoYStep.decelerationEditBox.value,
            "plcoutputtargets": stepConfigView.outputCoilsStep.resultModel,
            "conditionbits": stepConfigView.bitwiseCheckBoxes.resultModel,
            "delay": stepConfigView.delayEditBox.value
        };
    }

    function isIndexValid() {
        const cnt = stepModel.count;
        return currentStepIndex >= 0 && currentStepIndex < cnt;
    }

    function isItemValid() {
        return currentStepItem !== undefined && currentStepItem !== null;
    }
}
