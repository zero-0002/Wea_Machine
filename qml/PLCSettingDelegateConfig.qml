import QtQuick 2.12
import QtQuick.Layouts 1.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Item {
    id: root

    // Referer PlcIOItem class
    property var modelItem: ({})

    property alias plcIndicatorSize: plcIndicator.width

    property alias delayEditBox: delayEditBox
    property alias blinkEditBox: blinkIntervalEditBox
    property alias plcIndicator: plcIndicator
    property alias pcIndicator: pcIndicator
    property alias line: line

    implicitHeight: 70

    signal writeRequest

    Rectangle {
        id: line

        anchors.verticalCenter: parent.verticalCenter

        width: parent.width
        height: 1
        color: "orange"
    }

    RowLayout {
        anchors {
            top: parent.top
            bottom: parent.bottom
            // verticalCenter: parent.verticalCenter
        }
        width: parent.width
        spacing: 30

        // PLC Feedback side
        Compact {
            Layout.alignment: Qt.AlignVCenter

            title: modelItem.name
            titleLabel.horizontalAlignment: Qt.AlignHCenter

            WeaQuick.StatusIndicator {
                id: plcIndicator

                width: 30
                height: 30
                radius: width / 2

                level: 3
                active: modelItem.activeFeedback
            }
        }

        // Contact Type
        CusComboBox {
            id: cmbBoxContactType
            Layout.preferredWidth: 160
            Layout.preferredHeight: 30
            Layout.alignment: Qt.AlignVCenter
            level: 2

            model: ["Normally Open", "Normally Close"]
            currentIndex: modelItem.contactType
            onCurrentIndexChanged: {
                if (currentIndex !== modelItem.contactType) {
                    modelItem.contactType = currentIndex;
                }
            }
        }

        // OnDelay Timer
        Column {
            Layout.preferredWidth: 120
            Layout.fillHeight: true

            spacing: 3

            WeaQuick.Label {
                font.pixelSize: 14
                text: "On Delay Timer"
                width: 120
                horizontalAlignment: Qt.AlignHCenter
            }

            DelayEditBox {
                id: delayEditBox
                width: 120
                height: 30
                level: 2
                border.width: 1
                font.pixelSize: 14
                arrayBackgroundColor: ["black", "black", "black"]
                value: modelItem.onDelayInterval / 1000
                onValueModified: {
                    modelItem.onDelayInterval = value * 1000;
                }
            }
        }

        // Blink Timer
        Column {
            Layout.preferredWidth: 120
            Layout.fillHeight: true

            spacing: 3
            visible: blinkIntervalEditBox.visible

            WeaQuick.Label {
                font.pixelSize: 14
                text: "Blink Interval"
                width: 120
                horizontalAlignment: Qt.AlignHCenter
            }

            DelayEditBox {
                id: blinkIntervalEditBox
                width: 120
                height: 30
                level: 2
                border.width: 1
                font.pixelSize: 14
                arrayBackgroundColor: ["black", "black", "black"]
                value: modelItem.blinkInterval / 1000
                onValueModified: {
                    modelItem.blinkInterval = value * 1000;
                }
            }
        }

        // OffDelay Timer
        Column {
            Layout.preferredWidth: 120
            Layout.fillHeight: true
            spacing: 3

            WeaQuick.Label {
                font.pixelSize: 14
                text: "Off Delay Timer"
                width: 120
                horizontalAlignment: Qt.AlignHCenter
            }

            DelayEditBox {
                id: offDelayEditBox
                width: 120
                height: 30
                level: 2
                border.width: 1
                font.pixelSize: 14
                arrayBackgroundColor: ["black", "black", "black"]
                value: modelItem.offDelayInterval / 1000
                onValueModified: {
                    modelItem.offDelayInterval = value * 1000;
                }
            }
        }

        // Interrupt Props
        WeaQuick.Button {
            id: btnInterrupts
            Layout.preferredWidth: 140
            Layout.preferredHeight: 35
            Layout.alignment: Qt.AlignVCenter

            arrayBackgroundColor: wQuick.theme.paneBackgroundColor
            arrayBorderColor: wQuick.theme.paneBorderColor
            arrayHoveredBackgroundColor: WeaQuick.WeaQuickUtils.lighter(wQuick.theme.paneBackgroundColor, 1.75)
            arraySelectedBackgroundColor: WeaQuick.WeaQuickUtils.darker(wQuick.theme.paneBackgroundColor, 1.75)

            layoutDirection: Qt.RightToLeft
            textHorizontalAlignment: Qt.AlignHCenter
            // iconHorizontalAlignment: Qt.AlignRight
            text: "Interrupts"
            icon: "gear-complex-code"
            iconSize: 15
            level: 2
            flat: false

            onClicked: {
                interruptPopup.plcIOItem = root.modelItem;
                interruptPopup.open();
            }
        }

        CusDelayButton {
            id: btnDlyWriteSetting
            Layout.preferredWidth: 135
            Layout.preferredHeight: 40
            Layout.alignment: Qt.AlignVCenter

            button.arrayBackgroundColor: wQuick.theme.paneBackgroundColor
            button.arrayBorderColor: wQuick.theme.paneBorderColor
            button.arrayHoveredBackgroundColor: WeaQuick.WeaQuickUtils.lighter(wQuick.theme.paneBackgroundColor, 1.75)
            button.arraySelectedBackgroundColor: WeaQuick.WeaQuickUtils.darker(wQuick.theme.paneBackgroundColor, 1.75)

            level: 2
            text: "Write"
            flat: false
            delay: 400
            onActivated: {
                writeRequest();
            }
        }

        // PC Indicator side
        Row {

            Layout.preferredWidth: 155
            Layout.alignment: Qt.AlignVCenter

            layoutDirection: Qt.RightToLeft
            spacing: 5

            WeaQuick.LineEdit {
                id: lineEditDisplayName
                y: -10
                width: parent.width - plcIndicator.width
                text: modelItem.displayName
                placeholderText: "Display Name"
                color: "transparent"
                font.pixelSize: 14
                verticalAlignment: Qt.AlignTop
                horizontalAlignment: Qt.AlignHCenter
                onAccepted: {
                    if (modelItem.displayName !== text) {
                        modelItem.displayName = text;
                    }
                }
            }

            WeaQuick.StatusIndicator {
                id: pcIndicator

                width: 30
                height: 30
                radius: width / 2

                level: 0
                active: modelItem.active
            }
        }
    }

    // Object && inline-component

    component Compact: Row {

        property alias title: titleLabel.text
        property alias titleLabel: titleLabel

        spacing: 5

        WeaQuick.Label {
            id: titleLabel
            y: -5
            width: 50
            font.pixelSize: 14
            verticalAlignment: Qt.AlignTop
            horizontalAlignment: parent.layoutDirection === Qt.RightToLeft ? Qt.AlignRight : Qt.AlignLeft
        }
    }
}
