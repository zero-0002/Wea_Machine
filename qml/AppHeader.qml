import QtQuick 2.12

Item {
    id: root

    implicitHeight: 35

    property alias pageButtonsItem: pageButtonsItem

    signal pageChanged(var index)
    signal openPopUp(var index)

    PageButtons {
        id: pageButtonsItem
        anchors.horizontalCenter: parent.horizontalCenter

        pageButtons: [
            {
                iconName: "house"
            },
            {
                iconName: "joystick"
            },
            {
                iconName: "gear"
            },
        ]

        popUpButtons: [
            {
                iconName: "plug"
            },
        ]

        onCurrentIndexChanged: {
            pageChanged(currentIndex);
        }

        onPopUpRequest: {
            openPopUp(index);
        }
    }
}
