import QtQuick 2.0
import QtGraphicalEffects 1.12


/*!
 *  \brief DropShadowBinder : This component will bind all of DropShadow properties with WeaQuick.DropShadowObject
 *  \note The `source` property of `DropShadow` Must be pass manually!
 *      This property will not bind from `WeaQuick.DropShadowObject` to `DropShadow` component.
 */
DropShadow {
    id: root

    /** Properties **/
    property DropShadowObject dropShadowObject

    /** Forward Binding **/
    cached: dropShadowObject.cached
    color: dropShadowObject.color
    horizontalOffset: dropShadowObject.horizontalOffset
    verticalOffset: dropShadowObject.verticalOffset
    radius: dropShadowObject.radius
    samples: dropShadowObject.samples
    spread: dropShadowObject.spread
    transparentBorder: dropShadowObject.transparentBorder
}
