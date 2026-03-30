import QtQuick 2.12
import QtQuick.Controls 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Item {
    id: root

    // property var pageItems: [compHomePage, compManualPage, compSettingsPage]
    property var pageItems: [homePage, manualPage, settingsPage]
    property var popUps: [comPopup]

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

    // Pages Stack
    // StackView {
    SwipeView {
        // id: stackView
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

        // initialItem: compHomePage

        // pushEnter: Transition {
        //     PropertyAnimation {
        //         property: "opacity"
        //         from: 0
        //         to: 1
        //         duration: 200
        //     }
        // }
        // pushExit: Transition {
        //     PropertyAnimation {
        //         property: "opacity"
        //         from: 1
        //         to: 0
        //         duration: 200
        //     }
        // }
        // popEnter: Transition {
        //     PropertyAnimation {
        //         property: "opacity"
        //         from: 0
        //         to: 1
        //         duration: 200
        //     }
        // }
        // popExit: Transition {
        //     PropertyAnimation {
        //         property: "opacity"
        //         from: 1
        //         to: 0
        //         duration: 200
        //     }
        // }
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

    // Pages Components
    // Component {
    //     id: compHomePage
    //     HomePage {
    //         id: homePage
    //     }
    // }

    // Component {
    //     id: compManualPage
    //     ManualPage {
    //         id: manualPage
    //     }
    // }

    // Component {
    //     id: compSettingsPage
    //     SettingsPage {
    //         id: settingsPage
    //     }
    // }

    // Popups
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
}
