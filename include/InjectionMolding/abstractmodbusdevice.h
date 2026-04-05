#ifndef ABSTRACTMODBUSDEVICE_H
#define ABSTRACTMODBUSDEVICE_H

#include <WeaCore/utils.h>
#include <QHash>
#include <QModbusDataUnit>

class AbstractModbusDevice : public QObject
{
        Q_OBJECT
        W_PROP_HDEF(bool, enabled, Enabled, false)
        W_PROP_HDEF(int, slaveAddress, SlaveAddress, 2) // REQUIRED
    public:

        explicit AbstractModbusDevice(QObject* parent = nullptr);

        Q_INVOKABLE int readOnceBufferSize() const;
        Q_INVOKABLE int writeOnceBufferSize() const;
        Q_INVOKABLE int writeBufferSize() const;
        Q_INVOKABLE int readBufferSize() const;

        Q_INVOKABLE bool pushToWriteBuffer(int address,
                                           const QVector<quint16>& values,
                                           QModbusDataUnit::RegisterType registerType = QModbusDataUnit::HoldingRegisters);

        bool pushToWriteBuffer(const QModbusDataUnit& writeUnit);

        virtual void writeValuToProperty(int address, quint16 value) = 0;

        virtual void clearWriteBuffer();

        virtual const QList<QModbusDataUnit>& readOnceBuffer() const;
        virtual const QList<QModbusDataUnit>& writeOnceBuffer() const;
        virtual const QList<QModbusDataUnit>& writeBuffer() const;
        virtual const QList<QModbusDataUnit>& readBuffer() const;

    protected:
        QList<QModbusDataUnit> m_readOnceBuffer;
        QList<QModbusDataUnit> m_writeOnceBuffer;
        QList<QModbusDataUnit> m_writeBuffer;
        QList<QModbusDataUnit> m_readBuffer;
        QHash<int, int> m_addrToSize; // hex start address, size of the address

};

#endif // ABSTRACTMODBUSDEVICE_H
