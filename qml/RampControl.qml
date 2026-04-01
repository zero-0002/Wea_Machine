import QtQuick 2.12
import QtQuick.Layouts 1.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Item {
    id: root

    property real fontSize: 13
    property real controlHeight: 27

    property alias accValue: accBox.value
    property alias decValue: decBox.value

    property alias accSlider: accSlider
    property alias accBox: accBox

    property alias decSlider: decSlider
    property alias decBox: decBox

    property alias layout: layout

    implicitHeight: layout.height

    ColumnLayout {
        id: layout
        x: 10
        width: parent.width - x * 2
        spacing: 0

        WeaQuick.Label {
            font.pixelSize: fontSize
            text: "Acceleration"
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            CusSlider {
                id: accSlider
                Layout.fillWidth: true

                master: accBox
                from: accBox.from
                to: accBox.to
                stepSize: accBox.stepSize
            }

            RampEditBox {
                id: accBox
                Layout.preferredHeight: controlHeight

                color: "transparent"
                master: accSlider
                textItem.horizontalAlignment: Qt.AlignRight

                Component.onCompleted: {
                    // Request to update Slider position
                    valueModified();
                }
            }
        }

        WeaQuick.Label {
            font.pixelSize: fontSize
            text: "Deceleration"
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            CusSlider {
                id: decSlider
                Layout.fillWidth: true

                master: decBox
                from: decBox.from
                to: decBox.to
                stepSize: decBox.stepSize
            }

            RampEditBox {
                id: decBox
                Layout.preferredHeight: controlHeight

                color: "transparent"
                master: decSlider
                textItem.horizontalAlignment: Qt.AlignRight

                Component.onCompleted: {
                    // Request to update Slider position
                    valueModified();
                }
            }
        }
    }
}
