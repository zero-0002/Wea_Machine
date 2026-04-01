import QtQuick 2.12
import QtQuick.Layouts 1.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Item {
    id: root

    property real controlHeight: 27

    property alias value: speedBox.value // is same with speedSlider.value

    property alias speedSlider: speedSlider
    property alias speedBox: speedBox
    property alias layout: layout

    RowLayout {
        id: layout
        anchors.fill: parent

        CusSlider {
            id: speedSlider
            Layout.fillWidth: true

            master: speedBox
            from: speedBox.from
            to: speedBox.to
            stepSize: speedBox.stepSize
        }

        SpdEditBox {
            id: speedBox
            Layout.preferredHeight: controlHeight

            color: "transparent"
            master: speedSlider
            textItem.horizontalAlignment: Qt.AlignRight

            Component.onCompleted: {
                // Request to update Slider position
                valueModified();
            }
        }
    }
}
