import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick
import QtQuick.Controls 1.4 as Q

Q.TableView {
    id: root

    property int headerLeftPadding: 15

    backgroundVisible: false
    frameVisible: false

    headerDelegate: WeaQuick.Pane {
        height: 30
        radius: 0

        border.width: 1
        level: 1

        flat: styleData.pressed
        layer.enabled: false

        WeaQuick.Label {
            anchors {
                fill: parent
                leftMargin: headerLeftPadding
            }

            font.pixelSize: 13
            verticalAlignment: Qt.AlignVCenter
            elide: Text.ElideRight
            text: styleData.value
        }
    }

    rowDelegate: WeaQuick.Pane {
        height: 30
        radius: 0

        layer.enabled: false

        level: styleData.alternate ? 1 : 0
        color: styleData.row === root.currentRow ? "orange" : wQuick.theme.paneBackgroundColor[level]
    }

    itemDelegate: Item {
        WeaQuick.Label {
            anchors {
                fill: parent
                leftMargin: headerLeftPadding
            }
            verticalAlignment: Qt.AlignVCenter
            elide: styleData.elideMode
            text: styleData.value
            color: styleData.row === root.currentRow ? "black" : "white"
        }
    }

    /** Objects **/
    Keys.onEscapePressed: {
        root.currentRow = -1;
    }

    /** Functions **/
    function isSelected(index) {
        return index === root.currentRow;
    }

    function removeAll() {
        root.model.clear();
    }

    function removeCurrent() {
        return removeItem(root.currentRow);
    }

    function removeItem(index) {
        if (index > root.rowCount - 1 || index < 0) {
            return;
        }

        root.model.remove(index);
    }
}
