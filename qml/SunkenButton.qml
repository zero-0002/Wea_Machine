import QtQuick 2.12

IconicButton {
    id: root

    locked: true
    checkable: true

    icon: checked ? "lightbulb-on" : "lightbulb"
}
