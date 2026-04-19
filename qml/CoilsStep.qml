import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Column {
    id: root

    property bool displayByTag: false

    property int titleSize: 17
    property int fontSize: 15
    property int titleVAlignment: Qt.AlignVCenter
    property int titleHAlignment: Qt.AlignHCenter

    property int controlLevel: 2
    property int controlWidth: 150
    property int controlHeight: 33

    property alias model: repeater.model
    property alias repeater: repeater

    Repeater {
        id: repeater

        delegate: RowCompact {
            title: displayByTag ? modelData.displayName : modelData.name
            WeaQuick.Switch {
                anchors {
                    right: parent.right
                    rightMargin: parent.rightPadding
                }

                indicatorWidth: 45
                indicatorHeight: 22
                handleShape: WeaQuick.Handle.HandleShape.Circular
                handleSize: 16
            }
        }
    }
    component RowCompact: Item {

        property int padding: 0
        property int leftPadding: padding
        property int rightPadding: padding

        property alias title: titleLabelRow.text
        property alias titleVAlignment: titleLabelRow.verticalAlignment
        property alias titleHAlignment: titleLabelRow.horizontalAlignment
        property alias titleLabel: titleLabelRow

        width: parent.width
        height: controlHeight

        WeaQuick.Label {
            id: titleLabelRow
            // x: leftPadding
            anchors {
                left: parent.left
                leftMargin: parent.leftPadding
            }

            width: parent.width
            height: parent.height
            font.pixelSize: root.fontSize
            verticalAlignment: root.titleVAlignment
            horizontalAlignment: Qt.AlignLeft
        }
    }
}
