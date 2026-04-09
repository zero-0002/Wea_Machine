#ifndef SERVOMODBUSDEVICE_H
#define SERVOMODBUSDEVICE_H

#include "abstractmodbusdevice.h"
#include "ServoUnions.h"
#include "Addresses.h"

// Modbus declarative read-only property
#define RO_MOD_PROP(type, name, assignment) \
    Q_PROPERTY(type name READ name NOTIFY name##Changed) \
    public: \
        type name() const { return assignment; } \
        Q_SIGNAL void name##Changed(); \
    private:


class ServoModbusDevice : public AbstractModbusDevice
{
        Q_OBJECT
        RO_MOD_PROP(qint16, torqueLimit, m_torqueLimit.value);
        RO_MOD_PROP(quint16, jogSpeed, m_jogSpeed.value);
        RO_MOD_PROP(quint16, jogAcc, m_jogAcc.value);
        RO_MOD_PROP(quint16, jogDec, m_jogDec.value);

        RO_MOD_PROP(qint32, pathData1, m_pathData1.value);
        RO_MOD_PROP(quint16, speedData0, m_speedData0.value);
        RO_MOD_PROP(quint16, rampData0, m_rampData0.value);
        RO_MOD_PROP(quint16, rampData1, m_rampData1.value);

        RO_MOD_PROP(bool, di1, m_digitalInputs.di1);
        RO_MOD_PROP(bool, di2, m_digitalInputs.di2);
        RO_MOD_PROP(bool, di3, m_digitalInputs.di3);
        RO_MOD_PROP(bool, di4, m_digitalInputs.di4);
        RO_MOD_PROP(bool, di5, m_digitalInputs.di5);
        RO_MOD_PROP(bool, di9, m_digitalInputs.di9);
        RO_MOD_PROP(bool, di10, m_digitalInputs.di10);
        RO_MOD_PROP(bool, di11, m_digitalInputs.di11);
        RO_MOD_PROP(bool, di12, m_digitalInputs.di12);
        RO_MOD_PROP(bool, di13, m_digitalInputs.di13);
        RO_MOD_PROP(bool, di14, m_digitalInputs.di14);

        RO_MOD_PROP(quint16, alarms, m_alarms);

        /** Readonly Variables **/
        RO_MOD_PROP(qint32, encoderPUU, m_encoderPUU.value);
        RO_MOD_PROP(float, currentSpeed, qAbs(static_cast<float>(m_currentSpeed.value) / 10.0f));
        RO_MOD_PROP(qint16, currentTorque, qAbs(m_currentTorque.value));

        RO_MOD_PROP(bool, di6, m_digitalInputs.di6);
        RO_MOD_PROP(bool, di7, m_digitalInputs.di7);
        RO_MOD_PROP(bool, di8, m_digitalInputs.di8);

        RO_MOD_PROP(bool, do1, m_digitalOutputs.do1);
        RO_MOD_PROP(bool, do2, m_digitalOutputs.do2);
        RO_MOD_PROP(bool, do3, m_digitalOutputs.do3);
        RO_MOD_PROP(bool, do4, m_digitalOutputs.do4);
        RO_MOD_PROP(bool, do5, m_digitalOutputs.do5);

        using TParams = ServoA2Params;
        using TAlarms = ServoA2Alarms;
    public:

        explicit ServoModbusDevice(QObject* parent = nullptr);

        void writeValuToProperty(int address, quint16 value) override;

        // Write
        Q_INVOKABLE bool pushTorqueLimit(qint16 value);

        Q_INVOKABLE bool pushJogSpeed(quint16 value);
        Q_INVOKABLE bool pushJogAcc(quint16 value);
        Q_INVOKABLE bool pushJogDec(quint16 value);

        Q_INVOKABLE bool pushPathData1(qint32 value);
        Q_INVOKABLE bool pushSpeed0(quint16 value);
        Q_INVOKABLE bool pushRamp0(quint16 value);
        Q_INVOKABLE bool pushRamp1(quint16 value);

        Q_INVOKABLE bool pushDi1(bool value); // Servo On
        Q_INVOKABLE bool pushDi2(bool value); // POS0
        Q_INVOKABLE bool pushDi3(bool value); // POS1
        Q_INVOKABLE bool pushDi4(bool value); // CTRG
        Q_INVOKABLE bool pushDi9(bool value); // JOG FWD
        Q_INVOKABLE bool pushDi10(bool value); // JOG REV

        /** Commands **/
        Q_INVOKABLE void applyPos0();
        Q_INVOKABLE void triggerCTRG();
        Q_INVOKABLE bool resetAlarms();

        /** Utils **/
        static QString getAlarmDesc(int code);
    protected:
        void emitDigitalInputs();
        void emitDigitalOutputs();

    private:
        /** Union Variables **/
        Torque m_torqueLimit;

        JogSpeed m_jogSpeed;
        Ramp m_jogAcc;
        Ramp m_jogDec;

        EncoderPUU m_pathData1;
        JogSpeed m_speedData0;
        Ramp m_rampData0;
        Ramp m_rampData1;

        DigitalInputs m_digitalInputs;

        quint16 m_alarms;

        /** Readonly Variables **/
        EncoderPUU m_encoderPUU;
        Speed m_currentSpeed;
        Torque m_currentTorque;
        DigitalOutputs m_digitalOutputs;
};

#endif // SERVOMODBUSDEVICE_H
