import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

WeaQuick.EditBox {
    id: root

    decimals: 0
    stepSize: 1
    from: 0
    to: 60000
    value: 200
    suffix: " ms"
}
