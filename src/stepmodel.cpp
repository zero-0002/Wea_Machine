#include "../include/InjectionMolding/stepmodel.h"

#include "../include/InjectionMolding/stepitem.h"
#include "../include/InjectionMolding/plciomodel.h"
#include "../include/InjectionMolding/servomodbusdevice.h"

#include <QJsonArray>
#include<QJsonDocument>
#include <QFile>


StepModel::StepModel(QObject* parent)
    : QAbstractListModel{parent}
{
    reverseRoleNames();

    /** Connections **/
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
    int idx = index.row();
    if (!index.isValid() || idx < 0 || idx >= rowCount())
    {
        qWarning() << "Invalid index position: " << idx;
        return QVariant();
    }

    auto* item = m_items[idx];
    switch (role)
    {
        case IdRole:
            return idx;
        case NameRole:
            return item->name();
        case BitwiseEnableRole:
            return item->bitwiseEnable();
        case BitwiseMethodRole:
            return item->bitwiseMethod();

        case XPosActiveRole:
            return item->xPosActive();
        case XServoONRole:
            return item->xServoOn();
        case XServoHomeRole:
            return item->xServoHome();
        case XServoPosRole:
            return item->xServoPos();
        case XServoSpdRole:
            return item->xServoSpeed();
        case XServoAccRole:
            return item->xServoAcc();
        case XServoDecRole:
            return item->xServoDec();

        case YPosActiveRole:
            return item->yPosActive();
        case YServoONRole:
            return item->yServoOn();
        case YServoHomeRole:
            return item->yServoHome();
        case YServoPosRole:
            return item->yServoPos();
        case YServoSpdRole:
            return item->yServoSpeed();
        case YServoAccRole:
            return item->yServoAcc();
        case YServoDecRole:
            return item->yServoDec();

        case PlcOutputTargetsRole:
            return item->plcOutputTargets();
        case ConditionBitsRole:
            return item->conditionBits();
        case DelayRole:
            return item->delay();

    };

    qWarning() << "Invalid Role argument!: " << role;

    return QVariant();

}

bool StepModel::setData(const QModelIndex& index, const QVariant& value, int role)
{
    int idx = index.row();
    if (!index.isValid() || idx < 0 || idx >= rowCount())
    {
        qWarning() << "Invalid index position: " << idx;
        return false;
    }

    auto* item = m_items[idx];
    setData(item, value, role);

    // FIXME: Check this correction
    emit dataChanged(index, index);
    return true;

}

void StepModel::setData(StepItem* item, const QVariant& value, int role)
{
    switch (role)
    {
        case IdRole:
            break;
        case NameRole:
            item->setName(value.toString());
            break;
        case BitwiseEnableRole:
            item->setBitwiseEnable(value.toBool());
            break;
        case BitwiseMethodRole:
            item->setBitwiseMethod(value.toInt());
            break;

        case XPosActiveRole:
            item->setXPosActive(value.toBool());
            break;
        case XServoONRole:
            item->setXServoON(value.toBool());
            break;
        case XServoHomeRole:
            item->setXServoHome(value.toBool());
            break;
        case XServoPosRole:
            item->setXServoPos(value.toInt());
            break;
        case XServoSpdRole:
            item->setXServoSpeed(value.toUInt());
            break;
        case XServoAccRole:
            item->setXServoAcc(value.toUInt());
            break;
        case XServoDecRole:
            item->setXServoDec(value.toUInt());
            break;

        case YPosActiveRole:
            item->setYPosActive(value.toBool());
            break;
        case YServoONRole:
            item->setYServoON(value.toBool());
            break;
        case YServoHomeRole:
            item->setYServoHome(value.toBool());
            break;
        case YServoPosRole:
            item->setYServoPos(value.toInt());
            break;
        case YServoSpdRole:
            item->setYServoSpeed(value.toUInt());
            break;
        case YServoAccRole:
            item->setYServoAcc(value.toUInt());
            break;
        case YServoDecRole:
            item->setYServoDec(value.toUInt());
            break;

        case PlcOutputTargetsRole:
            item->setPlcOutputsTargets(value.toList());
            break;
        case ConditionBitsRole:
            item->setConditionBits(value.toList());
            break;
        case DelayRole:
            item->setDelay(value.toInt());
            break;
    }
}

