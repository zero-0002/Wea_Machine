import QtQuick 2.12
import QtQuick.Layouts 1.12

Item {
    id: root

    RowLayout {

        // Side Bar (Pages)
        SettingSideBar {
            id: sideBar
            Layout.preferredWidth: 200
            Layout.fillHeight: true
        }

        // Main
        SettingMainContent {
            id: mainContent
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
