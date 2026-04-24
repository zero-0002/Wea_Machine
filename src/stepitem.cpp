#include "../include/InjectionMolding/stepitem.h"

StepItem::StepItem(QObject* parent)
    : QObject{parent}
{}

StepItem::StepItem(const StepItem& other)
{
    if (this == &other)
    {
        return;
    }
    doCopy(other);
}

StepItem& StepItem::operator=(const StepItem& other)
{
    if (this == &other)
    {
        return *this;
    }
    doCopy(other);

    return *this;
}

void StepItem::doCopy(const StepItem& other)
{
    this->m_plcOutputTargets = other.m_plcOutputTargets;
    this->m_conditionBits = other.m_conditionBits;

    this->m_name = other.m_name;
    this->m_stepId = other.m_stepId;

    this->m_xServoPos = other.m_xServoPos;
    this->m_xServoSpeed = other.m_xServoSpeed;
    this->m_xServoAcc = other.m_xServoAcc;
    this->m_xServoDec = other.m_xServoDec;

    this->m_yServoPos = other.m_yServoPos;
    this->m_xServoSpeed = other.m_yServoSpeed;
    this->m_yServoAcc = other.m_yServoAcc;
    this->m_yServoDec = other.m_yServoDec;

    this->m_delay = other.m_delay;
    this->m_bitwiseMethod = other.m_bitwiseMethod;
    this->m_bitwiseEnable = other.m_bitwiseEnable;

    this->m_xPosActive = other.m_xPosActive;
    this->m_xServoOn = other.m_xServoOn;
    this->m_xServoHome = other.m_xServoHome;

    this->m_yPosActive = other.m_yPosActive;
    this->m_yServoOn = other.m_yServoOn;
    this->m_yServoHome = other.m_yServoHome;
}
