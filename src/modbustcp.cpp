#include "../include/InjectionMolding/modbustcp.h"

#include "../include/InjectionMolding/TcpConnection.h"
#include "../include/InjectionMolding/abstractmodbusdevice.h"
#include "../include/InjectionMolding/AlarmModel.h"

#include <QTimerEvent>
#include <QThread>
#include <QDebug>

ModbusTcp::ModbusTcp(QObject* parent)
    : QModbusTcpClient(parent)
{

    connect(this, &ModbusTcp::requestForSendWrite, this, [ = ](AbstractModbusDevice * device, int slaveAddress)
    {
    });
}

ModbusTcp::~ModbusTcp()
{
    closePort();

    if (m_thread)
    {
        m_thread->quit();
        m_thread->wait();
        delete m_thread;
    }
}

void ModbusTcp::classBegin()
{
    /** Connections **/

    // Binding Alarm
    connect(this, &ModbusTcp::errorRaised, this, [ = ](int code, QString msg, int slaveAddress)
    {
        int errCode = code;
        if (slaveAddress > -1)
        {
            errCode += slaveAddress;
        }
        addAlarm(errCode, msg);
    });
}

void ModbusTcp::componentComplete()
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

    isTcpConnValid();
    applyConfigs();

    /** Connections **/
    connect(m_tcpConn, &TcpConnection::connectedChanged, this, [ = ]()
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

bool ModbusTcp::isTcpConnValid() const
{
    if (!m_tcpConn)
    {
        qCritical() << "TcpConnection is nullptr! ";
        Q_ASSERT(m_tcpConn);
        return false;
    }
    return true;
}

bool ModbusTcp::isConnected() const
{
    if (!isTcpConnValid())
    {
        return false;
    }

    return m_tcpConn->connected();
}

AbstractModbusDevice* ModbusTcp::getDevice(int slaveAddress) const
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

bool ModbusTcp::openPort()
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

void ModbusTcp::closePort()
{
    // NOTE: Make sure the stateChanged signal will change connected property as UnconnectedState.
    if (isConnected())
    {
        disconnectDevice();
    }
}

void ModbusTcp::addAlarm(int alarmCode)
{
    addAlarm(alarmCode, getAlarmDesc(alarmCode));
}

void ModbusTcp::addAlarm(int alarmCode, const QString& desc)
{
    AlarmModel::getInstance().addAlarm(alarmCode, desc, getAlarmCodeStr(alarmCode));
}

void ModbusTcp::removeAlarm(int alarmCode)
{
    AlarmModel::getInstance().removeAlarm(alarmCode);
}

QString ModbusTcp::getAlarmCodeStr(int alarmCode)
{
    return QString("%1%2").arg(objectName()).arg(objectID());
}

QString ModbusTcp::getAlarmDesc(int alarmCode)
{
    switch (alarmCode)
    {
        case AlarmsCode::TcpDisconnected:
            return "Serial Port is disconnect";
        default:
            return errorString();
    };
    return QString();
}

QString ModbusTcp::stateString(int state)
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

bool ModbusTcp::applyConnectionSettings()
{
    if (!isTcpConnValid())
    {
        return false;
    }

    qDebug() << "ConnectionParams: "
             << m_tcpConn->host()
             << m_tcpConn->port();

    setConnectionParameter(QModbusDevice::NetworkPortParameter, m_tcpConn->port());
    setConnectionParameter(QModbusDevice::NetworkAddressParameter,   m_tcpConn->host());
    device()->setProperty("proxy", QVariant());

    // Other Settings
    // setTimeout(1000); // This class has timeout property already
    // setNumberOfRetries(); // ...

    return true;
}

void ModbusTcp::applyConfigs()
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
        qInfo() << "Modbus State: " << ModbusTcp::stateString(state);
        // QML should use `connected` property
        m_tcpConn->setConnected(state != QModbusDevice::UnconnectedState);
    });

    /** Binding Alarms **/
    // connect(m_tcpConn, &TcpConnection::connectedChanged, this, [ = ]()
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

void ModbusTcp::timerEvent(QTimerEvent* event)
{
    if (event->timerId() == m_refreshTmr.timerId())
    {
        updateFrame();
    }

}

void ModbusTcp::updateFrame()
{
    for (auto& device : qAsConst(m_devices))
    {
        int slaveAddress = device->slaveAddress();

        // write Requests
        for (auto& writeUnit : qAsConst(device->writeBuffer()))
        {
            writeRequest(writeUnit, slaveAddress);
        }
        // emit sendWriteRequests(device, slaveAddress);
        // auto* thread = QThread::create([&]()
        // {
        //     sendWriteRequests(device, slaveAddress);
        // });
        // connect(thread, &QThread::finished, thread, &QThread::deleteLater);
        // thread->start();
        // qDebug() << "Starting Thread:";

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

void ModbusTcp::readRequest(const QModbusDataUnit& unit, int slaveAddress)
{

    if (auto* reply = sendReadRequest(unit, slaveAddress))
    {
        if (!reply->isFinished())
        {
            connect(reply, &QModbusReply::finished, this, &ModbusTcp::readReady);
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

void ModbusTcp::writeRequest(const QModbusDataUnit& unit, int slaveAddress)
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

void ModbusTcp::readWriteRequest(const QModbusDataUnit& writeUnit, const QModbusDataUnit& readUnit, int slaveAddress)
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
            connect(reply, &QModbusReply::finished, this, &ModbusTcp::readReady);
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

void ModbusTcp::readReady()
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

void ModbusTcp::sendWriteRequests(AbstractModbusDevice* device, int slaveAddress)
{
    qDebug() << "onSendWriteRequests: " << device->writeBuffer().count() << slaveAddress;
    for (auto& writeUnit : qAsConst(device->writeBuffer()))
    {
        writeRequest(writeUnit, slaveAddress);
    }

    device->clearWriteBuffer();
    qDebug() << "Device Buffer has cleared: " << device->writeBuffer().count() << slaveAddress;

}
