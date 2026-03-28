import QtQuick 2.12
import com.wearily.WeaQuick 1.0

Item {
    id: root

    /** Important Properties **/


    /*
      property name:
          Referer: `FONT_MAP.js` for example see js/FontAwesome.js.
          Note: Also  the name can be string hex like: "\uf06e"
    */
    property string name: "play"
    property var iconMap: FontAwesome.icons

    /** Optional Properties **/
    property int level: 0
    property color color: wQuick.theme.textColor[level]

    /** Alias Properties **/
    property alias family: icon.font.family
    property alias bold: icon.font.bold
    property alias pointSize: icon.font.pointSize
    property alias pixelSize: icon.font.pixelSize
    property alias weight: icon.font.weight
    property alias verticalAlignment: icon.verticalAlignment
    property alias horizontalAlignment: icon.horizontalAlignment

    property alias iconItem: icon

    /** Properties Assignments **/
    visible: opacity > 0
    implicitWidth: icon.paintedWidth
    implicitHeight: icon.paintedHeight

    /** Components **/
    Label {
        id: icon
        anchors.fill: parent

        level: root.level
        color: root.color
        font.family: "Font Awesome 6 Pro Solid"
        font.pixelSize: 11
        text: root.iconMap[root.name] === undefined ? root.name : root.iconMap[root.name]

        states: [
            State {
                name: "enabled"
                when: enabled
                PropertyChanges {
                    target: icon
                    color: root.color
                }
            },
            State {
                name: "disabled"
                when: !enabled
                PropertyChanges {
                    target: icon
                    color: Qt.darker(root.color, 1.5)
                }
            }
        ]

        transitions: [
            Transition {
                ColorAnimation {
                    duration: 150
                }
            }
        ]
    }
}
