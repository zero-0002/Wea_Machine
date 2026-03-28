import QtQuick 2.12
import QtQuick.Layouts 1.12
import com.wearily.WeaQuick 1.0 as WeaQuick

// Including ExamplePane
import "../"

ExamplePane {
    id: root

    title: "Bar: No Effect Rectangle with bar indicator logics."

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
            model: 1

            delegate: Compact {

                title: "Style %1".arg(index)

                WeaQuick.BarIndicator {
                    id: bar

                    // color: "red"
                    // border.width: 2
                    // border.color: "yellow"
                }
            }
        }
    }
}
