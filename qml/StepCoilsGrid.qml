import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Grid {
    id: root

    property int fontSize: 13
    property int maxContentWidth: 1
    property int maxContentHeight: 1

    property bool activeIndicators: false
    property int activeLevel: 3

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
                    bottom: statusIndicator.top
                }

                text: "Y%1".arg(index)
                width: statusIndicator.width
                wrapMode: Text.WordWrap
                font.pixelSize: root.fontSize
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignBottom
            }
            WeaQuick.StatusIndicator {
                id: statusIndicator
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                }

                width: 22
                height: width
                borderWidth: 1
                outerMargin: 2

                levelActive: activeLevel
                active: activeIndicators
            }

            // Calculating Item Preferred Height/Width
            Component.onCompleted: {
                maxContentWidth = Math.max(label.paintedWidth, statusIndicator.width, maxContentWidth);
                maxContentHeight = Math.max(label.paintedHeight + statusIndicator.height, maxContentHeight);
            }
        }
    }
}
