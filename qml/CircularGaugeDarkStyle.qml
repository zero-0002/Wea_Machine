import QtQuick 2.2
import QtQuick.Controls.Styles 1.4

CircularGaugeStyle {
    id: root
    tickmarkStepSize: 10
    minorTickmarkCount: 1
    labelStepSize: 20
    tickmarkInset: outerRadius * 0.06
    minorTickmarkInset: tickmarkInset
    labelInset: outerRadius * 0.23

    background: ShineLine {
        color: "orange"
        radius: height / 2

        Image {
            anchors.fill: parent
            source: "qrc:/share/images/background.png"
        }
    }

    needle: Image {
        id: needleImage
        transformOrigin: Item.Bottom
        source: "qrc:/share/images/needle.png"
        scale: {
            var distanceFromLabelToRadius = labelInset / 2;
            var idealHeight = outerRadius - distanceFromLabelToRadius;
            var originalImageHeight = needleImage.sourceSize.height;
            idealHeight / originalImageHeight;
        }
    }

    foreground: Item {
        Image {
            anchors.centerIn: parent
            source: "qrc:/share/images/center.png"
            scale: (outerRadius * 0.25) / sourceSize.height
        }
    }

    tickmark: Rectangle {
        implicitWidth: outerRadius * 0.02
        antialiasing: true
        implicitHeight: outerRadius * 0.05
        color: "#888"
    }

    minorTickmark: Rectangle {
        implicitWidth: outerRadius * 0.01
        antialiasing: true
        implicitHeight: outerRadius * 0.02
        color: "#444"
    }

    tickmarkLabel: Text {
        font.pixelSize: Math.max(7, outerRadius * 0.1)
        text: styleData.value
        color: "white"
    }
}
