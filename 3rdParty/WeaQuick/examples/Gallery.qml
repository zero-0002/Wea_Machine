import QtQuick 2.12
import QtQuick.Controls 2.12
import Qt.labs.settings 1.1
import com.wearily.WeaQuick 1.0 as WeaQuick

Rectangle {
    id: root
    color: wQuick.theme.backgroundColor[0]
    WeaQuick.Pane {
        id: headerPane
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: 10
        }

        height: 60

        flat: false
        level: 2

        WeaQuick.WaveText {
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: 30
            }

            text: "WeaQuick Gallery"
            font {
                pixelSize: 22
                italic: true
            }
        }
    }

    Item {
        id: mainPane

        anchors {
            top: headerPane.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            margins: 10
            leftMargin: 200
        }

        Loader {
            id: loaderExamplePage
            anchors.fill: parent
        }
    }

    WeaQuick.SearchEdit {
        id: searchEdit
        anchors {
            top: headerPane.bottom
            left: parent.left
            right: mainPane.left
            margins: 10
        }

        sourceData: ["Pane", "Label", "ShadowText", "WaveText", "OutlineText", "GradientText", "Button", "Switch", "Sunken",
            "StatusIndicator", "BarIndicator", "LineEdit", "SearchEdit", "FontAwesome", "Ripple", "CheckBox", "EditBox",
            "SpinBox", "Slider", "RangeSlider"]
    }

    ListView {
        id: listView
        anchors {
            top: searchEdit.bottom
            bottom: parent.bottom
            left: parent.left
            right: mainPane.left
            margins: 10
        }

        clip: true
        spacing: 5

        boundsBehavior: Flickable.StopAtBounds

        model: searchEdit.filteredData
        delegate: WeaQuick.Button {
            width: listView.width
            height: 35

            flat: false
            text: modelData
            font.pixelSize: 13
            locked: true // lock other states when is checked
            checked: listView.currentIndex == index
            onClicked: listView.currentIndex = index
        }
        onCurrentIndexChanged: {
            loadExamplePage(model[currentIndex]);
        }
    }

    WeaQuick.GlobalContext {
        id: wQuick
        themeComponent: defaultThemeComponent
    }
    Component {
        id: defaultThemeComponent
        WeaQuick.Theme {}
    }
    Component {
        id: lightThemeComponent
        WeaQuick.ThemeLight {}
    }
    function loadExamplePage(name) {
        const path = "file:///%1%2Page.qml".arg(_examplesPages).arg(name);
        console.log("Loading Example Page: ", path);
        loaderExamplePage.source = "";
        loaderExamplePage.source = path;
    }
    Settings {
        id: settings
        property alias pageCurrentIndex: listView.currentIndex
    }

    /** All Components Enable/Disable Shortcut **/
    Shortcut {
        sequence: "e"
        onActivated: root.enabled = !root.enabled
    }

    /** Next/Prev Page Shortcut **/
    Shortcut {
        sequence: "w"
        onActivated: {
            listView.currentIndex = (listView.currentIndex - 1 + listView.model.length) % listView.model.length;
        }
    }

    Shortcut {
        sequence: "s"
        onActivated: {
            listView.currentIndex = (listView.currentIndex + 1) % listView.model.length;
        }
    }
}
