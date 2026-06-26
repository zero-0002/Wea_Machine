import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

WeaQuick.Label {
    id: root

    property double value: 0.0
    property int decimals: {
        // Calculating max precision avaialable
        var strVal = String(value);
        const dot = strVal.indexOf('.');
        return dot === -1 ? 0 : strVal.length - dot - 1;
    }

    property string suffix: ""
    property var locale: Qt.locale()

    text: Number(value).toLocaleString(locale, 'f', decimals) + suffix
}
