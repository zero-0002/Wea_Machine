import QtQuick 2.12
import QtQuick.Layouts 1.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Item {
    id: root

    property alias layoutSpacing: layout.spacing

    property alias title: titleLabel.text
    property alias titleSize: titleLabel.font.pixelSize
    property alias titleHAlignment: titleLabel.horizontalAlignment
    property alias titleVAlignment: titleLabel.verticalAlignment

    property alias editBoxGaugeHeight: editBoxGauge.height
    property alias editBoxGaugeSuffix: editBoxGauge.suffix

    property alias layout: layout
    property alias titleLabel: titleLabel
    property alias editBoxGauge: editBoxGauge
    default property alias gaugeItem: gaugeItem.data

    ColumnLayout {
        id: layout
        anchors.fill: parent
        spacing: 25

        WeaQuick.Label {
            id: titleLabel
            Layout.fillWidth: true
            Layout.preferredHeight: paintedHeight

            text: "Gauge X"
            horizontalAlignment: Qt.AlignHCenter
            font.pixelSize: 16
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignCenter
            Item {
                id: gaugeItem
                anchors.fill: parent
            }
        }

        WeaQuick.EditBox {
            id: editBoxGauge
            Layout.fillWidth: true
            Layout.preferredHeight: height

            height: 40
            font.pixelSize: 16
            color: "transparent"
            editable: false
            wheelEnabled: false
        }
    }
}
