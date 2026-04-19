#include "../include/InjectionMolding/plcioitem.h"
#include "../include/InjectionMolding/AlarmModel.h"

#include <QGuiApplication>
#include <QSettings>
#include <QDebug>

PlcIOItem::PlcIOItem(int ioIndex, int ioType, const QString& name, QObject* parent)
    : QObject(parent),
      m_ioIndex(ioIndex),
      m_type(ioType),
      m_name(name),
      m_displayName(name) // default & initial value

{

    /** Connections **/
    makeConnections();

    /** Restoring from AppSetting **/
    readFromSettings();
}

bool PlcIOItem::containsAtStopTargets(int index)
{
    return m_stopInterruptTargets.contains(index);
}

bool PlcIOItem::containsAtSignalFwdTargets(int index)
{
    return m_signalForwardInterruptTargets.contains(index);
}

bool PlcIOItem::isOutputEnabled() const
{
    return m_outputEnabled || m_type == IOType::InputType;
}

bool PlcIOItem::isCoilActive() const
{
    return m_contactType == ContactType::NormallyOpen ? m_coilActive : !m_coilActive;
}

bool PlcIOItem::invalidToActive() const
{
    return m_type == IOType::InputType ? m_active == isCoilActive() : m_activeFeedback == isCoilActive();
}

bool PlcIOItem::addInterruptItem(int interruptType, const QList<PlcIOItem*>& items)
{
    switch (interruptType)
    {
        // Valid interrupts
        case InterruptType::StopInterrupt:
        case InterruptType::SignalForwardInterrupt:
            break;
        default:
            qCritical() << "Invalid InterruptType!: " << interruptType;
            return false;
    }

    m_interruptItems[interruptType] = items;
    return true;
}

PlcIOItem::PlcIOItem(const PlcIOItem& other)
{
    if (this == &other)
    {
        return;
    }
    doCopy(other);
}

PlcIOItem& PlcIOItem::operator=(const PlcIOItem& other)
{

    if (this == &other)
    {
        return *this;
    }
    doCopy(other);

    return *this;
}

void PlcIOItem::doCopy(const PlcIOItem& other)
{
    this->m_onDelayInterval = other.m_onDelayInterval;
    this->m_offDelayInterval = other.m_offDelayInterval;
    this->m_blinkInterval = other.m_blinkInterval;
    this->m_type = other.m_type;
    this->m_contactType = other.m_contactType;
    this->m_coilActive = other.m_coilActive;
    this->m_active = other.m_active;
}

void PlcIOItem::applyInterrupts()
{
    // If Interrupt has Start Step ignore all
    if (m_hasStepStartInterrupt && m_active)
    {
        emit stepStart();
        return;
    }

    QMapIterator<int, QList<PlcIOItem*>> i(m_interruptItems);
    while (i.hasNext())
    {
        i.next();
        if (i.value().isEmpty())
        {
            continue;
        }

        switch (i.key())
        {
            case InterruptType::StopInterrupt:
                applyStopInterrupt();

                break;
            case InterruptType::SignalForwardInterrupt:
                applySignalForwardInterrupt();

                break;
            case InterruptType::StepStartInterrupt:

                break;

            // No need to do something
            case InterruptType::NoInterrupt:
            default:
                break;
        }
    }
}

void PlcIOItem::applyStopInterrupt()
{
    if (!m_outputEnabled)
    {
        // Ignore if current isn't enable
        return;
    }

    for (auto& plcIoItem : m_interruptItems[InterruptType::StopInterrupt])
    {
        qDebug() << plcIoItem->name() << plcIoItem->active() << plcIoItem->outputEnabled() << plcIoItem->coilActive() << plcIoItem->activeFeedback();

        if (m_stopMethod == ForceRst && m_active)
        {
            // Disable every coil
            plcIoItem->setCoilActive(false);
        }
        plcIoItem->setOutputEnabled(!m_active);
    }
    if (m_active)
    {
        emit emergencyStop();
    }
}

