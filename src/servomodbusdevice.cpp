#include "../include/InjectionMolding/servomodbusdevice.h"
#include "../include/InjectionMolding/AlarmModel.h"

#include <QDebug>
#include <QTimer>

ServoModbusDevice::ServoModbusDevice(QObject* parent)
    : AbstractModbusDevice{parent}
{
    /** Filling Constant values **/

    // Addr To Size
    m_addrToSize =
    {
        { RW_ENABLE_DI_SI, 2},
        { RW_DI, 2},
        { RO_DO, 2},
        { RO_MONITOR_STATUS0, 2},
        { RO_MONITOR_STATUS1, 2},
        { RO_MONITOR_STATUS2, 2},
        { RO_MONITOR_STATUS3, 2},
        { RO_MONITOR_STATUS4, 2},

        { RW_ALARMS, 2},

        { RW_HOME_FIRST_SPD, 2},
        { RW_HOME_SECOND_SPD, 2},

        { RW_PATH1_DEF, 2},
        { RW_PATH1_DATA, 2},
        { RW_PATH2_DEF, 2},
        { RW_PATH2_DATA, 2},
        { RW_PATH63_DEF, 2},
        { RW_PATH63_DATA, 2},

        { RW_SPD0, 2},
        { RW_SPD1, 2},
        { RW_SPD15, 2},

        { RW_ACC_DEC0, 2},
        { RW_ACC_DEC1, 2},
        { RW_ACC_DEC15, 2},

        { RW_JOG_SPD, 2},
        { RW_JOG_ACC, 2},
        { RW_JOG_DEC, 2},

        { RW_TORQUE_LIMIT_VAL, 2},
    };

    // ReadOnce Buffer
    m_readOnceBuffer =
    {
        QModbusDataUnit(QModbusDataUnit::HoldingRegisters, RO_MONITOR_STATUS0, 10),
        // QModbusDataUnit(QModbusDataUnit::HoldingRegisters, RW_DI, 2),
        // QModbusDataUnit(QModbusDataUnit::HoldingRegisters, RO_DO, 2),
        // QModbusDataUnit(QModbusDataUnit::HoldingRegisters, RW_ALARMS, 2),
        QModbusDataUnit(QModbusDataUnit::HoldingRegisters, RW_JOG_SPD, 2),
        QModbusDataUnit(QModbusDataUnit::HoldingRegisters, RW_JOG_ACC, 2),
        QModbusDataUnit(QModbusDataUnit::HoldingRegisters, RW_JOG_DEC, 2),
        QModbusDataUnit(QModbusDataUnit::HoldingRegisters, RW_TORQUE_LIMIT_VAL, 2),
        QModbusDataUnit(QModbusDataUnit::HoldingRegisters, RW_PATH1_DATA, 2),
        QModbusDataUnit(QModbusDataUnit::HoldingRegisters, RW_SPD0, 2),
        QModbusDataUnit(QModbusDataUnit::HoldingRegisters, RW_ACC_DEC0, 2),
        QModbusDataUnit(QModbusDataUnit::HoldingRegisters, RW_ACC_DEC1, 2),
        QModbusDataUnit(QModbusDataUnit::HoldingRegisters, RW_HOME_FIRST_SPD, 2),
        QModbusDataUnit(QModbusDataUnit::HoldingRegisters, RW_HOME_SECOND_SPD, 2),
    };

    // WriteOnce Buffer
    m_writeOnceBuffer =
    {
        QModbusDataUnit(QModbusDataUnit::HoldingRegisters, RW_ENABLE_DI_SI, { 0x3B0F, 0x00}),
    };

    // Read Buffer
    m_readBuffer =
    {
        // QModbusDataUnit(QModbusDataUnit::HoldingRegisters, RW_JOG_ACC, 2),
        // QModbusDataUnit(QModbusDataUnit::HoldingRegisters, RW_JOG_SPD, 2),
        QModbusDataUnit(QModbusDataUnit::HoldingRegisters, RO_MONITOR_STATUS0, 10),
        QModbusDataUnit(QModbusDataUnit::HoldingRegisters, RW_DI, 2),
        QModbusDataUnit(QModbusDataUnit::HoldingRegisters, RO_DO, 2),
        QModbusDataUnit(QModbusDataUnit::HoldingRegisters, RW_ALARMS, 2),
        // QModbusDataUnit(QModbusDataUnit::HoldingRegisters, RW_TORQUE_LIMIT_VAL, 2),
    };

    /** Connections **/
    connect(this, &ServoModbusDevice::alarmsChanged, this, [ = ]()
    {
        // If alarm appears
        if (m_alarms > 0)
        {

            AlarmModel::getInstance().addAlarm(AlarmItem(m_alarms + slaveAddress(), getAlarmDesc(m_alarms), QString("ServoID%2").arg(slaveAddress())));
        }
        else
        {
            AlarmModel::getInstance().removeByCodePrefix(QString("ServoID%2").arg(slaveAddress()));
        }
    });

    // TPOS position reached
    connect(this, &ServoModbusDevice::tposStateChanged, this, [ = ](bool edgeType)
    {
        if (edgeType)
        {
            if (enabled())
            {
                qDebug() << "Rising Edge at TPOS (Position completed)" << enabled();
                emit positionCompleted();
            }
        }
        else
        {
            if (enabled())
            {
                qDebug() << "Falling Edge at TPOS (Positioning on Process" << enabled();
                emit positionStarted();
            }
        }
    });

}

