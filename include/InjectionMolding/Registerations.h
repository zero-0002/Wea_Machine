#ifndef REGISTERATIONS_H
#define REGISTERATIONS_H

#include <QCoreApplication>
#include <qqml.h>

#include "SerialGlobal.h"
#include "SerialConnection.h"
#include "modbuscom.h"
#include "plcmodbusdevice.h"
#include "plcioitem.h"
#include "servomodbusdevice.h"

#define QT_REGISTER_METATYPE(type) \
    qRegisterMetaType<type>(#type)

#define QTQML_REGISTER_TYPE(uri, type) \
    qmlRegisterType<type>(uri, 1, 0, #type)

Q_DECLARE_METATYPE(AbstractModbusDevice*);
Q_DECLARE_METATYPE(QList<AbstractModbusDevice*>);
Q_DECLARE_METATYPE(QList<PlcIOItem*>);
Q_DECLARE_METATYPE(PlcIOItem*);
Q_DECLARE_METATYPE(QVector<bool>);

static void registerTypes()
{
    QT_REGISTER_METATYPE(PlcIOItem*);
    QT_REGISTER_METATYPE(AbstractModbusDevice*);
    QT_REGISTER_METATYPE(ServoModbusDevice*);
    QT_REGISTER_METATYPE(QList<AbstractModbusDevice*>);
    QT_REGISTER_METATYPE(QList<ServoModbusDevice*>);
    QT_REGISTER_METATYPE(QList<PlcIOItem>*);
    QT_REGISTER_METATYPE(QVector<bool>);

    QTQML_REGISTER_TYPE("CustomItems", PlcModbusDevice);
    QTQML_REGISTER_TYPE("CustomItems", ServoModbusDevice);
    QTQML_REGISTER_TYPE("CustomItems", SerialGlobal);
    QTQML_REGISTER_TYPE("CustomItems", SerialConnection);
    QTQML_REGISTER_TYPE("CustomItems", ModbusCom);
}

Q_COREAPP_STARTUP_FUNCTION(registerTypes)

#endif // REGISTERATIONS_H
