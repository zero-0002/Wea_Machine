import QtQuick 2.12
import QtQuick.Window 2.12

import "qml"

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

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
