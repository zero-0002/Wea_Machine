#include "../include/InjectionMolding/stepmodel.h"

#include "../include/InjectionMolding/stepitem.h"
#include "../include/InjectionMolding/plciomodel.h"
#include "../include/InjectionMolding/servomodbusdevice.h"


StepModel::StepModel(QObject* parent)
    : QAbstractListModel{parent}
{

    connect(this, &StepModel::enabledChanged, this, [ = ]()
    {
        if (!m_enabled)
        {
            onEmergencyStop();
        }
    });

    connect(this, &StepModel::stepFinished, this, &StepModel::onStepFinished);

    connect(&m_stepsTimer, &QTimer::timeout, this, &StepModel::onStepTrigger);
}

int StepModel::rowCount(const QModelIndex& parent) const
{
    Q_UNUSED(parent)
    return m_items.count();
}

QVariant StepModel::data(const QModelIndex& index, int role) const
{

}

bool StepModel::setData(const QModelIndex& index, const QVariant& value, int role)
{

}

QHash<int, QByteArray> StepModel::roleNames() const
{
    return
    {
        { IdRole, "id"},
        { NameRole, "name"},

        { BitwiseEnableRole, "bitwiseenable"},
        { BitwiseMethodRole, "bitwisemethod"},

        { XPosActive, "xposactive"},
        { XServoONRole, "xservoon"},
        { XServoHomeRole, "xservohome"},
        { XServoPosRole, "xservopos"},
        { XServoSpdRole, "xservospd"},
        { XServoTorqueRole, "xservotorque"},
        { XServoAccRole, "xservoacc"},  // Deactive yet,
        { XServoDecRole, "xservodec"}, // Deactive yet,

        { YPosActive, "yposactive"},
        { YServoONRole, "yservoon"},
        { YServoHomeRole, "yservohome"},
        { YServoPosRole, "yservopos"},
        { YServoSpdRole, "yservospd"},
        { YServoTorqueRole, "yservotorque"},
        { YServoAccRole, "yservoacc"},  // Deactive yet,
        { YServoDecRole, "yservodec"}, // Deactive yet,

        { PlcOutputTargetsRole, "plcoutputtargets"},  // Indices,
        { ConditionBitsRole, "conditionbits"},

        { DelayRole, "delay" }
    };
}

bool StepModel::addItem(int id)
{

}

bool StepModel::addItem(StepItem* item)
{

}

void StepModel::updateAll()
{
    if (!isEmpty())
    {
        emit dataChanged(index(0), index(count() - 1));
    }
}

void StepModel::clear()
{
    beginResetModel();

    qDeleteAll(m_items);
    m_items.clear();
    emit countChanged();

    endResetModel();
}

bool StepModel::isEmpty() const
{
    return empty();
}

bool StepModel::empty() const
{
    return m_items.empty();
}

int StepModel::count() const
{
    return m_items.count();
}

StepItem* StepModel::getItem(int index) const
{

}

const QList<StepItem*>& StepModel::steps() const
{
    return m_items;
}

void StepModel::setSteps(const QList<StepItem*>& value)
{
    m_items = value;

    emit stepsChanged();
}

// const QList<StepItem>& StepModel::steps() const
// {
//     return m_steps;
// }

// void StepModel::setSteps(const QList<StepItem>& value)
// {
//     m_steps = value;

//     emit stepsChanged();
// }

PlcIOModel* StepModel::plcModel() const
{
    return m_plcModel;
}

void StepModel::setPlcModel(PlcIOModel* value)
{
    m_plcModel = value;

    makePlcModelConnection();

    emit plcModelChanged();
}

ServoModbusDevice* StepModel::xServoDevice() const
{
    return m_xServoDevice;
}

void StepModel::setXServoDevice(ServoModbusDevice* value)
{
    m_xServoDevice = value;

    makeXServoConnection();

    emit xServoDeviceChanged();
}

ServoModbusDevice* StepModel::yServoDevice() const
{
    return m_yServoDevice;
}

void StepModel::setYServoDevice(ServoModbusDevice* value)
{
    m_yServoDevice = value;

    makeYServoConnection();

    emit yServoDeviceChanged();
}

void StepModel::onEmergencyStop()
{
    restoreMemories();
}

void StepModel::onStepStarted()
{
    if (!m_enabled)
    {
        qWarning() << "StepModel is Disabled cannot run steps!";
        return;
    }

    if (m_running || m_currentRunning > 0)
    {
        qWarning() << "Steps is Already on Process!" << m_running << m_currentRunning;
        return;
    }

    readyMemories();
}

void StepModel::onStepFinished()
{
    restoreMemories();
}

void StepModel::onXServoPosStarted()
{
    m_xServoGotoPosOnDemand = true;
}

void StepModel::onXServoPosCompleted()
{
    m_xServoGotoPosOnDemand = false;
}

void StepModel::onYServoPosStarted()
{
    m_yServoGotoPosOnDemand = true;
}

void StepModel::onYServoPosCompleted()
{
    m_yServoGotoPosOnDemand = false;
}

void StepModel::onStepTrigger()
{
    if (!m_running || m_currentRunning < 0 || m_currentRunning >= m_items.count())
    {
        qWarning() << "Unavailable to starting step!" << m_running << m_currentRunning;
        qInfo() << "Stopping steps...";
        emit stepFinished();
        return;
    }

    if (m_waitForNextStep)
    {
        qDebug() << "Waiting for nextStep";
        return;
    }

    auto& currentStep = m_items[m_currentRunning];

    if (m_processOnDemand)
    {
        // wait For step finished
        if (currentStepCompleted(currentStep))
        {
            // Delay
            m_waitForNextStep = true;
            QTimer::singleShot(currentStep->delay() + 50, this, &StepModel::nextStep);
        }
        return;
    }

    qDebug() << "Running Step: " << m_currentRunning << currentStep->name();
    applyServosStep(currentStep);
    applyPlcStep(currentStep);

    m_processOnDemand = true;
}

