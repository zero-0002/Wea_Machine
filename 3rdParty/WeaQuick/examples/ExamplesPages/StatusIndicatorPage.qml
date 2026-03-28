import QtQuick 2.12
import QtQuick.Layouts 1.12
import com.wearily.WeaQuick 1.0 as WeaQuick

// Including ExamplePane
import "../"

ExamplePane {
    id: root

    property var icons: ["brake-warning", "warning", "feather-pointed", "gas-pump"]

    title: "StatusIndicator: Compatible component with Qt5/Qt6 and more features\nNo QtQuick.Extras!"

    spacing: 15

    // Inline Component
    component Compact: Column {

        property alias title: label.text

        spacing: 5

        WeaQuick.Label {
            id: label
        }
    }

    contentItem: Grid {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 40
        columns: 4

        Repeater {
            model: wQuick.theme.statusIndicatorActiveColor.length

            delegate: Compact {

                title: "Level %1".arg(index)

                WeaQuick.StatusIndicator {
                    level: index

                    // outerMargin: 3
                    // borderWidth: 1

                    iconYOffset: iconName === "warning" ? -1.0 : 0.0 // align warning icon at center
                    radius: index === 4 ? width / 2 : width / 2 - index
                    iconName: index < 4 ? root.icons[index] : ""

                    blinking: true
                    blinkInterval: 500 * (index + 1)
                }
            }
        }
    }
}
