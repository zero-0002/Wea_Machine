import QtQuick 2.12
import QtQuick.Layouts 1.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Item {
    id: root

    property real controlHeight: 27

    property alias value: torqueSlider.value // is same with torqueSlider.value

    property alias torqueSlider: torqueSlider
    property alias torqueBox: torqueBox
    property alias layout: layout

    RowLayout {
        id: layout
        anchors.fill: parent

        CusSlider {
            id: torqueSlider
            Layout.fillWidth: true

            master: torqueBox
            from: torqueBox.from
            to: torqueBox.to
            stepSize: torqueBox.stepSize

            onValueChanged: {
                valueModified();
            }

            Component.onCompleted: {
                // Request to update Slider position
                valueModified();
            }
        }

        TorqueEditBox {
            id: torqueBox
            Layout.preferredHeight: controlHeight

            color: "transparent"
            master: torqueSlider
            textItem.horizontalAlignment: Qt.AlignRight
            // Component.onCompleted: {
            // Request to update Slider position
            // valueModified();
            // }
        }
    }
}
