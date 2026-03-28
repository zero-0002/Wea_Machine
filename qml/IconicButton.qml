import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

WeaQuick.Button {
    id: root
    width: 27
    height: 27

    iconColor: "orange"
    flat: false

    arrayBorderColor: arrayBackgroundColor
    arraySelectedBorderColor: ["orange", "orange", "orange"]
}
