import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

WeaQuick.EditBox {
    id: root

    decimals: 1
    stepSize: 0.1
    from: 0
    to: 1500
    value: 100.0
    suffix: " rpm"
}
