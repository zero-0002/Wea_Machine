#ifndef SERVOUNIONS_H
#define SERVOUNIONS_H

#include <QObject>

union Torque
{
    struct
    {
        quint16 first;
        quint16 second;
    };
    qint16 value;
};

/** Readonly Variables **/
union EncoderPUU
{
    struct
    {
        quint16 first;
        quint16 second;
    };
    qint32 value;
};

union Speed
{
    struct
    {
        quint16 first;
        quint16 second;
    };
    qint16 value;
};

union JogSpeed
{
    struct
    {
        quint16 first;
        quint16 second;
    };
    quint16 value;
};

// Acc/Dec
union Ramp
{
    struct
    {
        quint16 first;
        quint16 second;
    };
    quint16 value;
};

union DigitalInputs
{
    struct
    {
        bool di1 : 1;
        bool di2 : 1;
        bool di3 : 1;
        bool di4 : 1;
        bool di5 : 1;
        bool di6 : 1;
        bool di7 : 1;
        bool di8 : 1;
        bool di9 : 1;
        bool di10 : 1;
        bool di11 : 1;
        bool di12 : 1;
        bool di13 : 1;
        bool di14 : 1;
    };
    quint16 value;
};

union DigitalOutputs
{
    struct
    {
        bool do1 : 1;
        bool do2 : 1;
        bool do3 : 1;
        bool do4 : 1;
        bool do5 : 1;
    };
    quint16 value;
};

#endif // SERVOUNIONS_H