void PlcIOItem::applySignalForwardInterrupt()
{
    for (auto& plcIoItem : m_interruptItems[InterruptType::SignalForwardInterrupt])
    {
        switch (m_signalForwardMethod)
        {
            case SignalForwardMethod::SetReset:
                plcIoItem->setCoilActive(m_active);
                break;

            case SignalForwardMethod::SetOnly:
                if (m_active)
                {
                    plcIoItem->setCoilActive(true);
                }
                break;

            case SignalForwardMethod::ResetOnly:
                if (m_active)
                {
                    plcIoItem->setCoilActive(false);
                }
                break;

            case SignalForwardMethod::Togglable:
                if (m_active)
                {
                    m_toggled = !m_toggled;
                }

                plcIoItem->setCoilActive(m_toggled);
                break;

            default:
                qWarning() << "Invalid SignalForwardMethod property value!" << m_signalForwardMethod;
                break;
        };
    }
}

void PlcIOItem::triggerOnDelay()
{
    if (!m_lastDelayTmr)
    {
        // Off Delay is on Process
        return;
    }

    activate();

    // Activating Blinking if enable
    if (m_blinkInterval <= 0 || m_type != IOType::OutputType || m_blinkTimer.isActive())
    {
        // blinking is disbaled
        return;
    }
    m_blinkTimer.setInterval(m_blinkInterval);
    m_blinkTimer.start();
}

void PlcIOItem::triggerOffDelay()
{
    if (m_lastDelayTmr)
    {
        // On Delay is on Process
        return;
    }

    // Deactivating Blinking Timer
    if (m_blinkTimer.isActive())
    {
        m_blinkTimer.stop();
    }

    deactivate();
}

bool PlcIOItem::setActive(bool value, bool force)
{
    if (invalidToActive() && !force)
    {
        return false;
    }

    if (!isOutputEnabled() && value)
    {
        return false;
    }

    // if (m_active == value)
    // {
    //     return false;
    // }

    m_active = value;
    emit activeChanged();

    applyInterrupts();

    /** Checking Feedback **/
    // QTimer::singleShot(m_feedbackTimeout + qMax(m_onDelayInterval, m_offDelayInterval), this, &PlcIOItem::checkActiveResponse);

    return true;
}

void PlcIOItem::activate()
{
    if (setActive(true))
    {
        emit activated();
    }
}

void PlcIOItem::deactivate()
{
    if (setActive(false))
    {
        emit deactivated();
    }
}

void PlcIOItem::checkActiveResponse()
{
    // if (m_active != m_activeFeedback)
    // {
    // auto name = m_name;
    // emit errorOccured(50 + name.replace("Y", "").replace("X", "").toInt(), QString("Unable to read response from %1  active: %2 activeFeedback: %3")
    //                   .arg(m_name)
    //                   .arg(m_active)
    //                   .arg(m_activeFeedback)
    //                  );
    // m_coilActive = m_activeFeedback;
    // m_active = m_activeFeedback;
    // }
}

void PlcIOItem::makeConnections()
{
    // Active property
    connect(this, &PlcIOItem::coilActiveChanged, this, [ = ]()
    {

        // Depends on ContactType active may be different
        bool isActive = isCoilActive();

        // Avoid multiple times activation
        if (invalidToActive())
        {
            return;
        }

        if (isActive)
        {
            // OnDelay Timer
            m_lastDelayTmr = true;
            QTimer::singleShot(m_onDelayInterval, this, &PlcIOItem::triggerOnDelay);
        }

        else
        {
            // OffDelay Timer
            m_lastDelayTmr = false;
            QTimer::singleShot(m_offDelayInterval, this, &PlcIOItem::triggerOffDelay);
        }
    });

    // Blinking Timer
    connect(this, &PlcIOItem::blinkIntervalChanged, this, [ = ]()
    {
        if (m_blinkInterval <= 0 || m_type == IOType::InputType)
        {
            m_blinkTimer.stop();
            return;
        }
    });

    connect(&m_blinkTimer, &QTimer::timeout, this,  [ = ]()
    {
        if (m_type == IOType::InputType)
        {
            m_blinkTimer.stop();
            return;
        }

        if (!isCoilActive())
        {
            return;
        }

        // Making active output
        setActive(!m_active, true);
    });


    // Interrupt & Safety
    connect(this, &PlcIOItem::outputEnabledChanged, this, [ = ]()
    {
        if (m_outputEnabled)
        {
            // Has no effect when it's enabled
            emit coilActiveChanged();
            return;
        }

        if (setActive(false, true))
        {
            emit deactivated();
        }
        else
        {
            qWarning() << "Cannot Deactive by interrupt!" << m_name;
        }
    });

    // Alarms
    connect(this, &PlcIOItem::errorOccured, this, [ = ](int code, const QString & msg)
    {
        AlarmModel::getInstance().addAlarm(AlarmItem(400 + code, msg, "PLCCOM"));
    });

    /** Requesting coilActive handler **/
    connect(this, &PlcIOItem::contactTypeChanged, this, [ = ]()
    {
        // ContactType changed coilActiveChanged should be emit
        emit coilActiveChanged();
    });

    connect(this, &PlcIOItem::stopMethodChanged, this, [ = ]()
    {
        emit coilActiveChanged();
    });

    connect(this, &PlcIOItem::signalForwardMethodChanged, this, [ = ]()
    {
        emit coilActiveChanged();
    });
}

