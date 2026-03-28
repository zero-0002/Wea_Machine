import QtQuick 2.12
import QtQuick.Controls 2.12 as Q

// TODO: Improve CheckBox component with more options and flexibility (add Icon also)
Q.CheckBox {
    id: root

    /** Default Properties **/
    property int level: 0
    property int levelLabel: 0
    property int fontLevel: 0

    // Pass array colors, example -> wQuick.theme.buttonBackgroundColor
    property var arrayBackgroundColor: wQuick.theme.checkBoxBackgroundColor

    /// TODO: add below properties
    // property var arrayHoveredBackgroundColor: wQuick.theme.checkBoxHoveredBackgroundColor
    // property var arraySelectedBackgroundColor: wQuick.theme.checkBoxSelectedBackgroundColor

    // property var arrayBorderColor: wQuick.theme.checkBoxBorderColor
    // property var arrayHoveredBorderColor: wQuick.theme.checkBoxHoveredBorderColor
    // property var arraySelectedBorderColor: wQuick.theme.checkBoxSelectedBorderColor

    // property var arrayBorderWidth: wQuick.theme.checkBoxBorderWidth
    property var arrayTextColor: wQuick.theme.textColor
    property var arrayTextFont: wQuick.theme.labelFont

    /** Non-Qt-CheckBox Properties **/
    property bool defaultType: false
    property color color: arrayBackgroundColor[level]
    property string textAtToggled: text

    /** Alias Properties **/
    // Its recooment to use levelLabel instead of this property
    property alias textColor: label.color

    property alias label: label
    property alias gradient: colorRect.gradient

    font {
        // NOTE: pointSize isn't available anymore! (use pixelSize instead)
        family: arrayTextFont[fontLevel].family
        pixelSize: arrayTextFont[fontLevel].pixelSize
        weight: arrayTextFont[fontLevel].weight
        bold: arrayTextFont[fontLevel].bold
        italic: arrayTextFont[fontLevel].italic
    }

    layer.enabled: !defaultType
    layer.smooth: true
    layer.samplerName: "u_source"
    layer.effect: ShaderEffect {
        id: indicatorEffect

        // Using an invisible Rectangle Gradient, as Source Texture
        property var u_tex_color: colorRect

        // GLSL 130
        fragmentShader: "#version 130\n" + "uniform sampler2D u_tex_color;\n"
                        + "uniform sampler2D u_source;\n" + "uniform lowp float qt_Opacity;\n"
                        + "varying highp vec2 qt_TexCoord0;\n" + "void main() {\n"
                        + "lowp vec4 c = texture2D(u_source, qt_TexCoord0);\n"
                        + "lowp vec4 color = texture2D(u_tex_color, qt_TexCoord0);\n"
                        + "lowp float lo = min(min(c.x, c.y), c.z);\n"
                        + "lowp float hi = max(max(c.x, c.y), c.z);\n"
                        + "gl_FragColor = qt_Opacity * vec4(mix(vec3(lo), vec3(hi), color.xyz), c.w);\n" + "}\n"
    }

    contentItem: Label {
        id: label
        leftPadding: root.indicator.width / root.indicator.height
                     + (paintedHeight * 0.75) + root.implicitIndicatorWidth
        verticalAlignment: Qt.AlignVCenter

        arrayTextColor: root.arrayTextColor
        arrayTextFont: root.arrayTextFont
        font: root.font
        level: root.levelLabel

        text: checked ? root.textAtToggled : root.text

        // ShaderEffect
        layer.enabled: true
        layer.smooth: true
        layer.samplerName: "u_source"
        layer.effect: ShaderEffect {
            id: labelEffect

            property color u_color: label.color

            // GLSL 130
            fragmentShader: "#version 130\n" + "uniform sampler2D u_source;\n"
                            + "uniform lowp float qt_Opacity;\n"
                            + "varying highp vec2 qt_TexCoord0;\n"
                            + "uniform vec4 u_color;\n" + "void main() {\n"
                            + "lowp vec4 c = texture2D(u_source, qt_TexCoord0);\n"
                            + "lowp vec4 color = u_color;\n"
                            + "lowp float lo = min(min(c.x, c.y), c.z);\n"
                            + "lowp float hi = max(max(c.x, c.y), c.z);\n"
                            + "gl_FragColor = qt_Opacity * vec4(mix(vec3(lo), vec3(hi), color.xyz), c.w);\n" + "}\n"
        }
    }

    /** Gradient Rectangle (This Item isn't visible Only texture required for ShaderEffect **/
    Rectangle {
        id: colorRect
        width: 10
        height: 10
        // By Default there is no gradient (but it can be reimplement and implement gradient by user)
        gradient: Gradient {
            GradientStop {
                position: 0
                color: root.color
            }
            GradientStop {
                position: 1
                color: root.color
            }
        }

        visible: false // should not be visible on screen.
        layer.enabled: true
        layer.smooth: true
    }
}
