#include "../include/InjectionMolding/axisconfig.h"

#include <QSettings>
#include <QGuiApplication>

#define GET_SETTING_NAME(x) objectName() + "_" + QString(#x)

AxisConfig::AxisConfig(QObject* parent)
    : QObject{parent}
{
}

void AxisConfig::classBegin()
{

}

void AxisConfig::componentComplete()
{
    readFromSettings();
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

    writeToSettings();

    updateAll();
}

void AxisConfig::updateAll()
{
    emit unitNameChanged();
    emit decimalsChanged();
    emit gearRatioChanged();
}

void AxisConfig::readFromSettings()
{
    QSettings settings(QSettings::IniFormat,
                       QSettings::UserScope,
                       QGuiApplication::organizationName(),
                       QGuiApplication::applicationName());

    m_numerator = settings.value(GET_SETTING_NAME(NUMERATOR), 1LL).toLongLong();
    m_denominator = settings.value(GET_SETTING_NAME(DENOMINATOR), 1LL).toLongLong();
    m_zeroPUU = settings.value(GET_SETTING_NAME(ZERO_OFFSET), 0).toInt();
    m_maxDecimals = settings.value(GET_SETTING_NAME(MAX_DECIMALS), 0).toInt();
    m_decimals = settings.value(GET_SETTING_NAME(DECIMALS), 0).toInt();
    m_unitName = settings.value(GET_SETTING_NAME(UNIT_NAME), "PUU").toString();

    updateAll();
}

void AxisConfig::writeToSettings() const
{
    QSettings settings(QSettings::IniFormat,
                       QSettings::UserScope,
                       QGuiApplication::organizationName(),
                       QGuiApplication::applicationName());

    settings.setValue(GET_SETTING_NAME(NUMERATOR), m_numerator);
    settings.setValue(GET_SETTING_NAME(DENOMINATOR), m_denominator);
    settings.setValue(GET_SETTING_NAME(ZERO_OFFSET), m_zeroPUU);
    settings.setValue(GET_SETTING_NAME(MAX_DECIMALS), m_maxDecimals);
    settings.setValue(GET_SETTING_NAME(DECIMALS), m_decimals);
    settings.setValue(GET_SETTING_NAME(UNIT_NAME), m_unitName);
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
