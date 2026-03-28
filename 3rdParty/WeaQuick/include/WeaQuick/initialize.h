#ifndef INITIALIZE_H
#define INITIALIZE_H

#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QQuickItem>

#include "init.h"
#include "config.h"

WEAQUICK_NAMESPACE_BEGIN

/*!
 * \brief initialize : Initializing WeaQuick Module.
 * \details adding ImportPaths & Loading some plugins & registering C++ classes.
 * \param engine : QQmlApplicationEngine* -> pass engine to automate everything.
 */
static void initialize(QQmlApplicationEngine* engine)
{
    if (engine)
    {
        engine->addImportPath(WeaQuick_INSTALL_QML_IMPORT_PATH);
        engine->addImportPath(WeaQuick_SOURCE_QML_IMPORT_PATH);
    }
    /** Base Configurations **/
    QQuickStyle::setStyle("Material");
}

WEAQUICK_NAMESPACE_END


#endif // INITIALIZE_H
