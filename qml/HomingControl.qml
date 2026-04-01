import QtQuick 2.12
import QtQuick.Layouts 1.12
import com.wearily.WeaQuick 1.0 as WeaQuick

RowLayout {
    id: root

    property alias title: titleLabel.text
    property alias titleVAlignment: titleLabel.verticalAlignment
    property alias titleHAlignment: titleLabel.horizontalAlignment
    property alias titleLabel: titleLabel

    property alias homingActive: swHoming.checked
    property alias homingSwitch: swHoming

    WeaQuick.Label {
        id: titleLabel
        Layout.fillWidth: true
        Layout.leftMargin: 10

        font.pixelSize: 13
        verticalAlignment: Qt.AlignVCenter
    }

    WeaQuick.Switch {
        id: swHoming
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
