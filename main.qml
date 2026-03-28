import QtQuick 2.12
import QtQuick.Window 2.12

import "qml"

Window {
    id: appWindow
    width: 640
    height: 480
    visible: true
    visibility: Window.FullScreen
    title: qsTr("Injection Molding")
    color: "black"

    property string mainFormPath: "qml/MainForm.qml"

    Component {
        id: compMainForm

        MainForm {}
    }

    Loader {
        id: appLoader
        anchors.fill: parent
        sourceComponent: compMainForm
    }

    function doReload() {
        appLoader.sourceComponent = undefined;
        _engine.clearCache();
        appLoader.sourceComponent = Qt.createComponent(mainFormPath);
    }

    Shortcut {
        sequence: "`"
        onActivated: doReload()
    }
}
