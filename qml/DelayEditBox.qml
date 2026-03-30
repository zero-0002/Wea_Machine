import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

WeaQuick.EditBox {
    id: root

    decimals: 2
    stepSize: 0.15
    from: 0
    to: 3600 * 24
    value: 0.0
    suffix: " sec"
}
