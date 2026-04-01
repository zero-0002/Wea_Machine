import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

WeaQuick.EditBox {
    id: root

    decimals: 0
    stepSize: 1
    from: 0
    to: 100
    value: 30
    suffix: " %"
}
