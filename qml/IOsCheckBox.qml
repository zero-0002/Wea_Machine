import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Grid {
    id: root

    property int fontSize: 13
    property int maxContentWidth: width
    property int maxContentHeight: height

    // Format : [ {name: str, checked: bool} , ... ]
    property alias model: repeater.model
    property var resultModel: {
        const cnt = repeater.count;
        var result = [];
        for (var i = 0; i < cnt; ++i) {
            var it = repeater.itemAt(i);
            const isChecked = it.chkBox.checked;
            const isEnabled = it.chkBox.enabled;
            if (isChecked && isEnabled) {
                result.push(i);
            }
        }
        return result;
    }

    clip: true
    spacing: 10
    columns: Math.floor(width / (maxContentWidth + spacing))

    Repeater {
        id: repeater
        delegate: Item {

            property alias labelItem: label
            property alias chkBox: chk

            width: maxContentWidth
            height: maxContentHeight
            clip: true

            WeaQuick.Label {
                id: label
                anchors {
                    top: parent.top
                    horizontalCenter: parent.horizontalCenter
                    bottom: chk.top
                }

                enabled: modelData.enabled
                text: modelData.name
                width: chk.indicator.width
                wrapMode: Text.WordWrap
                font.pixelSize: root.fontSize
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignBottom

                onTextChanged: {
                    updateSize(label, chk);
                }
            }
            WeaQuick.CheckBox {
                id: chk
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }

                height: 30

                enabled: modelData.enabled
                checked: modelData.checked
            }

            // Calculating Item Preferred Height/Width
            Component.onCompleted: {
                updateSize(label, chk);
            }
        }
        function refreshSize() {
            resetSize();
            for (var i = 0; i < count; ++i) {
                var it = itemAt(i);
                updateSize(it.labelItem, it.chkBox);
            }
        }

        function resetCheckedStates() {
            for (var i = 0; i < count; ++i) {
                var it = itemAt(i);
                it.chkBox.checked = false;
            }
        }
    }

    function resetCheckedStates() {
        repeater.resetCheckedStates();
    }

    function refreshSize() {
        repeater.refreshSize();
    }

    function resetSize() {
        maxContentWidth = 0;
        maxContentHeight = 0;
    }

    function updateSize(label, chk) {
        maxContentWidth = Math.max(label.paintedWidth + 1, maxContentWidth);
        maxContentHeight = Math.max(label.paintedHeight + chk.height, maxContentHeight);
    }
}