void ServoModbusDevice::writeValuToProperty(int address, quint16 value)
{
    // qDebug() << __FUNCTION__ << "Address, value: " << address << value << m_digitalOutputs.value << m_digitalOutputs.do2;
    switch (address)
    {
        // Digital Inputs
        case RW_DI:
            m_digitalInputs.value = value;
            emitDigitalInputs();

            // Handlers for inputs
            if (m_digitalInputs.di4)
            {
                QTimer::singleShot(m_triggerDelay, this, [ = ]()
                {
                    pushDi4(false);
                });
            }

            break;
        case RW_DI + 1:
            break;

        // Digital Outputs
        case RO_DO:
            m_digitalOutputs.value = value;
            emitDigitalOutputs();

            // Handlers for outputs
            updateTposState(m_digitalOutputs.do4);
            break;
        case RO_DO + 1:
            break;

        // Encoder PUU
        case RO_MONITOR_STATUS0:
            m_encoderPUU.first = value;
            break;
        case RO_MONITOR_STATUS0 + 1:
            m_encoderPUU.second = value;
            emit encoderPUUChanged();
            break;

        // Speed
        case RO_MONITOR_STATUS1:
            m_currentSpeed.value = value;
            emit currentSpeedChanged();
            break;
        case RO_MONITOR_STATUS1 + 1:
            break;

        // Torque
        case RO_MONITOR_STATUS2:
            m_currentTorque.value = value;
            emit currentTorqueChanged();
            break;
        case RO_MONITOR_STATUS2 + 1:
            break;

        // Torque Limit
        case RW_TORQUE_LIMIT_VAL:
            m_torqueLimit.value = value;
            emit torqueLimitChanged();
            break;
        case RW_TORQUE_LIMIT_VAL + 1:
            break;

        // Jog Speed
        case RW_JOG_SPD:
            m_jogSpeed.value = value;
            emit jogSpeedChanged();
            break;
        case RW_JOG_SPD + 1:
            break;

        // Jog Acceleration
        case RW_JOG_ACC:
            m_jogAcc.value = value;
            emit jogAccChanged();
            break;
        case RW_JOG_ACC + 1:
            break;

        // Jog Deceleration
        case RW_JOG_DEC:
            m_jogDec.value = value;
            emit jogDecChanged();
            break;
        case RW_JOG_DEC + 1:
            break;

        // PATH1 Data
        case RW_PATH1_DATA:
            m_pathData1.first = value;
            break;
        case RW_PATH1_DATA + 1:
            m_pathData1.second = value;
            emit pathData1Changed();
            break;

        // Speed0
        case RW_SPD0:
            m_speedData0.value = value;
            emit speedData0Changed();
            break;
        case RW_SPD0 + 1:
            break;

        // Acc/Dec 0
        case RW_ACC_DEC0:
            m_rampData0.value = value;
            emit rampData0Changed();
            break;
        case RW_ACC_DEC0 + 1:
            break;

        // Acc/Dec 1
        case RW_ACC_DEC1:
            m_rampData1.value = value;
            emit rampData1Changed();
            break;
        case RW_ACC_DEC1 + 1:
            break;


        // Alarms
        case RW_ALARMS:
            m_alarms = value;
            emit alarmsChanged();
            break;
        case RW_ALARMS + 1:
            break;

        default:
            break;
    }

}

