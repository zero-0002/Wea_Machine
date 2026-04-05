#ifndef MODBUSCOM_H
#define MODBUSCOM_H

#include <WeaCore/utils.h>
#include <QModbusRtuSerialMaster>
#include <QBasicTimer>
#include <QHash>
#include <QQmlParserStatus>

class SerialConnection;
class AbstractModbusDevice;
class ModbusCom : public QModbusRtuSerialMaster, public QQmlParserStatus
{
        Q_OBJECT
        // Which Port and with which options should be open?
        W_PROP_HDEF(int, objectID, ObjectID, -1) // REQUIRED
        W_PROP_HDEF(SerialConnection*, serialConn, SerialConn, nullptr) // REQUIRED
        W_PROP_HDEF(QList<AbstractModbusDevice*>, devices, Devices, {}) // millisecond (cannot be change after connected)
        W_PROP_HDEF(bool, threaded, Threaded, false)

        W_PROP_HDEF(int, numberOfRetries, NumberOfRetries, 3)
        W_PROP_HDEF(int, refreshInterval, RefreshInterval, 100) // millisecond (cannot be change after connected)

    public:

        enum AlarmsCode
        {
            SerialDisconnected = 1000,
        };

        explicit ModbusCom(QObject* parent = nullptr);
        ~ModbusCom();

        void classBegin() override;
        void componentComplete() override;

        bool isSerialConnValid() const;
        bool isConnected() const;

        AbstractModbusDevice* getDevice(int slaveAddress) const;

        /** QML Methods **/
        Q_INVOKABLE bool openPort(); // Connect
        Q_INVOKABLE void closePort(); // Disconnect

        Q_INVOKABLE void addAlarm(int alarmCode);
        Q_INVOKABLE void addAlarm(int alarmCode, const QString& desc);
        Q_INVOKABLE void removeAlarm(int alarmCode);
        Q_INVOKABLE QString getAlarmCodeStr(int alarmCode);
        Q_INVOKABLE QString getAlarmDesc(int alarmCode);

        /** Statics **/
        static QString stateString(int state);
    signals:
        void errorRaised(int errCode, QString erroMsg);

    protected:
        bool applyConnectionSettings();
        void applyConfigs();
        void timerEvent(QTimerEvent* event) override;

    protected slots:
        void updateFrame();
        void readRequest(const QModbusDataUnit& unit, int slaveAddress);
        void writeRequest(const QModbusDataUnit& unit, int slaveAddress);
        void readWriteRequest(const QModbusDataUnit& writeUnit, const QModbusDataUnit& readUnit, int slaveAddress);
        void readReady();

    private:
        QThread* m_thread = nullptr;
        QBasicTimer m_refreshTmr;
        QHash<int, bool> m_isFirstFrame; // slaveAddress, is first frame
        // QHash<int, AbstractModbusDevice*> m_addrToDevice; // slaveAddress, Device (sync with m_devices)
};

#endif // MODBUSCOM_H
