#ifndef SERVOMODBUSDEVICE_H
#define SERVOMODBUSDEVICE_H

#include "abstractmodbusdevice.h"
#include "ServoUnions.h"
#include "Addresses.h"


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

        RO_MOD_PROP(bool, do1, m_digitalOutputs.do1); // SRDY
        RO_MOD_PROP(bool, do2, m_digitalOutputs.do2); // ZSPD
        RO_MOD_PROP(bool, do3, m_digitalOutputs.do3); // HOME
        RO_MOD_PROP(bool, do4, m_digitalOutputs.do4); // TPOS
        RO_MOD_PROP(bool, do5, m_digitalOutputs.do5); // ALRM

        /** User friendly Props (using at Steps and automation) **/
        W_PROP_HDEF(int, posActiveDelay, PosActiveDelay, 50) // millisecond
        W_PROP_HDEF(int, triggerDelay, TriggerDelay, 150) // millisecond
        // W_PROP_HDEF(int, triggerOffDelay, TriggerOffDelay, 250) // millisecond

        RO_MOD_PROP(bool, ctrgActive, m_digitalInputs.di4);

        RO_MOD_PROP(bool, homingComplete, m_digitalOutputs.do3);
        RO_MOD_PROP(bool, tposFeedback, m_digitalOutputs.do4);
        RO_MOD_PROP(bool, availableToHome, (m_digitalOutputs.do1&& m_digitalOutputs.do5)); // ZSPD, TPOS, HOME are not included
        RO_MOD_PROP(bool, availableToRun, (m_digitalOutputs.do1&& m_digitalOutputs.do3&& m_digitalOutputs.do4&& m_digitalOutputs.do5)); // ZSPD isn't included

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

        Q_INVOKABLE bool gotoHome();

        Q_INVOKABLE bool gotoPosition(qint32 path);
        Q_INVOKABLE bool gotoPosition(qint32 path, quint16 speed, quint16 ramp);

        /** Utils **/
        static QString getAlarmDesc(int code);

    signals:
        void tposStateChanged(bool edgeType); // True === rising edge, false === falling edge
        void positionStarted();
        void positionCompleted();


    protected:
        void emitDigitalInputs();
        void emitDigitalOutputs();

    private:
        void updateTposState(bool currentState); // Rising/Falling edge trigger
        QString outputsStateStr() const;


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

        /** Internal **/
        bool m_prevTposState = true; // True because TPOS turns off when is running and we need rising edge trigger
};

#endif // SERVOMODBUSDEVICE_H
