import QtQuick 2.12
import QtQuick.Layouts 1.12
import com.wearily.WeaQuick 1.0 as WeaQuick

RowLayout {
    id: root

    property real controlHeight: 27

    property alias title: titleLabel.text
    property alias titleVAlignment: titleLabel.verticalAlignment
    property alias titleHAlignment: titleLabel.horizontalAlignment
    property alias titleLabel: titleLabel

    property alias positionActive: swActive.checked

    property alias positionValue: posEditBox.value
    property alias positionEditBox: posEditBox
    property alias positionSwitch: swActive

    spacing: 15

    WeaQuick.Label {
        id: titleLabel
        Layout.leftMargin: 10

        font.pixelSize: 13
        verticalAlignment: Qt.AlignVCenter
    }

    PosEditBox {
        id: posEditBox
        Layout.fillWidth: true
        Layout.preferredHeight: controlHeight
        Layout.rightMargin: 10

        enabled: swActive.checked

        level: 2
        border.width: 1
    }

    WeaQuick.Switch {
        id: swActive
        Layout.preferredWidth: indicatorWidth
        Layout.rightMargin: 20

        arrayUncheckedBackgroundColor: ["#444", "gray", "darkGray"]
        arrayUncheckedBorderColor: WeaQuick.WeaQuickUtils.darker(arrayUncheckedBackgroundColor, 1.5)

        indicatorWidth: 45
        indicatorHeight: 19
        // handleShape: WeaQuick.Handle.HandleShape.Circular
        handleRadius: 2
        handleSize: 13
    }
}
