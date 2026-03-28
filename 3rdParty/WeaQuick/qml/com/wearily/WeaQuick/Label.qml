import QtQuick 2.12
import QtQuick.Controls 2.12 as Q

Q.Label {
    id: root

    /** Properties **/
    property int level: 0
    property int fontLevel: 0

    /** Alias Properties **/
    property alias dropShadow: dropShadow

    /** Forwarding wQuick properties **/
    property var arrayTextColor: wQuick.theme.textColor
    property var arrayTextFont: wQuick.theme.labelFont

    /** Property Assignment **/
    color: enabled ? arrayTextColor[level] : Qt.darker(arrayTextColor[level],
                                                       2.0)
    font {
        // NOTE: pointSize isn't available anymore! (use pixelSize instead)
        family: arrayTextFont[fontLevel].family
        pixelSize: arrayTextFont[fontLevel].pixelSize
        weight: arrayTextFont[fontLevel].weight
        bold: arrayTextFont[fontLevel].bold
        italic: arrayTextFont[fontLevel].italic
    }

    layer.enabled: false
    layer.effect: DropShadowBinder {
        dropShadowObject: dropShadow
    }
    DropShadowObject {
        id: dropShadow
        color: "white"
        radius: 1
    }
}
