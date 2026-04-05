#include "../include/InjectionMolding/modbuscom.h"

#include "../include/InjectionMolding/SerialConnection.h"
#include "../include/InjectionMolding/AlarmModel.h"

#include <QDebug>

ModbusCom::ModbusCom(QObject* parent)
    : QModbusRtuSerialMaster(parent)
{
}

ModbusCom::~ModbusCom()
{
    closePort();
}

void ModbusCom::classBegin()
{

}

void ModbusCom::componentComplete()
{
    isSerialConnValid();
    applyConfigs();
}

bool ModbusCom::isSerialConnValid() const
{
    if (!m_serialConn)
    {
        qCritical() << "SerialConnection is nullptr! ";
        Q_ASSERT(m_serialConn);
        return false;
    }
    return true;
}

bool ModbusCom::isConnected() const
{
    if (!isSerialConnValid())
    {
        return false;
    }

    return m_serialConn->connected();
}

bool ModbusCom::openPort()
{
    if (isConnected())
    {
        emit errorRaised("Port is already Open on this Device!");
        return false;
    }

    if (!applyConnectionSettings())
    {
        return false;
    }

    if (!connectDevice())
    {
        emit errorRaised(errorString());
        return false;
    }

    return true;
}

void ModbusCom::closePort()
{
    // NOTE: Make sure the stateChanged signal will change connected property as UnconnectedState.
    if (isConnected())
    {
        disconnectDevice();
    }
}

void ModbusCom::addAlarm(int alarmCode)
{
    AlarmModel::getInstance().addAlarm(alarmCode, getAlarmDesc(alarmCode), getAlarmCodeStr(alarmCode));
}

void ModbusCom::removeAlarm(int alarmCode)
{
    AlarmModel::getInstance().removeAlarm(alarmCode);
}

QString ModbusCom::getAlarmCodeStr(int alarmCode)
{
    return QString("%1%2").arg(objectName()).arg(objectID());
}

QString ModbusCom::getAlarmDesc(int alarmCode)
{
    switch (alarmCode)
    {
        case AlarmsCode::SerialDisconnected:
            return "Serial Port is disconnect";
        default:
            return errorString();
    };
    return QString();
}

QString ModbusCom::stateString(int state)
{
    switch (state)
    {
        case QModbusDevice::UnconnectedState:
            return "UnconnectedState";
        case QModbusDevice::ConnectingState:
            return "ConnectingState";
        case QModbusDevice::ConnectedState:
            return "ConnectedState";
        case QModbusDevice::ClosingState:
            return "ClosingState";
        default:
            return QString("InvalidState: %1").arg(state);
    }
    return QString();
}

bool ModbusCom::applyConnectionSettings()
{
    if (!isSerialConnValid())
    {
        return false;
    }

    qDebug() << "ConnectionParams: "
             << m_serialConn->portName()
             << m_serialConn->parity()
             << m_serialConn->baudRate()
             << m_serialConn->dataBits()
             << m_serialConn->stopBits();

    setConnectionParameter(QModbusDevice::SerialPortNameParameter, m_serialConn->portName());
    setConnectionParameter(QModbusDevice::SerialParityParameter,   m_serialConn->parity());
    setConnectionParameter(QModbusDevice::SerialBaudRateParameter, m_serialConn->baudRate());
    setConnectionParameter(QModbusDevice::SerialDataBitsParameter, m_serialConn->dataBits());
    setConnectionParameter(QModbusDevice::SerialStopBitsParameter, m_serialConn->stopBits());

    // Other Settings
    // setTimeout(1000); // This class has timeout property already
    // setNumberOfRetries(); // ...

    return true;
}

void ModbusCom::applyConfigs()
{
    /** Make Connection Signals **/
    connect(this, &QModbusClient::errorOccurred, [ this ](QModbusDevice::Error code)
    {
        // qCritical() << "Modbus Error: " << errorString() << code;
        // QML signal
        emit errorRaised(errorString());

        /** Binding Alarm **/
        addAlarm(code);
    });

    connect(this, &QModbusClient::stateChanged, [this](int state)
    {
        qInfo() << "Modbus State: " << ModbusCom::stateString(state);
        // QML should use `connected` property
        m_serialConn->setConnected(state != QModbusDevice::UnconnectedState);
    });

    /** Binding Alarms **/
    // connect(m_serialConn, &SerialConnection::connectedChanged, this, [ = ]()
    // {
    //     if (isConnected())
    //     {
    //         removeAlarm(AlarmsCode::SerialDisconnected);
    //     }
    //     else
    //     {
    //         addAlarm(AlarmsCode::SerialDisconnected);
    //     }
    // });
}

void ModbusCom::timerEvent(QTimerEvent* event)
{

}
