import QtQuick 2.12
import QtQuick.Layouts 1.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Item {
    id: root

    property alias digitalInputsModel: digitalInput.model
    property alias digitalOutputModel: digitalOutput.model

    ColumnLayout {
        id: columnLayout
        spacing: 10

        Compact {
            Layout.fillHeight: true
            Layout.fillWidth: true

            title: "Digital Inputs"
            titleSize: 15

            Grid {
                columns: 7
                spacing: 5
                columnSpacing: 15
                Repeater {
                    id: digitalInput

                    delegate: Compact {
                        title: "DI%1".arg(index + 1)
                        spacing: 3
                        WeaQuick.StatusIndicator {
                            width: 18
                            height: width

                            borderWidth: 1
                            outerMargin: 3

                            active: modelData
                            blinking: true
                        }
                    }
                }
            }
        }

        Compact {
            Layout.fillHeight: true
            Layout.fillWidth: true

            title: "Digital Outputs"
            titleSize: 15

            Grid {
                columns: 3
                spacing: 5
                columnSpacing: 15
                Repeater {
                    id: digitalOutput

                    delegate: Compact {
                        title: "DO%1".arg(index + 1)
                        titleHAlignment: Qt.AlignHCenter
                        spacing: 3
                        WeaQuick.StatusIndicator {
                            width: 18
                            height: width

                            borderWidth: 1
                            outerMargin: 3

                            levelActive: 1
                            active: modelData
                            blinking: true
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

        spacing: 10

        WeaQuick.Label {
            id: titleLabel
        }
    }
}
