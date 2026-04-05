#ifndef REGISTERATIONS_H
#define REGISTERATIONS_H

#include <QCoreApplication>
#include <qqml.h>

#include "SerialGlobal.h"
#include "SerialConnection.h"
#include "modbuscom.h"

#define QT_REGISTER_METATYPE(type) \
    qRegisterMetaType<type>(#type)

#define QTQML_REGISTER_TYPE(uri, type) \
    qmlRegisterType<type>(uri, 1, 0, #type)

static void registerTypes()
{
    QTQML_REGISTER_TYPE("CustomItems", SerialGlobal);
    QTQML_REGISTER_TYPE("CustomItems", SerialConnection);
    QTQML_REGISTER_TYPE("CustomItems", ModbusCom);
}

Q_COREAPP_STARTUP_FUNCTION(registerTypes)

#endif // REGISTERATIONS_H
