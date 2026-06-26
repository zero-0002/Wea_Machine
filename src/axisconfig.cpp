#include "../include/InjectionMolding/axisconfig.h"

AxisConfig::AxisConfig(QObject* parent)
    : QObject{parent},
      m_numerator(1),
      m_denominator(1),
      m_zeroPUU(0),
      m_maxDecimals(0)
{

}

double AxisConfig::toUnit(qint32 puu) const
{
    return static_cast<double>(puu - m_zeroPUU) * m_denominator / m_numerator;
}

qint32 AxisConfig::toPUU(double unit) const
{
    double doublePUU = unit * m_numerator / m_denominator + m_zeroPUU;
    return static_cast<qint32>(qBound(static_cast<qint64>(INT32_MIN),
                                      qRound64(doublePUU),
                                      static_cast<qint64>(INT32_MAX)));
}

void AxisConfig::setZeroPUU(qint32 zeroPUU)
{
    m_zeroPUU = zeroPUU;

    emit gearRatioChanged();
}

void AxisConfig::setScale(qint64 numerator, qint64 denominator)
{
    m_numerator = qMax(numerator, 1LL);
    m_denominator = qMax(denominator, 1LL);

    applyMaxDecimals();

    emit gearRatioChanged();
}

void AxisConfig::syncronize(AxisConfig* other)
{
    m_numerator = other->m_numerator;
    m_denominator = other->m_denominator;
    m_zeroPUU = other->m_zeroPUU;
    m_maxDecimals = other->m_maxDecimals;
    m_decimals = other->m_decimals;
    m_unitName = other->m_unitName;

    emit unitNameChanged();
    emit decimalsChanged();
    emit gearRatioChanged();
}

void AxisConfig::applyMaxDecimals()
{
    double resolution = static_cast<double>(m_denominator) / static_cast<double>(m_numerator);

    int d = 0;

    while (resolution < 1.0)
    {
        resolution *= 10.0;
        ++d;
    }
    m_maxDecimals = d;
}
