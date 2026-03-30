import QtQuick 2.12

// TODO: Add enable Disable for Edit/Remove Buttons

Item {
    id: root

    property alias profiles: cBoxProfiles.model

    property alias comboBoxProfiles: cBoxProfiles
    property alias insertButton: insertButton
    property alias editButton: editButton
    property alias deleteButton: deleteButton
    property alias openButton: openFileButton
    property alias saveButton: saveFileButton

    Row {
        anchors.fill: parent
        spacing: 5

        CusComboBox {
            id: cBoxProfiles
            wheelEnabled: false
            model: ["Default", "Profile1", "Profile2", "Profile3"]
            width: root.width - 6 * (insertButton.width)
            height: root.height
        }

        IconicButton {
            id: insertButton
            icon: "plus-large"
        }

        IconicButton {
            id: editButton
            icon: "pencil-mechanical"
        }

        IconicButton {
            id: deleteButton
            icon: "trash-can"
        }

        IconicButton {
            id: openFileButton
            icon: "folder-open"
        }

        IconicButton {
            id: saveFileButton
            icon: "clipboard"
        }
    }
}
