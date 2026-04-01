import QtQuick 2.12
import QtQuick.Layouts 1.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Item {
    id: root

    property int indicatorSize: 25
    property bool toggleOutput: false

    property alias digitalInputsModel: digitalInput.model
    property alias digitalOutputModel: digitalOutput.model

    property alias gridInputs: gridInputs
    property alias gridOutputs: gridOutputs

    property bool manualActive: false

    ColumnLayout {
        id: columnLayout
        spacing: 20

        Compact {
            Layout.fillHeight: true
            Layout.fillWidth: true

            title: "PLC Digital Inputs"
            titleSize: 15

            Grid {
                id: gridInputs
                x: titleLabel.paintedHeight // margin

                columns: 14
                spacing: 10
                columnSpacing: 25
                Repeater {
                    id: digitalInput

                    delegate: Compact {
                        title: modelData.title
                        titleHAlignment: Qt.AlignHCenter
                        spacing: 3
                        WeaQuick.StatusIndicator {
                            width: root.indicatorSize
                            height: width

                            levelActive: 3

                            borderWidth: 1
                            outerMargin: 2

                            active: index % 2
                        }
                    }
                }
            }
        }

        ShineLine {
            Layout.preferredWidth: parent.width - parent.width / 3
            color: "orange"
        }

        Compact {
            Layout.fillHeight: true
            Layout.fillWidth: true

            title: "PLC Digital Outputs"
            titleSize: 15

            Grid {
                id: gridOutputs
                x: titleLabel.paintedHeight // margin
                columns: 10
                spacing: 10
                columnSpacing: 25
                Repeater {
                    id: digitalOutput

                    delegate: Compact {
                        title: modelData.title
                        titleHAlignment: Qt.AlignHCenter
                        spacing: 3
                        Loader {
                            property int modelIndex: index

                            width: root.indicatorSize
                            height: width

                            sourceComponent: toggleOutput ? compOutputButton : compOutputIndicator
                        }
                    }
                }
            }

            Component {
                id: compOutputIndicator
                WeaQuick.StatusIndicator {
                    borderWidth: 1
                    outerMargin: 3

                    levelActive: 2
                    active: modelIndex % 2
                }
            }
            Component {
                id: compOutputButton
                SunkenButton {
                    enabled: manualActive
                    checked: modelIndex % 2
                    onEnabledChanged: {
                        if (!enabled) {
                            checked = false;
                        }
                    }
                }
            }
        }
    }

    // Object & inline-components
    component Compact: Column {
        property alias title: titleLabel.text
        property alias titleSize: titleLabel.font.pixelSize
        property alias titleHAlignment: titleLabel.horizontalAlignment
        property alias titleVAlignment: titleLabel.verticalAlignment
        property alias tittlePaintedHeight: titleLabel.paintedHeight
        property alias tittlePaintedWidth: titleLabel.paintedWidth
        property alias titleLabel: titleLabel

        spacing: 10

        WeaQuick.Label {
            id: titleLabel
        }
    }
}
