import QtQuick 2.12
import QtQuick.Controls 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Item {
    id: root

    property var pageItems: [compHomePage, compManualPage, compSettingsPage]
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
            // NOTE: Check this memory leakage
            stackView.pop();
            stackView.push(pageItems[index]);
        }

        onOpenPopUp: {
            comPopup.open();
        }
    }

    // Pages Stack
    StackView {
        id: stackView
        anchors {
            top: appHeader.bottom
            right: parent.right
            left: parent.left
            bottom: parent.bottom
        }

        initialItem: compHomePage
        // currentItem: pageItems[appHeader.pageButtonsItem.currentIndex]

        pushEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 200
            }
        }
        pushExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 200
            }
        }
        popEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 200
            }
        }
        popExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 200
            }
        }
    }

    // Pages Components
    Component {
        id: compHomePage
        HomePage {
            id: homePage
        }
    }

    Component {
        id: compManualPage
        ManualPage {
            id: manualPage
        }
    }

    Component {
        id: compSettingsPage
        SettingsPage {
            id: settingsPage
        }
    }

    // Popups
    ComPopup {
        id: comPopup
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
