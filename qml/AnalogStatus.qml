import QtQuick 2.12
import QtQuick.Layouts 1.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Item {
    id: root

    // Avoids updating Repeater for each value update
    property var values: []

    property alias title: label.text
    property alias titleSize: label.font.pixelSize
    property alias analogModel: repeater.model
    property alias grid: grid
    property alias label: label

    readonly property int controlPreferredHeight: 27
    readonly property int controlPreferredWidth: 170

    WeaQuick.Label {
        id: label
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        text: "Analog Status"
        font.pixelSize: 15
    }

    Grid {
        id: grid
        anchors {
            top: label.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: label.paintedHeight / 2
        }
        spacing: 10
        columnSpacing: 20
        columns: 2

        Repeater {
            id: repeater

            delegate: Compact {
                title: modelData.title
                WeaQuick.EditBox {
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    width: controlPreferredWidth

                    editable: false
                    wheelEnabled: false

                    decimals: modelData.decimals
                    suffix: modelData.suffix
                    color: "transparent"
                    font.pixelSize: 12

                    from: intToDouble(-2147483000)
                    to: intToDouble(2147483000)
                    textItem.text: "%1".arg(textFromValue(root.values[index], Qt.locale()))
                }
            }
        }
    }

    // Object & inline-components
    component Compact: Item {
        property alias title: titleLabel.text
        property alias titleSize: titleLabel.font.pixelSize
        property alias titleHAlignment: titleLabel.horizontalAlignment
        property alias titleVAlignment: titleLabel.verticalAlignment

        width: controlPreferredWidth * 2
        height: controlPreferredHeight

        WeaQuick.Label {
            id: titleLabel
            height: parent.height
            font.pixelSize: 12
            verticalAlignment: Qt.AlignVCenter
        }
    }
}
