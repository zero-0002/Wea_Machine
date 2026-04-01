import QtQuick 2.12

// TODO: Make ShaderEffect compatible with GLSL 400 > and OpenGL 3.0/4.0

Sunken {
    id: root

    /** Default WeaQuick Properties **/
    property var arrayActiveColor: wQuick.theme.statusIndicatorActiveColor
    property int levelActive: level // It might be different with default level

    /** StatusIndicator Properties **/
    property color color: root.active ? arrayActiveColor[levelActive] : "transparent" // Active Color
    property bool active: false
    property real activeBlur: 1.0 // referer overlay->ShaderEffect
    property real activeRadius: 1.0 // referer overlay->ShaderEffect

    property int iconXOffset: 0.0
    property int iconYOffset: -1.0

    /** Read-only Properties **/
    readonly property bool hasIcon: icon.name.length > 0

    /** Alias Properties **/
    property alias blinking: timerBlink.running
    property alias blinkInterval: timerBlink.interval

    property alias iconName: icon.name
    property alias iconColor: icon.color
    property alias iconSize: icon.pixelSize
    property alias iconMap: icon.iconMap

    property alias colorAnimationDuration: colorAnimation.duration

    property alias ripple: ripple
    property alias borderRect: borderRect
    // property alias icon: icon
    property alias activeIndicator: activeIndicator
    property alias colorAnimation: colorAnimation

    /** Signals **/
    signal blinked

    width: 35
    height: 35
    radius: width / 2

    borderWidth: 2
    outerMargin: 4

    /** Implementing Overlay & inner Contents **/
    backgroundDelegate: CircularRipple {
        id: ripple

        enabled: activeIndicator.visible

        width: parent.width * 1.25
        height: parent.height * 1.25
        radius: root.radius * 1.25

        active: root.active
        targetColor: Qt.darker(root.color, 2.0)
    }

    // Border Indicator (synced with icon indicator)
    outerDelegate: SmoothRectangle {
        id: borderRect
        anchors.fill: parent

        visible: root.hasIcon

        radius: root.radius

        color: root.color
        colorAnimation.duration: root.colorAnimationDuration
    }

    // Iconic Indicator Type
    innerDelegate: IconFont {
        id: icon

        x: (parent.width - implicitWidth) / 2 + iconXOffset
        y: (parent.height - implicitHeight) / 2 + iconYOffset

        visible: root.hasIcon

        name: ""
        color: root.active ? root.color : Qt.darker(root.outerColor, 1.7)
        pixelSize: Math.min(parent.width, parent.height) * 0.6

        Behavior on color {
            ColorAnimation {
                duration: root.colorAnimationDuration
            }
        }
    }

    // Normal 0/1 Circle Indicator
    overlayDelegate: SmoothRectangle {
        id: activeIndicator
        anchors.fill: parent

        visible: root.opacity > 0.0 && !root.hasIcon // color.a is synced with opacity
        radius: root.radius
        opacity: 0.95

        color: root.color
        colorAnimation.duration: 0

        layer.enabled: true
        layer.effect: ShaderEffect {

            // Uniforms
            property color u_color: root.color
            property real u_blur: root.activeBlur
            property real u_active_radius: root.activeRadius

            fragmentShader: "//fragment
                uniform sampler2D source;
                uniform float qt_Opacity;

                uniform vec4 u_color;
                uniform float u_blur;
                uniform float u_active_radius;

                varying vec2 qt_TexCoord0;

                void main() {
                    vec2 uv = vec2(qt_TexCoord0.x, qt_TexCoord0.y);
                    uv -= 0.5;
                    float alpha = texture2D(source, qt_TexCoord0).a;

                    float d = length(uv);
                    float blur = u_blur;
                    float r = u_active_radius;
                    float c = smoothstep(r + blur, r - blur, 1. - d) * 1.5;

                    vec4 color = vec4(mix(vec3(1.), u_color.rgb, c), u_color.a);

                    gl_FragColor = color * alpha * qt_Opacity;
                }
            "
        }
    }

    /** Resources & Objects **/

    Timer {
        id: timerBlink
        running: false
        repeat: true
        interval: 1000
        onTriggered: {
            root.active = !root.active;
            root.blinked();
        }
    }

    /** Animations **/

    Behavior on color {
        ColorAnimation {
            id: colorAnimation
            duration: 250
        }
    }
}