QHash<int, QByteArray> StepModel::roleNames() const
{
    static QHash<int, QByteArray> result =
    {
        { IdRole, "id"},
        { NameRole, "name"},

        { BitwiseEnableRole, "bitwiseenable"},
        { BitwiseMethodRole, "bitwisemethod"},

        { XPosActiveRole, "xposactive"},
        { XServoONRole, "xservoon"},
        { XServoHomeRole, "xservohome"},
        { XServoPosRole, "xservopos"},
        { XServoSpdRole, "xservospd"},
        { XServoAccRole, "xservoacc"},  // Deactive yet,
        { XServoDecRole, "xservodec"}, // Deactive yet,

        { YPosActiveRole, "yposactive"},
        { YServoONRole, "yservoon"},
        { YServoHomeRole, "yservohome"},
        { YServoPosRole, "yservopos"},
        { YServoSpdRole, "yservospd"},
        { YServoAccRole, "yservoacc"},  // Deactive yet,
        { YServoDecRole, "yservodec"}, // Deactive yet,

        { PlcOutputTargetsRole, "plcoutputtargets"},  // Indices,
        { ConditionBitsRole, "conditionbits"},

        { DelayRole, "delay" }
    };

    return result;
}

void StepModel::reverseRoleNames()
{
    const auto& _roleNames = StepModel::roleNames();

    for (auto it = _roleNames.begin(); it != _roleNames.end(); ++it)
    {
        m_roleNameToId[it.value()] = it.key();
    }
}

bool StepModel::isJsValid(const QJSValue& jsValue)
{
    const auto names(m_roleNameToId.keys());
    for (auto& name : qAsConst(names))
    {
        if (!jsValue.hasProperty(name))
        {
            qCritical() << "Invalid StepItem JS value! has no property: " << name;
            return false;
        }
    }
    return true;
}

bool StepModel::addItem(QJSValue jsItem)
{
    if (isJsValid(jsItem))
    {
        StepItem* stepItem = new StepItem(this); // Passing this makes auto deletion by StepModel
        syncJsWithStepItem(jsItem, stepItem);
        return addItem(stepItem);
    }
    return false;
}

bool StepModel::addItem(StepItem* item)
{
    if (!item || item == nullptr)
    {
        qCritical() << "NULL StepItem";
        return false;
    }
    int insertLoc = count();

    beginInsertRows(QModelIndex(), insertLoc, insertLoc);
    m_items.append(item);
    emit countChanged();
    endInsertRows();

    return true;
}

bool StepModel::editItem(int index, QJSValue jsItem)
{
    if (index < 0 || index >= m_items.count())
    {
        qCritical() << "Invalid index value!" << index << m_items.count();
        return false;
    }

    if (isJsValid(jsItem))
    {
        auto* step = m_items[index];
        syncJsWithStepItem(jsItem, step);
        emit dataChanged(this->index(index), this->index(index));
        return true;
    }
    return false;
}

bool StepModel::remove(int index)
{
    return removeItem(index);
}

bool StepModel::removeItem(int index)
{
    if (index < 0 || index >= m_items.count())
    {
        qCritical() << "Invalid index value!" << index << m_items.count();
        return false;
    }
    beginRemoveRows(QModelIndex(), index, index);
    m_items.removeAt(index);
    emit countChanged();
    endRemoveRows();
    return true;
}

bool StepModel::move(int from, int to)
{
    if (from < 0 || from >= m_items.count())
    {
        qCritical() << "Invalid from value at move(): " << from << m_items.count();
        return false;
    }

    if (to < 0 || to >= m_items.count())
    {
        qCritical() << "Invalid to value at move(): " << to << m_items.count();
        return false;
    }

    // emit layoutAboutToBeChanged();

    // Using beginMoveRows makes approve transitions on ListView.
    int destChild = to > from ? to + 1 : to;
    beginMoveRows(QModelIndex(), from, from, QModelIndex(), destChild);
    auto beforeNames = stepNames();
    m_items.move(from, to);
    auto afterNames = stepNames();
    endMoveRows();

    // changePersistentIndex(index(from), index(to));
    // emit layoutChanged();

    return true;
}

bool StepModel::moveUp(int index)
{
    return move(index, index - 1);
}

bool StepModel::moveDown(int index)
{
    return move(index, index + 1);
}

QStringList StepModel::stepNames() const
{
    QStringList result = {};
    for (auto& item : qAsConst(m_items))
    {
        result.append(item->name());
    }
    return result;
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

    // qDeleteAll(m_items);
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
    if (index < 0 || index >= m_items.count())
    {
        qCritical() << "Invalid index value!" << index << m_items.count();
        return nullptr;
    }
    return m_items[index];
}

bool StepModel::saveToJsonFile(const QString& f) const
{
    QString filePath = f;
    filePath = filePath.replace("file:///", "");
    auto items = m_items;
    QJsonArray allItemsArray;
    for (StepItem* item : items)
    {
        if (item)
        {
            allItemsArray.append(item->toJson());
        }
    }

    QJsonDocument doc(allItemsArray);
    QByteArray data = doc.toJson(QJsonDocument::Indented);

    QFile file(filePath);
    if (file.open(QIODevice::WriteOnly))
    {
        file.write(data);
        file.close();
        qDebug() << "Json saved successfully" << filePath;
        return true;
    }
    else
    {
        qDebug() << "StepItem saveFile error: " << file.errorString();
        return false;
    }
}