bool ServoModbusDevice::pushTorqueLimit(qint16 value)
{
    Torque v;
    v.value = value;
    QVector<quint16> values = { v.first, v.second };
    return pushToWriteBuffer(RW_TORQUE_LIMIT_VAL, values);
}

bool ServoModbusDevice::pushJogSpeed(quint16 value)
{
    JogSpeed v;
    v.value = value;
    QVector<quint16> values = { v.first, v.second };
    return pushToWriteBuffer(RW_JOG_SPD, values);
}

bool ServoModbusDevice::pushJogAcc(quint16 value)
{
    Ramp v;
    v.value = value;
    QVector<quint16> values = { v.first, v.second };
    return pushToWriteBuffer(RW_JOG_ACC, values);
}

bool ServoModbusDevice::pushJogDec(quint16 value)
{
    Ramp v;
    v.value = value;
    QVector<quint16> values = { v.first, v.second };
    return pushToWriteBuffer(RW_JOG_DEC, values);
}

bool ServoModbusDevice::pushPathData1(qint32 value)
{
    EncoderPUU v;
    v.value = value;
    QVector<quint16> values = { v.first, v.second };
    return pushToWriteBuffer(RW_PATH1_DATA, values);
}

bool ServoModbusDevice::pushSpeed0(quint16 value)
{
    JogSpeed v;
    v.value = value;
    QVector<quint16> values = { v.first, v.second };
    return pushToWriteBuffer(RW_SPD0, values);
}

bool ServoModbusDevice::pushRamp0(quint16 value)
{
    Ramp v;
    v.value = value;
    QVector<quint16> values = { v.first, v.second };
    return pushToWriteBuffer(RW_ACC_DEC0, values);
}

bool ServoModbusDevice::pushRamp1(quint16 value)
{
    Ramp v;
    v.value = value;
    QVector<quint16> values = { v.first, v.second };
    return pushToWriteBuffer(RW_ACC_DEC1, values);
}

bool ServoModbusDevice::pushDi1(bool value)
{
    DigitalInputs v;
    v.value = m_digitalInputs.value;
    v.di1 = value;
    QVector<quint16> values = { v.value };
    return pushToWriteBuffer(RW_DI, values);
}

bool ServoModbusDevice::pushDi2(bool value)
{
    DigitalInputs v;
    v.value = m_digitalInputs.value;
    v.di2 = value;
    QVector<quint16> values = { v.value };
    return pushToWriteBuffer(RW_DI, values);
}

bool ServoModbusDevice::pushDi3(bool value)
{
    DigitalInputs v;
    v.value = m_digitalInputs.value;
    v.di3 = value;
    QVector<quint16> values = { v.value };
    return pushToWriteBuffer(RW_DI, values);
}

