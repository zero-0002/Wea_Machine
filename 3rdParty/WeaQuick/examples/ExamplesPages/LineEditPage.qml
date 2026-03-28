import QtQuick 2.12
import QtQuick.Layouts 1.12

import com.wearily.WeaQuick 1.0 as WeaQuick
// Including ExamplePane
import "../"

ExamplePane {
    id: root

    property int preferredWidth: 150

    title: "LineEdit TextInput"
    spacing: 15

    contentItem: ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 20

        WeaQuick.LineEdit {
            Layout.preferredWidth: preferredWidth

            placeholderText: "Enter Username"
        }

        WeaQuick.LineEdit {
            Layout.preferredWidth: preferredWidth

            placeholderText: "Enter Password"
            echoMode: TextInput.Password
        }

        WeaQuick.LineEdit {
            Layout.preferredWidth: preferredWidth

            placeholderText: "Password Echo Edit"
            echoMode: TextInput.PasswordEchoOnEdit
        }

        WeaQuick.LineEdit {
            Layout.preferredWidth: preferredWidth

            placeholderText: "+1 | 123456789"
            validator: IntValidator {}
        }

        WeaQuick.LineEdit {
            Layout.preferredWidth: preferredWidth

            levelLabel: 4
        }

        WeaQuick.LineEdit {
            Layout.preferredWidth: preferredWidth

            color: "transparent"
            placeholderText: "Transparent"
        }

        WeaQuick.LineEdit {
            Layout.preferredWidth: preferredWidth

            enabled: false
            placeholderText: "disbled"
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }
}
