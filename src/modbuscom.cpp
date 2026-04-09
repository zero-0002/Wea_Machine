#include "../include/InjectionMolding/modbuscom.h"

#include "../include/InjectionMolding/SerialConnection.h"
#include "../include/InjectionMolding/abstractmodbusdevice.h"
#include "../include/InjectionMolding/AlarmModel.h"

#include <QTimerEvent>
#include <QThread>
#include <QDebug>

ModbusCom::ModbusCom(QObject* parent)
    : QModbusRtuSerialMaster(parent)
{
}

ModbusCom::~ModbusCom()
{
    closePort();

    if (m_thread)
    {
        m_thread->quit();
        m_thread->wait();
        delete m_thread;
    }
}

void ModbusCom::classBegin()
{
    /** Connections **/

    // Binding Alarm
    connect(this, &ModbusCom::errorRaised, this, [ = ](int code, QString msg, int slaveAddress)
    {
        int errCode = code;
        if (slaveAddress > -1)
        {
            errCode += slaveAddress;
        }
        addAlarm(errCode, msg);
    });
}

void ModbusCom::componentComplete()
{
    if (m_threaded)
    {
        m_thread = new QThread(this);
        this->moveToThread(m_thread);
        connect(m_thread, &QThread::started, this, [ = ]()
        {
            qDebug() << "Thread has started: ";
        });
        m_thread->start();
    }

    isSerialConnValid();
    applyConfigs();

    /** Connections **/
    connect(m_serialConn, &SerialConnection::connectedChanged, this, [ = ]()
    {
        if (isConnected())
        {
            // Start Refresh Timer
            m_refreshTmr.start(m_refreshInterval, this);
        }
        else
        {
            // Stop Refresh Timer
            m_refreshTmr.stop();

        }

        // Enable/Disable Devices
        for (int i(0); i < m_devices.size(); ++i)
        {
            m_devices[i]->setEnabled(isConnected());
            m_isFirstFrame[m_devices[i]->slaveAddress()] = true;
        }
    });
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

AbstractModbusDevice* ModbusCom::getDevice(int slaveAddress) const
{
    for (int i(0); i < m_devices.size(); ++i)
    {
        if (m_devices[i]->slaveAddress() == slaveAddress)
        {
            return m_devices[i];
        }
    }

    return nullptr;
}

bool ModbusCom::openPort()
{
    if (isConnected())
    {
        emit errorRaised(1001, "Port is already Open on this Device!");
        return false;
    }

    if (!applyConnectionSettings())
    {
        return false;
    }

    if (!connectDevice())
    {
        emit errorRaised(error(), errorString());
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
    addAlarm(alarmCode, getAlarmDesc(alarmCode));
}

void ModbusCom::addAlarm(int alarmCode, const QString& desc)
{
    AlarmModel::getInstance().addAlarm(alarmCode, desc, getAlarmCodeStr(alarmCode));
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
        emit errorRaised(code, errorString());

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
    if (event->timerId() == m_refreshTmr.timerId())
    {
        updateFrame();
    }

}

void ModbusCom::updateFrame()
{
    for (auto& device : qAsConst(m_devices))
    {
        int slaveAddress = device->slaveAddress();

        // write Requests
        for (auto& writeUnit : qAsConst(device->writeBuffer()))
        {
            writeRequest(writeUnit, slaveAddress);
        }

        // ReadOnce Requests (Only when an specified request is raised)
        if (device->writeBufferSize() > 0 || m_isFirstFrame[slaveAddress])
        {
            for (auto& readOnceUnit : qAsConst(device->readOnceBuffer()))
            {
                readRequest(readOnceUnit, slaveAddress);
            }
        }

        // writeOnce Requests (Right now is write always instead writeOnce)
        for (auto& writeOnceUnit : qAsConst(device->writeOnceBuffer()))
        {
            writeRequest(writeOnceUnit, slaveAddress);
        }


        // read Requests
        for (auto& readUnit : qAsConst(device->readBuffer()))
        {
            readRequest(readUnit, slaveAddress);
        }

        /** Clearing for next frame **/
        m_isFirstFrame[slaveAddress] = false;
        device->clearWriteBuffer();
    }
}

void ModbusCom::readRequest(const QModbusDataUnit& unit, int slaveAddress)
{

    if (auto* reply = sendReadRequest(unit, slaveAddress))
    {
        if (!reply->isFinished())
        {
            connect(reply, &QModbusReply::finished, this, &ModbusCom::readReady);
        }
        else
        {
            delete reply;    // broadcast replies return immediately
        }
    }
    else
    {
        const auto errMsg = QString("Read error at slave: %1  %2").arg(slaveAddress).arg(errorString());
        emit errorRaised(error(), errMsg, slaveAddress);
    }
}

void ModbusCom::writeRequest(const QModbusDataUnit& unit, int slaveAddress)
{

    QModbusDataUnit::RegisterType table = unit.registerType();
    for (int i = 0, total = int(unit.valueCount()); i < total; ++i)
    {
        if (table == QModbusDataUnit::Coils)
        {
            // unit.setValue(i, writeModel->m_coils[i + writeUnit.startAddress()]);
        }
        else
        {
            // writeUnit.setValue(i, writeModel->m_holdingRegisters[i + writeUnit.startAddress()]);
        }
    }

    if (auto* reply = sendWriteRequest(unit, slaveAddress))
    {
        if (!reply->isFinished())
        {
            connect(reply, &QModbusReply::finished, this, [this, reply]()
            {
                if (reply->error() == QModbusDevice::ProtocolError)
                {
                    const auto errMsg = QString("Write response at slaveAddress %1 error: %2 (Mobus exception: 0x%3)").
                                        arg(reply->serverAddress()).
                                        arg(reply->errorString()).
                                        arg(reply->rawResult().exceptionCode(), -1, 16);
                    emit errorRaised(reply->error(), errMsg, reply->serverAddress());
                }
                else if (reply->error() != QModbusDevice::NoError)
                {
                    const auto errMsg = QString("Write response at slaveAddress %1 error: %2 (code: 0x%3)").
                                        arg(reply->serverAddress()).
                                        arg(reply->errorString()).
                                        arg(reply->error(), -1, 16);
                    emit errorRaised(reply->error(), errMsg, reply->serverAddress());
                }
                reply->deleteLater();
            });
        }
        else
        {
            // broadcast replies return immediately
            reply->deleteLater();
        }
    }
    else
    {
        const auto errMsg = QString("Write error at slaveAddress %1: %2").
                            arg(slaveAddress).
                            arg(errorString());
        emit errorRaised(error(), errMsg, slaveAddress);
    }
}

void ModbusCom::readWriteRequest(const QModbusDataUnit& writeUnit, const QModbusDataUnit& readUnit, int slaveAddress)
{

    QModbusDataUnit::RegisterType table = writeUnit.registerType();
    for (int i = 0, total = int(writeUnit.valueCount()); i < total; ++i)
    {
        if (table == QModbusDataUnit::Coils)
        {
            // writeUnit.setValue(i, writeModel->m_coils[i + writeUnit.startAddress()]);
        }
        else
        {
            // writeUnit.setValue(i, writeModel->m_holdingRegisters[i + writeUnit.startAddress()]);
        }
    }

    if (auto* reply = sendReadWriteRequest(readUnit, writeUnit, slaveAddress))
    {
        if (!reply->isFinished())
        {
            connect(reply, &QModbusReply::finished, this, &ModbusCom::readReady);
        }
        else
        {
            delete reply;    // broadcast replies return immediately
        }
    }
    else
    {
        const auto errMsg = QString("Read error at slave: %1  %2").arg(slaveAddress).arg(errorString());
        emit errorRaised(error(), errMsg, slaveAddress);
    }
}

void ModbusCom::readReady()
{
    auto reply = qobject_cast<QModbusReply*>(sender());
    if (!reply)
    {
        return;
    }

    int slaveAddress = reply->serverAddress();
    if (reply->error() == QModbusDevice::NoError)
    {
        const QModbusDataUnit unit = reply->result();
        for (int i = 0, total = int(unit.valueCount()); i < total; ++i)
        {
            auto* device = getDevice(slaveAddress);
            device->writeValuToProperty(unit.startAddress() + i, unit.value(i));
            // const QString entry = tr("Address: %1, Value: %2").arg(unit.startAddress() + i)
            //                       .arg(QString::number(unit.value(i),
            //                               unit.registerType() <= QModbusDataUnit::Coils ? 10 : 16));
        }
    }
    else if (reply->error() == QModbusDevice::ProtocolError)
    {
        const auto errMsg = QString("Read response at slaveAdress %1 error: %2 (Mobus exception: 0x%3)").
                            arg(slaveAddress).
                            arg(reply->errorString()).
                            arg(reply->rawResult().exceptionCode(), -1, 16);
        emit errorRaised(reply->error(), errMsg, slaveAddress);
    }
    else
    {
        const auto errMsg = QString("Read response at slaveAddress %1 error: %2 (code: 0x%3)").
                            arg(slaveAddress).
                            arg(reply->errorString()).
                            arg(reply->error(), -1, 16);
        emit errorRaised(reply->error(), errMsg, slaveAddress);
    }

    reply->deleteLater();
}
