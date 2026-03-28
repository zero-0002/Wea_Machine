import QtQuick 2.12

Item {
    id: root

    property Component themeComponent: Component {
        Theme {}
    }

    /** Context Properties **/
    property alias theme: themeLoader.item
    property string shareDir: "../../../../share/"
    property string fontsDir: shareDir + "fonts/"

    Loader {
        id: themeLoader
        sourceComponent: themeComponent
    }
}
