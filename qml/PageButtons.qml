import QtQuick 2.12

// import com.wearily.WeaQuick 1.0 as WeaQuick

Item {
    id: root

    property int currentIndex: 0

    property var pageButtons
    property var popUpButtons

    property alias layout: layout

    signal popUpRequest(var index)

    implicitWidth: pageButtons.length * (30 + layout.spacing)

    Row {
        id: layout
        anchors.fill: parent
        spacing: 5

        Repeater {
            model: pageButtons

            delegate: IconicButton {
                icon: modelData.iconName
                locked: true
                checked: index === currentIndex
                onClicked: {
                    currentIndex = index;
                }
            }
        }

        // Pop-UP Type Buttons
        Repeater {
            model: popUpButtons

            delegate: IconicButton {
                icon: modelData.iconName
                onClicked: {
                    popUpRequest(index);
                }
            }
        }
    }
}
