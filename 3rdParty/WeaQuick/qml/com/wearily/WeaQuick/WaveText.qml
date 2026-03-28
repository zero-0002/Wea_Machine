import QtQuick 2.12

import com.wearily.WeaQuick 1.0 as WeaQuick

WeaQuick.Label {
    id: root

    /** Configuration Properties **/
    property bool running: true
    property int loops: Animation.Infinite
    property real frequency: 20.0
    property real amplitude: 0.04 * 0.10

    layer.enabled: true
    layer.smooth: true
    layer.samplerName: "u_source"
    layer.effect: ShaderEffect {
        id: shaderEffect

        property real u_time: 0.0
        property real u_frequency: root.frequency
        property real u_amplitude: root.amplitude

        NumberAnimation on u_time {
            running: root.running
            loops: root.loops
            from: 0
            to: Math.PI * 2
            duration: 600
        }

        fragmentShader: "uniform lowp float qt_Opacity;\n" + "uniform highp float u_amplitude;\n"
                        + "uniform highp float u_frequency;\n"
                        + "uniform highp float u_time;\n" + "uniform sampler2D u_source;\n"
                        + "varying highp vec2 qt_TexCoord0;\n" + "void main()\n"
                        + "{\n" + "highp vec2 p = sin(u_time + u_frequency * qt_TexCoord0);\n"
                        + "gl_FragColor = texture2D(u_source, qt_TexCoord0 + u_amplitude * vec2(p.y, -p.x)) * qt_Opacity;\n" + "}\n"
    }
}
