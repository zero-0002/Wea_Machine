import QtQuick 2.12
import QtQuick.Controls 2.12
import Qt.labs.settings 1.1
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
    }

    /** Modbus Devices **/
    PlcModbusDevice {
        id: plcDevice
        slaveAddress: 2
        onEnabledChanged: {
            if (comPopup.plcSerialConnection.connected) {
                plcDevice.syncCoils();
            }
        }
    }

    ServoModbusDevice {
        id: servoYDevice
        slaveAddress: 3
    }

    ServoModbusDevice {
        id: servoXDevice
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
