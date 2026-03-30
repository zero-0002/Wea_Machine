import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Grid {
    id: root

    property int fontSize: 13
    property int maxContentWidth: width
    property int maxContentHeight: height

    property alias model: repeater.model

    clip: true
    spacing: 10
    columns: Math.floor(width / (maxContentWidth + spacing))

    Repeater {
        id: repeater
        delegate: Item {

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

                text: "X%1".arg(index)
                width: chk.indicator.width
                wrapMode: Text.WordWrap
                font.pixelSize: root.fontSize
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignBottom
            }
            WeaQuick.CheckBox {
                id: chk
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }

                height: 30
                checked: false
                // onCheckedChanged: {
                //     modelData.checked = checked;
                // }

                // Component.onCompleted: {
                //     checked = modelData.checked;
                // }
            }

            // Calculating Item Preferred Height/Width
            Component.onCompleted: {
                maxContentWidth = Math.max(label.paintedWidth + 1, maxContentWidth);
                maxContentHeight = Math.max(label.paintedHeight + chk.height, maxContentHeight);
            }
        }
    }
}
