import QtQuick 2.12

import com.wearily.WeaQuick 1.0 as WeaQuick

// TODO: Improve Label quality
WeaQuick.Label {
    id: root

    property color outlineColor: root.color
    property size delta: Qt.size(0.5 / width, 0.5 / height)
    property real smoothFactor: 1.0

    /** Properties **/
    layer.enabled: true
    layer.smooth: true
    layer.effect: ShaderEffect {
        property size u_delta: delta
        property color u_color: outlineColor
        property real u_smooth_factor: smoothFactor
        fragmentShader: "uniform sampler2D source;\n"
                        + "uniform lowp vec4 u_color;\n" + "uniform highp vec2 u_delta;\n"
                        + "uniform highp float u_smooth_factor;\n" + "uniform highp float qt_Opacity;\n"
                        + "\n" + "varying highp vec2 qt_TexCoord0;\n" + "\n" + "void main() {\n"
                        + "lowp vec4 tl = texture2D(source, qt_TexCoord0 - u_delta);\n" + "lowp vec4 tr = texture2D(source, qt_TexCoord0 + vec2(u_delta.x, -u_delta.y));\n" + "lowp vec4 bl = texture2D(source, qt_TexCoord0 - vec2(u_delta.x, -u_delta.y));\n" + "lowp vec4 br = texture2D(source, qt_TexCoord0 + u_delta);\n" + "mediump vec4 gx = (tl + bl) - (tr + br);\n" + "mediump vec4 gy = (tl + tr) - (bl + br);\n" + "gl_FragColor.xyz = vec3(u_color.rgb);\n" + "gl_FragColor.w = smoothstep(u_smooth_factor, 1., dot(sqrt(gx * gx + gy * gy), vec4(1.))) * qt_Opacity;\n"
                        + "if (gl_FragColor.w == 0.0) {\n" + "gl_FragColor = vec4(.0);\n"
                        + "}\n" + "}\n"
    }
}
