#ifndef ABSTRACTMODBUSDEVICE_H
#define ABSTRACTMODBUSDEVICE_H

#include <WeaCore/utils.h>
#include <QHash>
#include <QTimer>
#include <QEventLoop>
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

        /*!
         * \brief waitForReply Blocking method that wait for target value is set is equal with condition param
         * \param target
         * \param timeout
         * \param condition
         * \return true if target == condition else false
         */
        template <typename SourceClass = AbstractModbusDevice,
                  typename Target,
                  typename Signal,
                  typename Condition>
        inline bool waitForReply(SourceClass* src,
                                 const Target& target,
                                 Signal targetSiganl,
                                 Condition condition,
                                 int timeout) const
        {
            bool result = false;

            QEventLoop loop;
            QTimer timeoutTmr;

            timeoutTmr.setInterval(timeout);

            connect(&timeoutTmr, &QTimer::timeout, &loop, [&]()
            {
                if (target == condition)
                {
                    result = true;
                }
                loop.quit();
            });

            connect(src, targetSiganl, &loop, [&]()
            {
                if (target == condition)
                {
                    result = true;
                    loop.quit();
                }
            });

            timeoutTmr.start();
            loop.exec();

            return result;
        }


        QList<QModbusDataUnit> m_readOnceBuffer;
        QList<QModbusDataUnit> m_writeOnceBuffer;
        QList<QModbusDataUnit> m_writeBuffer;
        QList<QModbusDataUnit> m_readBuffer;
        QHash<int, int> m_addrToSize; // hex start address, size of the address

};

#endif // ABSTRACTMODBUSDEVICE_H
