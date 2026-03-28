import QtQuick 2.12
import QtQuick.Controls 2.12 as Q
import com.wearily.WeaQuick 1.0 as WeaQuick

/**

AbstractBar: declares Bar Logics and base Items and properties.

NOTE: Inheriting from Slider component for Bar root Item, has too efficiency.
Then we create a new component instead of inheriting from Slider component.

**/

Q.Control {
    id: root

    /** Properties **/
    property real from: 0.0
    property real to: 1.0
    property real value: 0.0

    property real origin: root.from

    /** Special Properties **/
    property bool useOpenGL: false // Using OpenGL Shaders for bar value Span
    property real visualPosition: 0.0 // normalized bar span position (0.0~1.0)

    property real barPadding: padding
    property real barHorizontalPadding: barPadding
    property real barVerticalPadding: barPadding
    property real barLeftPadding: barHorizontalPadding
    property real barRightPadding: barHorizontalPadding
    property real barTopPadding: barVerticalPadding
    property real barBottomPadding: barVerticalPadding

    /** Read-only Properties **/
    readonly property real valuePosition: WeaQuick.WeaQuickUtils.normalize(value, from, to)
    readonly property real originPosition: WeaQuick.WeaQuickUtils.normalize(origin, from, to)

    readonly property real barAvailableWidth: width - (barLeftPadding + barRightPadding)
    readonly property real barAvailableHeight: height - (barTopPadding + barBottomPadding)

    /** Alias Properties **/
    readonly property alias implicitBarWidth: barItem.implicitWidth
    readonly property alias implicitBarHeight: barItem.implicitHeight

    property alias barItem: barItem
    default property alias barDelegate: barItem.data

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset, implicitContentWidth + leftPadding
                            + rightPadding, implicitBarWidth + barLeftPadding + barRightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset, implicitContentHeight + topPadding
                             + bottomPadding, implicitBarHeight + barTopPadding + barBottomPadding)

    Item {
        id: barItem

        x: barLeftPadding
        y: barTopPadding
        scale: root.mirrored ? -1 : 1

        implicitWidth: barAvailableWidth
        implicitHeight: barAvailableHeight
    }
}