bool StepModel::loadFromJsonFile(const QString& f)
{
    QString filePath = f;
    filePath = filePath.replace("file:///", "");

    qDebug() << "File Path is: " << filePath;
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly))
    {
        qDebug() << "Error while opening JSON" << file.errorString();
        return false;
    }

    QByteArray data = file.readAll();
    file.close();

    QJsonDocument doc = QJsonDocument::fromJson(data);

    if (doc.isNull() || !doc.isArray())
    {
        qDebug() << "Invalid JSON Array doc!";
        return false;
    }

    QJsonArray itemsArray = doc.array();
    for (const QJsonValue& itemValue : itemsArray)
    {
        if (itemValue.isObject())
        {
            QJsonObject itemObj = itemValue.toObject();
            StepItem* newItem = new StepItem(this);
            newItem->fromJson(itemObj);

            int insertLoc = count();
            beginInsertRows(QModelIndex(), insertLoc, insertLoc);
            m_items.append(newItem);
            emit countChanged();
            endInsertRows();

        }
        else
        {
            qWarning() << "ItemValue isn't a QJsonObject";
        }
    }

    qDebug() << m_items.size() << "StepItem" << filePath << "has loaded";
    return true;
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
    // m_xServoGotoPosOnDemand = true;
}

void StepModel::onXServoPosCompleted()
{
    // m_xServoGotoPosOnDemand = false;
}

void StepModel::onYServoPosStarted()
{
    // m_yServoGotoPosOnDemand = true;
}

void StepModel::onYServoPosCompleted()
{
    // m_yServoGotoPosOnDemand = false;
}

void StepModel::onStepTrigger()
{
    if (m_errorAtStep || !m_running || m_currentRunning < 0 || m_currentRunning >= m_items.count())
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
    if (m_processOnDemand || m_errorAtStep)
    {
        return;
    }

    // X Axis
    if (step->xPosActive())
    {
        if (step->xServoOn())
        {
            if (!m_xServoDevice->servoOn())
            {
                m_errorAtStep = true;
                return;
            }

            if (step->xServoHome() && !m_xServoDevice->isHomeCompleted())
            {
                if (!m_xServoDevice->gotoHome())
                {
                    m_errorAtStep = true;
                    return;
                }
            }
            else
            {
                if (!m_xServoDevice->gotoPosition(step->xServoPos()))
                {
                    m_errorAtStep = true;
                    return;
                }
            }
        }
        else
        {
            if (!m_xServoDevice->servoOff())
            {
                m_errorAtStep = true;
                return;
            }
        }
    }


    // Y Axis
    if (step->yPosActive())
    {
        if (step->yServoOn())
        {
            if (!m_yServoDevice->servoOn())
            {
                m_errorAtStep = true;
                return;
            }

            if (step->yServoHome() && !m_yServoDevice->isHomeCompleted())
            {
                if (!m_yServoDevice->gotoHome())
                {
                    m_errorAtStep = true;
                    return;
                }
            }
            else
            {
                if (!m_yServoDevice->gotoPosition(step->yServoPos()))
                {
                    m_errorAtStep = true;
                    return;
                }
            }
        }
        else
        {
            if (!m_yServoDevice->servoOff())
            {
                m_errorAtStep = true;
                return;
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
    if (m_processOnDemand || m_errorAtStep)
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
                if (!m_xServoDevice->isHomeCompleted())
                {
                    return false;
                }
            }
            else
            {
                if (m_xServoDevice->checkIfHasErrorOnMove()) // || m_xServoGotoPosOnDemand)
                {
                    m_errorAtStep = true;
                    return false;
                }
                else if (!m_xServoDevice->isPositionReached())
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
                if (!m_yServoDevice->isHomeCompleted())
                {
                    return false;
                }
            }
            else
            {
                if (m_yServoDevice->checkIfHasErrorOnMove()) // || m_yServoGotoPosOnDemand)
                {
                    m_errorAtStep = true;
                    return false;
                }
                else if (!m_yServoDevice->isPositionReached())
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

void StepModel::syncJsWithStepItem(const QJSValue& jsValue, StepItem* step)
{
    const auto names(m_roleNameToId.keys());
    for (auto& name : qAsConst(names))
    {
        const auto& value = jsValue.property(static_cast<QString>(name)).toVariant();
        setData(step, value, m_roleNameToId[name]);
    }
}