QString PlcIOItem::getSettingName(int property) const
{
    return m_name + "_" + PlcIOItem::PropertyNameSettings[property];
}

void PlcIOItem::readFromSettings()
{
    QSettings settings(QSettings::IniFormat,
                       QSettings::UserScope,
                       QGuiApplication::organizationName(),
                       QGuiApplication::applicationName());

    setDisplayName(settings.value(getSettingName(DISPLAY_NAME), m_displayName).toString());

    setOnDelayInterval(settings.value(getSettingName(ON_DELAY_INTERVAL), m_onDelayInterval).toInt());
    setOffDelayInterval(settings.value(getSettingName(OFF_DELAY_INTERVAL), m_offDelayInterval).toInt());
    setBlinkInterval(settings.value(getSettingName(BLINK_INTERVAL), m_blinkInterval).toInt());

    setContactType(settings.value(getSettingName(CONTACT_TYPE), m_contactType).toInt());
    setStopMethod(settings.value(getSettingName(STOP_METHOD), m_stopMethod).toInt());
    setSignalForwardMethod(settings.value(getSettingName(SIGNAL_FORWARD_METHOD), m_signalForwardMethod).toInt());

    setHasStepStartInterrupt(settings.value(getSettingName(STEP_START_INTERRUPT), m_hasStepStartInterrupt).toBool());
    setStopInterruptTargets(settings.value(getSettingName(STOP_INTERRUPT_TARGETS), m_stopInterruptTargets).toList());
    setSignalForwardInterruptTargets(settings.value(getSettingName(SIGNAL_FORWARD_INTERRUPT_TARGETS), m_signalForwardInterruptTargets).toList());

}

void PlcIOItem::writeToSettings() const
{
    QSettings settings(QSettings::IniFormat,
                       QSettings::UserScope,
                       QGuiApplication::organizationName(),
                       QGuiApplication::applicationName());

    settings.setValue(getSettingName(DISPLAY_NAME), m_displayName);

    settings.setValue(getSettingName(ON_DELAY_INTERVAL), m_onDelayInterval);
    settings.setValue(getSettingName(OFF_DELAY_INTERVAL), m_offDelayInterval);
    settings.setValue(getSettingName(BLINK_INTERVAL), m_blinkInterval);

    settings.setValue(getSettingName(CONTACT_TYPE), m_contactType);
    settings.setValue(getSettingName(STOP_METHOD), m_stopMethod);
    settings.setValue(getSettingName(SIGNAL_FORWARD_METHOD), m_signalForwardMethod);

    settings.setValue(getSettingName(STEP_START_INTERRUPT), m_hasStepStartInterrupt);
    settings.setValue(getSettingName(STOP_INTERRUPT_TARGETS), m_stopInterruptTargets);
    settings.setValue(getSettingName(SIGNAL_FORWARD_INTERRUPT_TARGETS), m_signalForwardInterruptTargets);
}
