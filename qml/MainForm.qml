import QtQuick 2.12
import QtQuick.Controls 2.12
import Qt.labs.settings 1.1
import com.wearily.WeaQuick 1.0 as WeaQuick

Item {
    id: root

    property var pageComponents: [compHomePage, compManualPage, compSettingsPage]
    // property var pageItems: [homePage, manualPage, settingsPage]
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

        // onPageChanged: {
        // if (swipeView.currentIndex !== index) {
        //     swipeView.currentIndex = index;
        // }

        onPageChanged: {
            elapsed = Date.now();
        }

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

    Loader {
        id: pageLoader

        anchors {
            top: appHeader.bottom
            right: parent.right
            left: parent.left
            bottom: parent.bottom
            topMargin: headerLine.height + 5
        }
        sourceComponent: pageComponents[appHeader.pageButtonsItem.currentIndex]
        onLoaded: {
            console.log("PageLoaded: ", Date.now() - elapsed);
        }
    }

    // SwipeView {
    //     id: swipeView
    //     anchors {
    //         top: appHeader.bottom
    //         right: parent.right
    //         left: parent.left
    //         bottom: parent.bottom
    //         topMargin: headerLine.height + 5
    //     }

    //     onCurrentIndexChanged: {
    //         if (currentIndex !== appHeader.pageButtonsItem.currentIndex) {
    //             appHeader.pageButtonsItem.currentIndex = currentIndex;
    //         }
    //     }

    //     HomePage {
    //         id: homePage
    //     }

    //     ManualPage {
    //         id: manualPage
    //     }
    //     SettingsPage {
    //         id: settingsPage
    //     }
    // }

    // Popups
    LoginPopup {
        id: loginPopup
    }

    // Config Popup
    StepPopup {
        id: stepPopup
    }

    ComPopup {
        id: comPopup
        model: [
            {
                title: "PLC Serial"
            },
            {
                title: "Servo X-Axis"
            },
            {
                title: "Servo Y-Axis"
            }
        ]
    }

    // Overlay (Pop-up will enable this)
    BackgroundOverlay {
        id: overlay
        anchors.fill: parent
    }

    // Objects
    WeaQuick.GlobalContext {
        id: wQuick
    }

    // AppSetting
    Settings {
        id: settings

        // property alias currentPageIndex: swipeView.currentIndex
    }
}