bool ServoModbusDevice::pushDi4(bool value)
{
    DigitalInputs v;
    v.value = m_digitalInputs.value;
    v.di4 = value;
    QVector<quint16> values = { v.value };
    return pushToWriteBuffer(RW_DI, values);
}

bool ServoModbusDevice::pushDi9(bool value)
{
    DigitalInputs v;
    v.value = m_digitalInputs.value;
    v.di9 = value;
    QVector<quint16> values = { v.value };
    return pushToWriteBuffer(RW_DI, values);
}

bool ServoModbusDevice::pushDi10(bool value)
{
    DigitalInputs v;
    v.value = m_digitalInputs.value;
    v.di10 = value;
    QVector<quint16> values = { v.value };
    return pushToWriteBuffer(RW_DI, values);
}

void ServoModbusDevice::applyPos0()
{
    pushDi2(true);
    pushDi3(false);
}

void ServoModbusDevice::triggerCTRG()
{
    // pushDi4(false);
    // pushDi4(true);
    // pushDi4(false);

    // qDebug() << "Disabling CTRG: " << ctrgActive();
    pushDi4(true);
    QTimer::singleShot(m_posActiveDelay, this, [ = ]()
    {
        //     qDebug() << "Enabling CTRG: " << ctrgActive();
        pushDi4(true);
    });
}

bool ServoModbusDevice::resetAlarms()
{
    QVector<quint16> values = {0x00};
    return pushToWriteBuffer(RW_ALARMS, values);
}

bool ServoModbusDevice::gotoHome()
{
    if (availableToHome())
    {
        pushDi2(false);
        pushDi1(true);
        QTimer::singleShot(m_posActiveDelay, this, [ = ]()
        {
            pushDi1(true);
            pushDi2(false);
            triggerCTRG();
        });

        // if (pushDi2(false))
        // {
        //     // Requesting for Trigger...
        //     triggerCTRG();
        //     return true;
        // }
        // qCritical() << "Something went wrong at writing pushing on gotoHome!";
        // return false;
        return true;
    }
    qCritical() << "Cannot apply GotoHome! : " << outputsStateStr();
    return false;

}

bool ServoModbusDevice::gotoPosition(qint32 path)
{
    // return gotoPosition(path, m_speedData0.value, m_rampData0.value);
    return gotoPosition(path, m_jogSpeed.value * 10, m_jogAcc.value);
}

bool ServoModbusDevice::gotoPosition(qint32 path, quint16 speed, quint16 ramp)
{
    // if (availableToRun())
    // {
    pushPathData1(path);
    pushSpeed0(speed);
    pushRamp0(ramp);
    pushDi2(true);
    pushDi1(true);

    QTimer::singleShot(m_posActiveDelay, this, [ = ]()
    {
        pushDi1(true);
        pushDi2(true);
        triggerCTRG();
    });
    // if ()
    // {
    return true;
    // Requesting for Trigger...
    // triggerCTRG();
    // return true;
    // }
    // qCritical() << "Something went wrong at writing pushing on gotoPosition!";
    // return false;
    // }
    // qCritical() << "Cannot apply GotoPosition!: " << outputsStateStr();
    // return false;
}

