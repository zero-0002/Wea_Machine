#ifndef SERIALGLOBAL_H
#define SERIALGLOBAL_H

#include <QSerialPortInfo>
#include <QSerialPort>
#include <QDebug>

#define RO_PROP(type, name) \
        Q_PROPERTY(type name READ name NOTIFY name##Changed) \
    public: \
        Q_SIGNAL void name##Changed(); \
    private:


class SerialGlobal : public QObject
{
        Q_OBJECT
        RO_PROP(QStringList, availablePorts)
        RO_PROP(QStringList, baudRates)
        RO_PROP(QStringList, parities)
        RO_PROP(QStringList, stopBits)
    public:
        explicit SerialGlobal(QObject* parent = nullptr)
            : QObject{parent}
        {
            refreshPorts();
        }

        Q_INVOKABLE QStringList availablePorts() const
        {
            return m_serialPorts;
        }

        Q_INVOKABLE QStringList baudRates() const
        {
            static QStringList res =
            {
                "1200",
                "2400",
                "4800",
                "9600",
                "19200",
                "38400",
                "115200"
            };
            return res;
        }

        Q_INVOKABLE QStringList parities() const
        {
            return
            {
                "Even",
                "Odd",
                "None"
            };
        }

        Q_INVOKABLE QStringList stopBits() const
        {
            return
            {
                "One",
                "Two"
            };
        }

        Q_INVOKABLE QList<int> dataBits() const
        {
            return
            {
                8,
                7
            };
        }

        Q_INVOKABLE int mapToBaudRate(const QString& value) const
        {
            return SerialGlobal::MapToBaudRate(value);
        }
        Q_INVOKABLE int mapToParity(const QString& value) const
        {
            return SerialGlobal::MapToParity(value);
        }
        Q_INVOKABLE int mapToStopBits(const QString& value) const
        {
            return SerialGlobal::MapToStopBits(value);
        }
        Q_INVOKABLE int mapToDataBits(const QString& value) const
        {
            return SerialGlobal::MapToDataBits(value);
        }

        Q_INVOKABLE void refreshPorts()
        {
            QList<QSerialPortInfo> ports = QSerialPortInfo::availablePorts();

            m_serialPorts.clear();
            for (auto& port  : qAsConst(ports))
            {
                m_serialPorts.append(port.portName());
            }
            emit availablePortsChanged();
        }

        // Convertion functions
        inline static int MapToBaudRate(const QString& strBaudRate)
        {
            static QHash<QString, int> resHash
            {
                {"1200", QSerialPort::Baud1200},
                {"2400", QSerialPort::Baud2400},
                {"4800", QSerialPort::Baud4800},
                {"9600", QSerialPort::Baud9600},
                {"19200", QSerialPort::Baud19200},
                {"38400", QSerialPort::Baud38400},
                {"115200", QSerialPort::Baud115200},
            };
            return resHash[strBaudRate];
        }

        inline static int MapToParity(const QString& strParity)
        {
            static QHash<QString, int> resHash
            {
                {"None", QSerialPort::NoParity},
                {"Even", QSerialPort::EvenParity},
                {"Odd", QSerialPort::OddParity},
            };
            return resHash[strParity];
        }

        inline static int MapToStopBits(const QString& strStopBits)
        {
            static QHash<QString, int> resHash
            {
                {"One", QSerialPort::OneStop},
                {"Two", QSerialPort::TwoStop},
            };
            return resHash[strStopBits];
        }

        inline static int MapToDataBits(const QString& dataBit)
        {
            static QHash<QString, int> resHash
            {
                {"7", QSerialPort::Data7},
                {"8", QSerialPort::Data8},
            };
            return resHash[dataBit];
        }

    private:
        QStringList m_serialPorts;

};


#endif // SERIALGLOBAL_H
