#ifndef ADDRESSES_H
#define ADDRESSES_H

#include <QObject>

// Utillities
#define TO_STR(x) #x

enum ServoA2Params
{
    RW_ENABLE_DI_SI = 0x30C, // size 2 (bit0=DI1 and bit13=DI14, 1 == software, 0 == hardware)  (default = 3B0F) NOTE: send it when Servo drive power on
    RW_DI = 0x40E, // size 2
    RO_DO = 0x412, // size 2

    RO_MONITOR_STATUS0 = 0x12, // size 2
    RO_MONITOR_STATUS1 = 0x14, // size 2
    RO_MONITOR_STATUS2 = 0x16, // size 2
    RO_MONITOR_STATUS3 = 0x18, // size 2
    RO_MONITOR_STATUS4 = 0x1A, // size 2

    RW_ALARMS = 0x02, // size 2 (send 0x0000 to reset alarm)

    RW_HOME_FIRST_SPD = 0x50A, // size 2 (0~20000 r/min)
    RW_HOME_SECOND_SPD = 0x50C, // size 2 (0~20000 r/min)

    RW_PATH1_DEF = 0x604, // size 2
    RW_PATH1_DATA = 0x606, // size 2 (32 bit signed decimal)
    RW_PATH2_DEF = 0x608, // size 2
    RW_PATH2_DATA = 0x60A, // size 2 ...
    RW_PATH63_DEF = 0x734, // size 2
    RW_PATH63_DATA = 0x736, // size 2 ...

    RW_SPD0 = 0x578, // size 2 (0~60000 r/min) 16 bit decimal unsigned)
    RW_SPD1 = 0x57A, // size 2 (0~60000 r/min) 16 bit decimal unsigned)
    RW_SPD15 = 0x596, // size 2 (0~60000 r/min) 16 bit decimal unsigned)

    RW_ACC_DEC0 = 0x528, // size 2 (0~65500 millisecond) 16 bit decimal unsigned)
    RW_ACC_DEC1 = 0x52A, // size 2 (0~65500 millisecond) 16 bit decimal unsigned)
    RW_ACC_DEC15 = 0x546, // size 2 (0~65500 millisecond) 16 bit decimal unsigned)

    RW_JOG_SPD = 0x40A, // size 2 (0~5000 r/min) 16 bit decimal unsigned
    RW_JOG_ACC = 0x144, // size 2 (1~65500 millisecond)
    RW_JOG_DEC = 0x146, // size 2 (1~65500 millisecond)

    RW_TORQUE_LIMIT_VAL = 0x118 // size 2 (-300~300 %) Torque percent
};

enum ServoA2Alarms
{
    OverCurrent = 0x001,
    OverVoltage = 0x002,
    UnderVoltage = 0x003,
    WrongMotor = 0x004,
    RegenerationErr = 0x005,
    Overload = 0x006,
    OverSpeed = 0x007,
    AbnormalPosCmd = 0x008,
    ExcessivePositionCmd = 0x009,
    // 010：Reserved ,
    EncoderErr = 0x011,
    AdjustmentErr = 0x012,
    EmergencyStop = 0x013,
    ReverseLimitErr = 0x014,
    ForwardLimitErr = 0x015,
    IGBTOverheat = 0x016,
    AbnormalPOM = 0x017,
    AbnormalSignalOutput = 0x018,
    SerialComErr = 0x019,
    SerialComTimeout = 0x020,
    // Reserved = 0x021,
    MainCircuitPowerLack = 0x022,
    EearlyWarningForOverload = 0x023,
    EncoderInitalMagneticFieldErr = 0x024,
    EncoderInternalErr = 0x025,
    UnreliableInternalEncoderData = 0x026,
    EncoderResetErr = 0x27,
    EncoderOverVoltage = 0x028,
    MotorCrashError = 0x030,
    IncorrectMotorWriing = 0x031,
    InternalComErr = 0x034,
    CN5isBreakdown = 0x41,
    WarningOfServoDriveOverload = 0x044,
    AbsolutePositionLogs = 0x060
};

#endif // ADDRESSES_H
