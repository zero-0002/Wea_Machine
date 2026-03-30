import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

WeaQuick.EditBox {
    id: root

    decimals: 3
    stepSize: 0.1
    from: -2147483
    to: 2147483
    value: 0.0
    suffix: " mm"
}
