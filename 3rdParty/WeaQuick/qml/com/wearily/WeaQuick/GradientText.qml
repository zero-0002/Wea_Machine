import QtQuick 2.12

import com.wearily.WeaQuick 1.0 as WeaQuick

WeaQuick.Label {
    id: root

    /** Alias Properties **/
    property alias sourceFrame: gradientRect
    property alias gradient: gradientRect.gradient

    layer.enabled: true
    // This item should be used as the 'mask'
    layer.samplerName: "maskSource"
    layer.effect: ShaderEffect {
        property var colorSource: gradientRect
        fragmentShader: "uniform lowp sampler2D colorSource;\n"
                        + "uniform lowp sampler2D maskSource;\n"
                        + "uniform lowp float qt_Opacity;\n"
                        + "varying highp vec2 qt_TexCoord0;\n" + "void main() {\n"
                        + "gl_FragColor =\n" + "texture2D(colorSource, qt_TexCoord0)\n"
                        + "* texture2D(maskSource, qt_TexCoord0).a\n" + "* qt_Opacity;\n" + "}\n"
    }

    // Invisible Frame required for inplacing the gradientEffect
    Rectangle {
        id: gradientRect
        visible: false // should not be visible on screen.
        width: 10
        height: 10

        layer.enabled: true
        layer.smooth: true

        // Default Gradient values
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "white"
            }
            GradientStop {
                position: 1
                color: "steelblue"
            }
        }
    }
}
