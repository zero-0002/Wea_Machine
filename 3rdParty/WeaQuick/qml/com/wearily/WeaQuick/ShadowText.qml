import QtQuick 2.12

import com.wearily.WeaQuick 1.0 as WeaQuick

// TODO: Compact ShaderSources
WeaQuick.Label {
    id: root

    /** Properties **/
    property real angle: 0.0
    property real darkness: 1.0
    property point offset: Qt.point(15.0 * Math.cos(angle), 15.0 * Math.sin(angle))
    property size delta: Qt.size(offset.x / width, offset.y / height)

    /** Alias Properties **/
    property alias animationAngleRunning: animationAngle.running
    property alias animationAngle: animationAngle

    layer.enabled: true
    layer.smooth: true

    layer.effect: ShaderEffect {
        /** shadow shaders uniforms **/
        property real u_angle: root.angle
        property real u_darkness: root.darkness
        property point u_offset: root.offset
        property size u_delta: root.delta
        property variant u_shadow: ShaderEffectSource {
            // Vertical SourceItem blur
            sourceItem: ShaderEffect {
                /** blur shaders uniforms **/
                property size u_delta: Qt.size(0.0, 1.0 / height)
                property variant source: ShaderEffectSource {
                    // Horizontal SourceItem blur
                    sourceItem: ShaderEffect {
                        /** blur shaders uniforms **/
                        property size u_delta: Qt.size(1.0 / width, 0.0)
                        property variant source: root

                        fragmentShader: "//fragment
										uniform lowp float qt_Opacity;
                                        uniform sampler2D source;
                                        uniform highp vec2 u_delta;

										varying highp vec2 qt_TexCoord0;

										void main()
										{
                                        gl_FragColor =(0.0538 * texture2D(source, qt_TexCoord0 - 3.182 * u_delta)
                                        + 0.3229 * texture2D(source, qt_TexCoord0 - 1.364 * u_delta)
                                        + 0.2466 * texture2D(source, qt_TexCoord0)
                                        + 0.3229 * texture2D(source, qt_TexCoord0 + 1.364 * u_delta)
                                        + 0.0538 * texture2D(source, qt_TexCoord0 + 3.182 * u_delta)) * qt_Opacity;
										}"
                        height: root.height
                        width: root.width
                    }
                }

                fragmentShader: "//fragment
                                uniform lowp float qt_Opacity;
                                uniform sampler2D source;
                                uniform highp vec2 u_delta;

                                varying highp vec2 qt_TexCoord0;

                                void main()
                                {
                                gl_FragColor =(0.0538 * texture2D(source, qt_TexCoord0 - 3.182 * u_delta)
                                + 0.3229 * texture2D(source, qt_TexCoord0 - 1.364 * u_delta)
                                + 0.2466 * texture2D(source, qt_TexCoord0)
                                + 0.3229 * texture2D(source, qt_TexCoord0 + 1.364 * u_delta)
                                + 0.0538 * texture2D(source, qt_TexCoord0 + 3.182 * u_delta)) * qt_Opacity;
                                }"
                height: root.height
                width: root.width
            }
        }

        fragmentShader: "//fragment
                        uniform lowp float qt_Opacity;
                        uniform highp vec2 u_offset;
                        uniform sampler2D source;
                        uniform sampler2D u_shadow;
                        uniform highp float u_darkness;
                        uniform highp vec2 u_delta;

                        varying highp vec2 qt_TexCoord0;

                        void main() {
                        lowp vec4 fg = texture2D(source, qt_TexCoord0);
                        lowp vec4 bg = texture2D(u_shadow, qt_TexCoord0 + u_delta);
                        gl_FragColor = (fg + vec4(0., 0., 0., u_darkness * bg.a) * (1. - fg.a)) * qt_Opacity;
                        }"
    }
    /** Optional Animation **/
    NumberAnimation on angle {
        id: animationAngle
        running: false
        duration: 6000
        from: 0
        loops: Animation.Infinite
        to: Math.PI * 2
    }
}
