import QtQuick 2.12
import QtQuick.Controls 1.4 as Q

BorderRectangle {
    id: root

    property int padding: 10

    level: 0
    title: "Alarms"

    ShineLine {
        id: shineLine
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: padding
            topMargin: 0
        }
        color: "orange"
    }

    CusTableView {
        id: tableView
        anchors {
            top: shineLine.bottom
            left: parent.left
            right: parent.right
            bottom: alarmFooter.top
            margins: padding
        }

        backgroundVisible: false
        Q.TableViewColumn {
            role: "no"
            title: "No"
            width: 50
        }
        Q.TableViewColumn {
            role: "code"
            title: "Alarm Code"
            width: 100
        }
        Q.TableViewColumn {
            role: "desc"
            title: "Description"
            width: 250
        }
        model: _alarmModel
    }

    AlarmFooter {
        id: alarmFooter

        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            margins: padding
        }

        resetAlarms.onActivated: {
            _alarmModel.clear();

            servoXDevice.resetAlarms();
            servoYDevice.resetAlarms();
        }
    }

    // ListModel {
    //     id: libraryModel
    //     ListElement {
    //         no: "1"
    //         code: "AL-011"
    //         desc: "Emergency"
    //     }
    //     ListElement {
    //         no: "2"
    //         code: "AL-012"
    //         desc: "Negative Limit"
    //     }
    //     ListElement {
    //         no: "3"
    //         code: "AL-013"
    //         desc: "Under voltage"
    //     }
    // }
}
