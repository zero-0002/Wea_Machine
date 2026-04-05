#include "../include/InjectionMolding/abstractmodbusdevice.h"

#include <QVariant>
#include <QDebug>

AbstractModbusDevice::AbstractModbusDevice(QObject* parent)
    : QObject{parent}
{}

int AbstractModbusDevice::readOnceBufferSize() const
{
    return m_readOnceBuffer.count();
}

int AbstractModbusDevice::writeOnceBufferSize() const
{
    return m_writeOnceBuffer.count();
}

int AbstractModbusDevice::writeBufferSize() const
{
    return m_writeBuffer.count();
}

int AbstractModbusDevice::readBufferSize() const
{
    return m_readBuffer.count();
}

bool AbstractModbusDevice::pushToWriteBuffer(int address, const QVector<quint16>& values, QModbusDataUnit::RegisterType registerType)
{
    if (!enabled())
    {
        qWarning() << " ModbusDevice is disabled! slaveID: " << slaveAddress();
        return false;
    }
    return pushToWriteBuffer(QModbusDataUnit(registerType, address, values));
}

bool AbstractModbusDevice::pushToWriteBuffer(const QModbusDataUnit& writeUnit)
{
    if (!enabled())
    {
        qWarning() << " ModbusDevice is disabled! slaveID: " << slaveAddress();
        return false;
    }
    m_writeBuffer.append(writeUnit);
    return false;
}

void AbstractModbusDevice::clearWriteBuffer()
{
    m_writeBuffer.clear();
}

const QList<QModbusDataUnit>& AbstractModbusDevice::readOnceBuffer() const
{
    return m_readOnceBuffer;
}

const QList<QModbusDataUnit>& AbstractModbusDevice::writeOnceBuffer() const
{
    return m_writeOnceBuffer;
}

const QList<QModbusDataUnit>& AbstractModbusDevice::writeBuffer() const
{
    return m_writeBuffer;
}

const QList<QModbusDataUnit>& AbstractModbusDevice::readBuffer() const
{
    return m_readBuffer;
}
