import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

WeaQuick.Slider {
    id: root

    arrayGrooveColor: ["#444", "#BBB", "#AAA"]
    arraySpanRectColor: ["orange", "red", "cyan"]
    arrayLimitColor: WeaQuickUtils.darker(arraySpanRectColor, 4.0)
}
