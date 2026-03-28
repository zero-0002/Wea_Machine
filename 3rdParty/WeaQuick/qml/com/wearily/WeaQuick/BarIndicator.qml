import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

/**

Bar: Exactly same as Slider component but without user-interface interactions.

**/

AbstractBar {
    id: root

    /** Read-only Properties **/
    property real thickness: 10 // Thickness of the Groove Rectangle
    readonly property bool horizontal: false
    readonly property real position: visualPosition

    /** Alias Properties **/
    // property alias color: span.color
    // property alias border: span.border
    // property alias gradient: span.gradient
    // property alias radius: span.radius // NOTE: radius has no effect on root.radius

    // property alias span: span

    height: 70
    width: 35

    value: 0.5
    visualPosition: 0.5

    // topInset: 10
    padding: 10
    barPadding: 5

    background: Rectangle {
        color: "black"
    }

    contentItem: Rectangle {
        color: "red"
        x: 20
        y: 20
        width: 10
        height: 10
        implicitWidth: 10
        implicitHeight: 10
    }

    LayoutMirroring.enabled: true
    barDelegate: Rectangle {
        // anchors.fill: parent
        y: root.mirrored ? barAvailableHeight - (barTopPadding + barBottomPadding) : 0
        implicitWidth: implicitBarWidth
        height: 10
        width: 10
        color: "yellow"
    }

    Component.onCompleted: {
        console.log("Insets: ", topInset, bottomInset, leftInset, rightInset);
        console.log("Padding", padding, topPadding, bottomPadding, leftPadding, rightPadding);
        console.log("Spacing: ", spacing);

        console.log("Background size: ", background.x, background.y, background.width, background.height);
        console.log("ContentItem size: ", contentItem.x, contentItem.y, contentItem.width, contentItem.height);
        console.log("BarItem size: ", barItem.x, barItem.y, barItem.width, barItem.height);
        console.log("BarDelegate size: ", barDelegate.x, barDelegate.y, barDelegate.width, barDelegate.height);

        console.log("Avaialable width/height: ", availableWidth, availableHeight);
        console.log("Mirrored: ", mirrored);
    }

    // background: SmoothRectangle {
    //     id: groove
    //     x: root.leftPadding + (root.horizontal ? 0 : (root.availableWidth - width) / 2)
    //     y: root.topPadding + (root.horizontal ? (root.availableHeight - height) / 2 : 0)
    //     implicitWidth: root.horizontal ? 200 : 48
    //     implicitHeight: root.horizontal ? 48 : 200
    //     width: root.horizontal ? root.availableWidth : root.thickness
    //     height: root.horizontal ? root.thickness : root.availableHeight
    //     scale: root.horizontal && root.mirrored ? -1 : 1
    //     radius: width / 2

    //     // color: arrayGrooveColor[level]
    //     color: "white"
    //     disableColor: "gray"

    //     // Limit Rectangle
    //     // SmoothRectangle {
    //     //     id: limitRect

    //     //     x: root.horizontal ? root.fromLimitPosition * parent.width : (parent.width - width) / 2
    //     //     y: root.horizontal ? (parent.height - height) / 2 : (1.0 - root.toLimitPosition) * parent.height
    //     //     width: root.horizontal ? (root.toLimitPosition - root.fromLimitPosition) * parent.width : root.thickness
    //     //     height: root.horizontal ? root.thickness : (root.toLimitPosition - root.fromLimitPosition) * parent.height
    //     //     radius: groove.radius

    //     //     // color: arrayLimitColor[level]
    //     //     color: "blue"
    //     //     disableColor: "black"
    //     // }
    // }

    // // Span Rectangle (Value)
    // SmoothRectangle {
    //     id: span
    //     x: root.horizontal ? Math.min(root.position, root.originPosition) * parent.width : (parent.width - width) / 2
    //     y: root.horizontal ? (parent.height - height) / 2 : Math.min(root.visualPosition, 1.0 - root.originPosition)
    //                          * parent.height
    //     width: root.horizontal ? Math.abs(root.position - root.originPosition) * parent.width : root.thickness
    //     height: root.horizontal ? root.thickness : Math.abs(root.position - root.originPosition) * parent.height
    //     radius: groove.radius

    //     // color: arraySpanRectColor[level]
    //     color: "red"
    //     disableColor: "darkGray"
    // }
}
