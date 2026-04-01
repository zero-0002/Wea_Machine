import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick
import QtQuick.Layouts 1.12

Item {
    id: root

    RowLayout {
        anchors {
            fill: parent
            margins: 10
        }

        spacing: 10

        // Side Bar (Pages)
        SettingSideBar {
            id: settingSideBar
            Layout.fillHeight: true
            Layout.preferredWidth: 200
        }

        SettingMainContent {
            id: settingMainContent
            Layout.fillHeight: true
            Layout.fillWidth: true

            currentIndex: settingSideBar.currentIndex
        }
    }
}