void StepModel::applyServosStep(StepItem* step)
{
    if (m_processOnDemand)
    {
        return;
    }

    // X Axis
    if (step->xPosActive())
    {
        if (step->xServoOn())
        {
            if (!m_xServoDevice->di1())
            {
                m_xServoDevice->pushDi1(true);
                m_xServoDevice->pushDi1(true);
            }

            if (step->xServoHome())
            {
                m_xServoDevice->gotoHome();
                m_xServoHomeOnDemand = true;
            }
            else
            {
                m_xServoDevice->gotoPosition(step->xServoPos());
                qDebug() << "Servo X gotoPosition: " << step->name();
                m_xServoGotoPosOnDemand = true;
            }
        }
        else
        {
            if (m_xServoDevice->di1())
            {
                m_xServoDevice->pushDi1(false);
                m_xServoDevice->pushDi1(false);
            }
        }
    }


    // Y Axis
    if (step->yPosActive())
    {
        if (step->yServoOn())
        {

            if (!m_yServoDevice->di1())
            {
                m_yServoDevice->pushDi1(true);
                m_yServoDevice->pushDi1(true);
            }

            if (step->yServoHome())
            {
                m_yServoDevice->gotoHome();
                m_yServoHomeOnDemand = true;
            }
            else
            {
                m_yServoDevice->gotoPosition(step->yServoPos());
                qDebug() << "Servo Y gotoPosition: " << step->name();
                m_yServoGotoPosOnDemand = true;
            }
        }
        else
        {
            if (m_yServoDevice->di1())
            {
                m_yServoDevice->pushDi1(false);
                m_yServoDevice->pushDi1(false);
            }
        }
    }
}

// void StepModel::applyServoHoming(ServoModbusDevice* servo)
// {

// }

// void StepModel::applyServoGotoPosition(ServoModbusDevice* servo, StepItem* step)
// {

// }

void StepModel::applyPlcStep(StepItem* step)
{
    if (m_processOnDemand)
    {
        return;
    }

    for (int i(0); i < m_plcModel->outputsCount(); ++i)
    {
        bool active = step->plcOutputTargets().contains(i);

        auto& output = m_plcModel->outputs().at(i);
        qDebug() << "Setting Plc Coil" << i << output->displayName() << active;

        m_plcModel->setCoilActive(i, active);
    }
}

bool StepModel::servosStepCompleted(StepItem* step)
{
    // X Axis
    if (step->xPosActive())
    {
        if (step->xServoOn())
        {
            if (!m_xServoDevice->di1())
            {
                return false;
            }

            if (step->xServoHome())
            {
                if (!m_xServoDevice->homingComplete())
                {
                    return false;
                }
            }
            else
            {
                if (!m_xServoDevice->tposFeedback() || m_xServoGotoPosOnDemand)
                {
                    return false;
                }
            }
        }
        else
        {
            if (m_xServoDevice->di1())
            {
                return false;
            }
        }
    }

    // Y Axis
    if (step->yPosActive())
    {
        if (step->yServoOn())
        {
            if (!m_yServoDevice->di1())
            {
                return false;
            }

            if (step->yServoHome())
            {
                if (!m_yServoDevice->homingComplete())
                {
                    return false;
                }
            }
            else
            {
                if (!m_yServoDevice->tposFeedback() || m_yServoGotoPosOnDemand)
                {
                    return false;
                }
            }
        }
        else
        {
            if (m_yServoDevice->di1())
            {
                return false;
            }
        }
    }
    return true;
}

bool StepModel::plcStepCompleted(StepItem* step)
{
    Q_UNUSED(step)
    return true;
}

void StepModel::readyMemories()
{
    m_running = true;
    m_currentRunning = 0;

    m_stepsTimer.setInterval(m_interval);
    m_stepsTimer.start();

    emit stepStarted();
}

void StepModel::restoreMemories()
{
    m_running = false;
    m_processOnDemand = false;
    m_waitForNextStep = false;
    m_currentRunning = -1;

    m_stepsTimer.stop();

    emit runningChanged();
    emit currentRunningChanged();

    qDebug() << "restoringMemories..." << m_running << m_processOnDemand << m_waitForNextStep << m_currentRunning;
}

bool StepModel::currentStepCompleted(StepItem* step)
{

    return servosStepCompleted(step) && plcStepCompleted(step);
}

void StepModel::nextStep()
{
    m_currentRunning += 1;
    m_waitForNextStep = false;
    m_processOnDemand = false;

    if (m_currentRunning >= m_items.count())
    {
        qDebug() << "All Steps has Completed!";
        emit stepFinished();
        return;
    }

    emit currentRunningChanged();
}

void StepModel::makePlcModelConnection()
{
    connect(m_plcModel, &PlcIOModel::emergencyStop, this, &StepModel::onEmergencyStop);
    connect(m_plcModel, &PlcIOModel::stepStarted, this, &StepModel::onStepStarted);
}

void StepModel::makeXServoConnection()
{
    connect(m_xServoDevice, &ServoModbusDevice::positionStarted, this, &StepModel::onXServoPosStarted);
    connect(m_xServoDevice, &ServoModbusDevice::positionCompleted, this, &StepModel::onXServoPosCompleted);
}

void StepModel::makeYServoConnection()
{
    connect(m_yServoDevice, &ServoModbusDevice::positionStarted, this, &StepModel::onYServoPosStarted);
    connect(m_yServoDevice, &ServoModbusDevice::positionCompleted, this, &StepModel::onYServoPosCompleted);
}
