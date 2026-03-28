import QtQuick 2.12
import QtQuick.Window 2.12
import Qt.labs.settings 1.0

Window {
    id: window
    width: 900
    height: 730
    visible: true
    title: "WeaQuick Gallery"

    function doReload() {
        appLoader.sourceComponent = undefined;
        _qmlEngine.clearCache();
        appLoader.sourceComponent = Qt.createComponent("Gallery.qml");
    }

    Shortcut {
        sequence: '`'
        onActivated: doReload()
    }

    Component {
        id: mainComp
        Gallery {}
    }

    Loader {
        id: appLoader
        anchors.fill: parent
        sourceComponent: mainComp
    }
}
