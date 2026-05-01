import QtQuick 2.12
import QtQuick.Controls 2.12
import Qt.labs.settings 1.1
import Qt.labs.platform 1.1
import com.wearily.WeaQuick 1.0 as WeaQuick
import CustomItems 1.0

Item {
    id: root

    property var pageComponents: [compHomePage, compManualPage, compSettingsPage]
    property var pageItems: [homePage, manualPage, settingsPage]
    property var popUps: [comPopup]

    property real elapsed: 0.0

    // Top Header
    AppHeader {
        id: appHeader
        anchors {
            top: parent.top
            right: parent.right
            left: parent.left
            topMargin: 5
        }

        onPageChanged: {
            if (swipeView.currentIndex !== index) {
                swipeView.currentIndex = index;
            }
        }

        // onPageChanged: {
        //     elapsed = Date.now();
        // }

        onOpenPopUp: {
            comPopup.open();
        }

        ShineLine {
            id: headerLine
            x: 20
            y: parent.height + 4
            width: parent.width - x * 2
            color: "orange"
        }
    }

    // Pages View
    Component {
        id: compHomePage
        // id: homePage
        HomePage {}
    }

    Component {
        id: compManualPage

        // id: manualPage
        ManualPage {}
    }

    Component {
        id: compSettingsPage

        // id: settingsPage
        SettingsPage {}
    }

    // Loader {
    //     id: pageLoader

    //     anchors {
    //         top: appHeader.bottom
    //         right: parent.right
    //         left: parent.left
    //         bottom: parent.bottom
    //         topMargin: headerLine.height + 5
    //     }
    //     sourceComponent: pageComponents[appHeader.pageButtonsItem.currentIndex]
    //     onLoaded: {
    //         console.log("PageLoaded: ", Date.now() - elapsed);
    //     }
    // }

    SwipeView {
        id: swipeView
        anchors {
            top: appHeader.bottom
            right: parent.right
            left: parent.left
            bottom: parent.bottom
            topMargin: headerLine.height + 5
        }

        onCurrentIndexChanged: {
            if (currentIndex !== appHeader.pageButtonsItem.currentIndex) {
                appHeader.pageButtonsItem.currentIndex = currentIndex;
            }
        }

        HomePage {
            id: homePage
        }

        ManualPage {
            id: manualPage
        }
        SettingsPage {
            id: settingsPage
        }
    }

    // Models
    StepModel {
        id: stepModel

        enabled: true // plcDevice.enabled && servoXDevice.enabled && servoYDevice.enabled
        plcModel: _plcIOModel
        xServoDevice: servoXDevice
        yServoDevice: servoYDevice

        steps: [step0, step2, stepExtruder, step40, step41, step3, step4290, step42, step43, step3_5, step44, step45, step46,
            step47, step5, step6, step7, step8, step9, step10, step11, step12] //, step2, step3, step4]
    }

    StepItem {
        id: step0
        name: "Boot-up"
        plcOutputTargets: [0, 1, 3, 6]
        delay: 5500
    }

    StepItem {
        id: step1
        name: "Homing Step"

        xPosActive: true
        xServoOn: true
        xServoHome: true

        yPosActive: true
        yServoOn: true
        yServoHome: true

        plcOutputTargets: [0, 1]
        delay: 500
    }

    StepItem {
        id: step2
        name: "POS-Blowpin"

        xPosActive: true
        xServoOn: true
        xServoPos: 13209423

        yPosActive: true
        yServoOn: true
        yServoPos: 42534326

        plcOutputTargets: [0, 1]
        delay: 300
    }
    StepItem {
        id: stepExtruder
        name: "Extruder BlowPin-45"

        plcOutputTargets: [0, 1, 7, 9]
        delay: 14000
    }

    StepItem {
        id: step40
        name: "Curve 0"

        xPosActive: true
        xServoOn: true
        xServoPos: 13550962

        yPosActive: true
        yServoOn: true
        yServoPos: 39724842

        plcOutputTargets: [0, 1, 7, 9]
        delay: 1000
    }

    StepItem {
        id: step41
        name: "Curve 1"

        xPosActive: true
        xServoOn: true
        xServoPos: 13550962

        yPosActive: true
        yServoOn: true
        yServoPos: 37243268

        plcOutputTargets: [0, 1, 7, 9]
        delay: 1000
    }

    StepItem {
        id: step3
        name: "Blowpin 90"

        plcOutputTargets: [0, 1, 9]
        delay: 400
    }

    // StepItem {
    //     id: step4
    //     name: "Blowpin 90"

    //     plcOutputTargets: [0, 1, 7]
    //     delay: 300
    // }

    StepItem {
        id: step4290
        name: "Curve 2-90"

        xPosActive: true
        xServoOn: true
        xServoPos: 13889935

        yPosActive: true
        yServoOn: true
        yServoPos: 33639990

        plcOutputTargets: [0, 1, 9]
        delay: 300
    }

    StepItem {
        id: step42
        name: "Curve 2"

        xPosActive: true
        xServoOn: true
        xServoPos: 14350766

        yPosActive: true
        yServoOn: true
        yServoPos: 17001242

        plcOutputTargets: [0, 1, 9]
        delay: 300
    }

    StepItem {
        id: step43
        name: "Curve 3"

        xPosActive: true
        xServoOn: true
        xServoPos: 15225956

        yPosActive: true
        yServoOn: true
        yServoPos: 7817329

        plcOutputTargets: [0, 1, 9]
        delay: 300
    }

    StepItem {
        id: step3_5
        name: "Curve 3.5"

        xPosActive: true
        xServoOn: true
        xServoPos: 15225996

        yPosActive: true
        yServoOn: true
        yServoPos: 11817329

        plcOutputTargets: [0, 1, 9]
        delay: 300
    }

    StepItem {
        id: step44
        name: "Curve 4"

        xPosActive: true
        xServoOn: true
        xServoPos: 27703422

        yPosActive: true
        yServoOn: true
        yServoPos: 9258841

        plcOutputTargets: [0, 1, 9]
        delay: 300
    }

    StepItem {
        id: step45
        name: "Curve 5"

        xPosActive: true
        xServoOn: true
        xServoPos: 28942848

        yPosActive: true
        yServoOn: true
        yServoPos: 16258841

        plcOutputTargets: [0, 1, 9]
        delay: 300
    }

    StepItem {
        id: step46
        name: "Curve 6"

        xPosActive: true
        xServoOn: true
        xServoPos: 29628150

        yPosActive: true
        yServoOn: true
        yServoPos: 10571860

        plcOutputTargets: [0, 1, 9]
        delay: 1100
    }

    StepItem {
        id: step47
        name: "Curve 7"

        xPosActive: true
        xServoOn: true
        xServoPos: 29628150

        yPosActive: true
        yServoOn: true
        yServoPos: 595070

        plcOutputTargets: [0, 1, 9]
        delay: 1000
    }

    // StepItem {
    //     id: step48
    //     name: "Curve 8"

    //     xPosActive: true
    //     xServoOn: true
    //     xServoPos: 29213316

    //     yPosActive: true
    //     yServoOn: true
    //     yServoPos: 7886289

    //     plcOutputTargets: [0, 1, 7]
    //     delay: 300
    // }

    // StepItem {
    //     id: step49
    //     name: "Curve 9"

    //     xPosActive:
    //     xServoOn: true
    //     xServoPos: 29213316

    //     yPosActive: true
    //     yServoOn: true
    //     yServoPos: -3509058

    //     plcOutputTargets: [0, 1, 7]
    //     delay: 300
    // }

    StepItem {
        id: step5
        name: "Extruder OFF"

        plcOutputTargets: [0, 1]
        delay: 3000
    }

    StepItem {
        id: step6
        name: "Cutter Active"
        plcOutputTargets: [0, 1, 8]
        delay: 2000
    }

    StepItem {
        id: step7
        name: "Cutter Deactive"
        plcOutputTargets: [0, 1]
        delay: 750
    }

    StepItem {
        id: step8
        name: "POS-Pres"

        xPosActive: true
        xServoOn: true
        xServoPos: 45359434

        yPosActive: true
        yServoOn: true
        yServoPos: 34783363

        plcOutputTargets: [0, 1]
        delay: 700
    }

    StepItem {
        id: step9
        name: "Z2-DOWN"

        plcOutputTargets: [0, 1, 2]
        delay: 10000
    }

    StepItem {
        id: step10
        name: "Blow"

        plcOutputTargets: [0, 1, 5]
        delay: 10000
    }

    StepItem {
        id: step11

        name: "Penet"

        plcOutputTargets: [0, 1, 6]
        delay: 2500
    }

    StepItem {
        id: step12
        name: "Z2-UP"

        plcOutputTargets: [0, 1, 6, 3]
        delay: 6500
    }

    // StepItem {
    //     id: step13
    //     name: "POS-0"

    //     xPosActive: true
    //     xServoOn: true
    //     xServoPos: 0

    //     yPosActive: true
    //     yServoOn: true
    //     yServoPos: 0

    //     plcOutputTargets: [0, 1, 7, 8]
    //     delay: 2000
    // }

    // StepItem {
    //     id: step2
    //     name: "Step 2"
    //     plcOutputTargets: []
    //     delay: 1000
    // }

    // StepItem {
    //     id: step3
    //     name: "Step 3"
    //     plcOutputTargets: [0, 3]
    //     delay: 3000
    // }
    // StepItem {
    //     id: step4
    //     name: "Step 4"
    //     plcOutputTargets: []
    //     delay: 0
    // }

    // Communications
    ModbusCom {
        id: plcModbusCom
        objectID: 400
        objectName: "PLCCOM"
        serialConn: comPopup.plcSerialConnection
        threaded: false
        devices: [plcDevice]
    }

    ModbusCom {
        id: servoModbusCom
        objectID: 300
        objectName: "SCOM"
        serialConn: comPopup.servoSerialConnection
        threaded: false
        devices: [servoXDevice, servoYDevice]
        refreshInterval: 300
    }

    /** Modbus Devices **/
    PlcModbusDevice {
        id: plcDevice
        objectName: "DVP28SA2"
        slaveAddress: 2
        onEnabledChanged: {
            if (comPopup.plcSerialConnection.connected) {
                plcDevice.syncCoils();
            }
        }
    }

    ServoModbusDevice {
        id: servoYDevice
        objectName: "Servo-Y"
        slaveAddress: 3
    }

    ServoModbusDevice {
        id: servoXDevice
        objectName: "Servo-X"
        slaveAddress: 2
    }

    // Popups
    LoginPopup {
        id: loginPopup
    }

    // Config Popup
    StepPopup {
        id: stepPopup
    }

    InterruptPopup {
        id: interruptPopup
    }

    ComPopup {
        id: comPopup

        /** Slots **/
        onOpened: {
            serialGlobal.refreshPorts();
        }

        servoSerialConfig.onOpenConnection: {
            servoModbusCom.openPort();
        }
        servoSerialConfig.onCloseConnection: {
            servoModbusCom.closePort();
        }

        plcSerialConfig.onOpenConnection: {
            plcModbusCom.openPort();
        }
        plcSerialConfig.onCloseConnection: {
            plcModbusCom.closePort();
        }
    }

    FileDialog {
        id: saveFileDialog
        fileMode: FileDialog.SaveFile
        defaultSuffix: "json"
    }

    FileDialog {
        id: openFileDialog
        fileMode: FileDialog.OpenFile
        defaultSuffix: "json"
    }

    // Overlay (Pop-up will enable this)
    BackgroundOverlay {
        id: overlay
        anchors.fill: parent
    }

    // Objects
    SerialGlobal {
        id: serialGlobal
    }

    WeaQuick.GlobalContext {
        id: wQuick
    }

    // AppSetting
    Settings {
        id: settings

        property alias currentPageIndex: swipeView.currentIndex
        property alias plcName: appHeader.title
    }
}
