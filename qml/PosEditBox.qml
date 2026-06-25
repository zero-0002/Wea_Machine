import QtQuick 2.12
import CustomItems 1.0
import com.wearily.WeaQuick 1.0 as WeaQuick

WeaQuick.EditBox {
    id: root

    // REQUIRED
    property AxisConfig axisConfig

    readonly property int puuValue: axisConfig.toPUU(value)
    property alias unitValue: root.value

    decimals: axisConfig.decimals
    stepSize: 1
    from: -2147483647 / Math.pow(10, decimals)
    to: 2147483647 / Math.pow(10, decimals)
    value: 0.0
    suffix: " " + axisConfig.unitName

    /** functions **/
    function setValueByUnit(unit) {
        spinBox.value = doubleToInt(unit);
    }

    function setValueByPUU(puu) {
        setValueByUnit(axisConfig.toUnit(puu));
    }
}
