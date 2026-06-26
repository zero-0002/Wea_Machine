import QtQuick 2.12
import QtQuick.Controls 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Item {
    id: root

    Flickable {
        id: view
        anchors {
            fill: parent
            margins: 35
            leftMargin: 0
            topMargin: 0
        }

        clip: true
        contentWidth: width
        contentHeight: column.height
        boundsBehavior: Flickable.StopAtBounds

        ScrollBar.vertical: CusScrollBar {}
        Item {
            anchors {
                fill: parent
                margins: 10
                topMargin: 0
                rightMargin: 15
            }

            Column {
                id: column
                anchors {
                    left: parent.left
                    right: parent.right
                }
                spacing: 0

                AxisConfigPanel {
                    id: panelXAxisConfig
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                    title: "X-Axis Configuration"
                    targetAxisConfig: globalConfig.xAxisConfig
                    spliterVisible: false
                }

                AxisConfigPanel {
                    id: panelYAxisConfig
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                    title: "Y-Axis Configuration"
                    targetAxisConfig: globalConfig.yAxisConfig
                }

                StepSettingPanel {
                    id: panelStepSetting
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                }
            }
        }
    }
}
