import QtQuick 2.12

import com.wearily.WeaQuick 1.0

QtObject {
    id: root

    /** etc **/
    // property real displayRatio: 1.0 /** Use "QT_SCALE_FACTOR" environmnet instead **/

    /** Backgrounds **/
    property var backgroundColor: ["#000000"]

    /** Panes **/
    property var paneBackgroundColor: ["#000000", "#FF111111", "#222", "#333", "#444", "#555", "#666", "#777", "#888"]
    property var paneBorderColor: WeaQuickUtils.darker(paneBackgroundColor, 1.7)

    /** Controls **/
    property var controlBackgroundColor: ["#55444444", "#22FAFAFA", "#55000000", "#55000000", "#22FAFAFA"]
    property var controlHoveredBackgroundColor: ["#88AAAAAA", "#44FAFAFA", "#88000000", "#88000000", "#44FAFAFA"]
    property var controlSelectedBackgroundColor: ["#22AAAAAA", "#77FAFAFA", "#DD000000", "#DD000000", "#AAFAFAFA"]
    property var controlCheckedBackgroundColor: ["#55444444", "#22FAFAFA", "#55000000", "#55000000", "#22FAFAFA"]

    property var controlBorderColor: ["#66D1D1D1", "#66E1E1E1", "orange", "#AAFF0000", "#AA00FF00"]
    property var controlHoveredBorderColor: WeaQuickUtils.darker(controlBorderColor, 10.0)
    property var controlSelectedBorderColor: controlHoveredBorderColor
    property var controlBorderWidth: [2, 2, 2, 2, 2, 2]

    /** Texts **/
    property var textColor: ["#FFFFFFFF", "#FFE1E1E1", "#FFC2C2C2", "#FFA4A4A4", "red", "tomato", "orange", "#FFFFF0000",
        "#FF00FF00"]
    property var textHoveredColor: textColor
    property var textSelectedColor: textColor

    /** Buttons **/
    property var buttonBackgroundColor: ["#55444444", "#22FAFAFA", "#55000000", "#55000000", "#55FAFAFA"]
    property var buttonHoveredBackgroundColor: ["#88AAAAAA", "#44FAFAFA", "#88000000", "#88000000", "#44FAFAFA"]
    property var buttonSelectedBackgroundColor: ["#22AAAAAA", "#77FAFAFA", "#DD000000", "#DD000000", "#AAFAFAFA"]

    property var buttonBorderColor: ["#66D1D1D1", "#66E1E1E1", "orange", "#AAFF0000", "#AA00FF00"]
    property var buttonHoveredBorderColor: WeaQuickUtils.darker(buttonBorderColor, 10.0)
    property var buttonSelectedBorderColor: buttonHoveredBorderColor
    property var buttonBorderWidth: [2, 2, 2, 2, 2, 2]

    /** Switches **/
    property var switchUncheckedBackgroundColor: ["#55000000", "#55000000", "#55000000", "#55000000", "#55000000",
        "green", "red"]
    property var switchCheckedBackgroundColor: ["orange", "green", "yellow", "red", "#C81E84", "red", "green"]
    property var switchUncheckedBorderColor: WeaQuickUtils.darker(switchUncheckedBackgroundColor, 1.5)
    property var switchCheckedBorderColor: WeaQuickUtils.darker(switchCheckedBackgroundColor, 1.5)
    property var switchUncheckedHandleColor: ["#FFC9C9C9", "#FFC9C9C9", "#FFC9C9C9", "#FFC9C9C9", "#FFC9C9C9",
        "#FFC9C9C9", "#FFC9C9C9"]
    property var switchCheckedHandleColor: ["#FFC9C9C9", "#B2B2B2", "#757575", "#C81E84", "#E91E63", "#FA0000", "orange",
        "#00FF00"]

    /** Frames **/
    property var sunkenOuterColor: ["#222", "#333", "#444", "#555", "#666", "#777", "#888", "#999", "#aaa", "#ccc",
        "#eee", "#fff", "red", "yellow", "green", "orange", "blue", "cyan", "magenta", "purple"]
    property var sunkenInnerColor: WeaQuickUtils.lighter(sunkenOuterColor, 1.35)

    /** CheckBoxes **/
    property var checkBoxBackgroundColor: ["orange", "tomato", "red", "yellow", "green"]
    property var checkBoxHoveredBackgroundColor: [] // TODO: compelet these fields
    property var checkBoxSelectedBackgroundColor: []

    property var checkBoxBorderColor: []
    property var checkBoxHoveredBorderColor: WeaQuickUtils.darker(checkBoxBorderColor, 10.0)
    property var checkBoxSelectedBorderColor: checkBoxHoveredBorderColor
    property var checkBoxBorderWidth: [1, 1, 1, 1, 1, 1]

    /** Indicators **/
    property var statusIndicatorActiveColor: ["red", "yellow", "green", "orange", "blue", "cyan", "magenta", "lightPink",
        "white"]

    /** Slider **/
    property var sliderHandleColor: ["#B2B2B2", "#757575", "#C81E84", "#E91E63", "#FA0000", "orange", "#00FF00"]
    property var sliderGrooveColor: WeaQuickUtils.darker(sliderHandleColor, 1.5)
    property var sliderSpanRectColor: sliderHandleColor
    property var sliderLimitColor: WeaQuickUtils.darker(sliderSpanRectColor, 4.0)

    /** Editors **/
    property var editBackgroundColor: ["#55444444", "#22FAFAFA", "#55000000", "#55000000", "#22FAFAFA"]
    property var editHoveredBackgroundColor: WeaQuickUtils.darker(editBackgroundColor, 1.75)
    property var editSelectedBackgroundColor: editHoveredBackgroundColor

    property var editBorderColor: ["#66D1D1D1", "#66E1E1E1", "orange", "#AAFF0000", "#AA00FF00"]
    property var editHoveredBorderColor: WeaQuickUtils.lighter(editBorderColor, 1.9)
    property var editSelectedBorderColor: editHoveredBorderColor
    property var editBorderWidth: [2, 2, 2, 2, 2, 2]

    /** ScrollBars **/
    property var scrollHandlerBackgroundColor: []
    property var scrollHandlerHoveredBackgroundColor: []
    property var scrollHandlerSelectedBackgroundColor: []

    property var scrollHandlerBorderColor: []
    property var scrollHandlerHoveredBorderColor: []
    property var scrollHandlerSelectedBorderColor: []

    /** Other **/
    property var placeholderColor: WeaQuickUtils.darker(textColor, 1.3)

    /** Fonts **/
    property FontLoader defaultLightFontLoader: FontLoader {
        source: wQuick.fontsDir + "FiraCode/FiraCode-Light.ttf"
    }

    property FontLoader defaultRegularFontLoader: FontLoader {
        source: wQuick.fontsDir + "FiraCode/FiraCode-Regular.ttf"
    }

    property FontLoader defaultMediumFontLoader: FontLoader {
        source: wQuick.fontsDir + "FiraCode/FiraCode-Medium.ttf"
    }

    /** By default font family is equal with FontLoader result **/
    property string defaultLightFontFamily: defaultLightFontLoader.name
    property string defaultRegularFontFamily: defaultRegularFontLoader.name
    property string defaultMediumFontFamily: defaultMediumFontLoader.name

    property int defaultLightFontPixelSize: 12
    property int defaultRegularFontPixelSize: 12
    property int defaultMediumFontPixelSize: 12

    property int defaultLightFontWeight: Font.Light
    property int defaultRegularFontWeight: Font.Normal
    property int defaultMediumFontWeight: Font.Medium

    property bool defaultLightFontBold: false
    property bool defaultRegularFontBold: false
    property bool defaultMediumFontBold: false

    property bool defaultLightFontItalic: false
    property bool defaultRegularFontItalic: false
    property bool defaultMediumFontItalic: false

    property font defaultLightFont: Qt.font({
                                                "family": defaultLightFontFamily,
                                                "pixelSize": defaultLightFontPixelSize,
                                                "weight": defaultLightFontWeight,
                                                "bold": defaultLightFontBold,
                                                "italic": defaultLightFontItalic
                                            })
    property font defaultRegularFont: Qt.font({
                                                  "family": defaultRegularFontFamily,
                                                  "pixelSize": defaultRegularFontPixelSize,
                                                  "weight": defaultRegularFontWeight,
                                                  "bold": defaultRegularFontBold,
                                                  "italic": defaultRegularFontItalic
                                              })
    property font defaultMediumFont: Qt.font({
                                                 "family": defaultMediumFontFamily,
                                                 "pixelSize": defaultMediumFontPixelSize,
                                                 "weight": defaultMediumFontWeight,
                                                 "bold": defaultMediumFontBold,
                                                 "italic": defaultMediumFontItalic
                                             })

    /** Label Fonts **/
    property var labelFont: [defaultMediumFont, defaultRegularFont, defaultLightFont]
}