QString ServoModbusDevice::getAlarmDesc(int code)
{
    switch (code)
    {
        case TAlarms::OverCurrent:
            return TO_STR(OverCurrent);
        case TAlarms::OverVoltage :
            return TO_STR(OverVoltage);
        case TAlarms::UnderVoltage :
            return TO_STR(UnderVoltage);
        case TAlarms::WrongMotor :
            return TO_STR(WrongMotor);
        case TAlarms::RegenerationErr :
            return TO_STR(RegenerationErr);
        case TAlarms::Overload :
            return TO_STR(Overload);
        case TAlarms::OverSpeed :
            return TO_STR(OverSpeed);
        case TAlarms::AbnormalPosCmd :
            return TO_STR(AbnormalPosCmd);
        case TAlarms::ExcessivePositionCmd :
            return TO_STR(ExcessivePositionCmd);
        case TAlarms::EncoderErr :
            return TO_STR(EncoderErr);
        case TAlarms::AdjustmentErr :
            return TO_STR(AdjustmentErr);
        case TAlarms::EmergencyStop :
            return TO_STR(EmergencyStop);
        case TAlarms::ReverseLimitErr :
            return TO_STR(ReverseLimitErr);
        case TAlarms::ForwardLimitErr :
            return TO_STR(ForwardLimitErr);
        case TAlarms::IGBTOverheat :
            return TO_STR(IGBTOverheat);
        case TAlarms::AbnormalPOM :
            return TO_STR(AbnormalPOM);
        case TAlarms::AbnormalSignalOutput :
            return TO_STR(AbnormalSignalOutput);
        case TAlarms::SerialComErr :
            return TO_STR(SerialComErr);
        case TAlarms::SerialComTimeout :
            return TO_STR(SerialComTimeout);
        case TAlarms::MainCircuitPowerLack :
            return TO_STR(MainCircuitPowerLack);
        case TAlarms::EearlyWarningForOverload :
            return TO_STR(EearlyWarningForOverload);
        case TAlarms::EncoderInitalMagneticFieldErr :
            return TO_STR(EncoderInitalMagneticFieldErr);
        case TAlarms::EncoderInternalErr :
            return TO_STR(EncoderInternalErr);
        case TAlarms::UnreliableInternalEncoderData :
            return TO_STR(UnreliableInternalEncoderData);
        case TAlarms::EncoderResetErr :
            return TO_STR(EncoderResetErr);
        case TAlarms::EncoderOverVoltage :
            return TO_STR(EncoderOverVoltage);
        case TAlarms::MotorCrashError :
            return TO_STR(MotorCrashError);
        case TAlarms::IncorrectMotorWriing :
            return TO_STR(IncorrectMotorWriing);
        case TAlarms::InternalComErr :
            return TO_STR(InternalComErr);
        case TAlarms::CN5isBreakdown :
            return TO_STR(CN5isBreakdown);
        case TAlarms::WarningOfServoDriveOverload :
            return TO_STR(WarningOfServoDriveOverload);
        case TAlarms::AbsolutePositionLogs :
            return TO_STR(AbsolutePositionLogs);
    }

    return "Unknown Error please referer ASDA-A2 documentation";
}

void ServoModbusDevice::emitDigitalInputs()
{
    emit di1Changed();
    emit di2Changed();
    emit di3Changed();
    emit di4Changed();
    emit di5Changed();
    emit di6Changed();
    emit di7Changed();
    emit di8Changed();
    emit di9Changed();
    emit di10Changed();
    emit di11Changed();
    emit di12Changed();
    emit di13Changed();
    emit di14Changed();
}

void ServoModbusDevice::emitDigitalOutputs()
{
    emit do1Changed();
    emit do2Changed();
    emit do3Changed();
    emit do4Changed();
    emit do5Changed();

    // Other
    emit homingCompleteChanged();
    emit availableToHome();
    emit availableToRun();
}

void ServoModbusDevice::updateTposState(bool currentState)
{
    if (!m_prevTposState && currentState)
    {
        // Rising Edge detection
        emit tposStateChanged(true);
    }
    else if (m_prevTposState && !currentState)
    {
        // Falling Edge detection
        emit tposStateChanged(false);
    }

    m_prevTposState = currentState;
}

QString ServoModbusDevice::outputsStateStr() const
{
    return QString("SRDY: %1, ZSPD: %2, HOME: %3, TPOS: %4, ALRM: %5")
           .arg(m_digitalOutputs.do1)
           .arg(m_digitalOutputs.do2)
           .arg(m_digitalOutputs.do3)
           .arg(m_digitalOutputs.do4)
           .arg(m_digitalOutputs.do5);
}
