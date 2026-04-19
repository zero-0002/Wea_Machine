#include "../include/InjectionMolding/plciomodel.h"

#include <QGuiApplication>
#include <QSettings>

PlcIOModel::PlcIOModel(QObject* parent)
    : QAbstractListModel(parent)
{
    /** Creating PlcIOItems referer AppSettings IO count **/
    QSettings settings(QSettings::IniFormat,
                       QSettings::UserScope,
                       QGuiApplication::organizationName(),
                       QGuiApplication::applicationName());

    int numInputs = settings.value("INPUTS_COUNT", 16).toInt();
    int numOutputs = settings.value("OUTPUTS_COUNT", 12).toInt();

    // Inputs Creation
    for (int i(0); i < numInputs; ++i)
    {
        int num = (i % 8) + i / 8 * 10;
        const QString name = QString("X%1").arg(num);
        addItem(new PlcIOItem(i, PlcIOItem::InputType, name, this));
    }

    // Inputs Creation
    for (int i(0); i < numOutputs; ++i)
    {
        int num = (i % 8) + i / 8 * 10;
        const QString name = QString("Y%1").arg(num);
        addItem(new PlcIOItem(i, PlcIOItem::OutputType, name, this));
    }

    /** Initializing Interrupts Syncronization **/
    for (auto& item : m_items)
    {
        syncStopInterrupts(item);
        syncSignalFwdInterrupts(item);
    }
}

int PlcIOModel::rowCount(const QModelIndex& parent) const
{
    Q_UNUSED(parent)
    return m_items.count();
}

QVariant PlcIOModel::data(const QModelIndex& index, int role) const
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
        case IONumberRole:
            return idx;
        case NameRole:
            return item->name();
        case DisplayNameRole:
            return item->displayName();
        case OnDelayIntervalRole:
            return item->onDelayInterval();
        case OffDelayIntervalRole:
            return item->offDelayInterval();
        case BlinkIntervalRole:
            return item->blinkInterval();
        case IOTypeRole:
            return item->type();
        case ContactTypeRole:
            return item->contactType();
        case CoilActiveRole:
            return item->coilActive();
        case ActiveFeedbackRole:
            return item->activeFeedback();
        case ActiveRole:
            return item->active();
        case StopInterruptTargetsRole:
            return item->stopInterruptTargets();
        case SignalForwardInterruptTargetsRole:
            return item->signalForwardInterruptTargets();

    };

    qWarning() << "Invalid Role argument!: " << role;

    return QVariant();
}

bool PlcIOModel::setData(const QModelIndex& index, const QVariant& value, int role)
{
    int idx = index.row();
    if (!index.isValid() || idx < 0 || idx >= rowCount())
    {
        qWarning() << "Invalid index position: " << idx;
        return false;
    }

    auto* item = m_items[idx];
    switch (role)
    {
        case DisplayNameRole:
            item->setDisplayName(value.toString());
            break;
        case OnDelayIntervalRole:
            item->setOnDelayInterval(value.toInt());
            break;
        case OffDelayIntervalRole:
            item->setOffDelayInterval(value.toInt());
            break;
        case BlinkIntervalRole:
            item->setBlinkInterval(value.toInt());
            break;
        case IOTypeRole:
            item->setType(value.toInt());
            break;
        case ContactTypeRole:
            item->setContactType(value.toInt());
            break;
        case CoilActiveRole:
            item->setCoilActive(value.toBool());
            break;
        case ActiveFeedbackRole:
            item->setActiveFeedback(value.toBool());
            break;
        case StopInterruptTargetsRole:
            item->setStopInterruptTargets(value.toList());
            break;
        case SignalForwardInterruptTargetsRole:
            item->setSignalForwardInterruptTargets(value.toList());
            break;
        /** Read-Only **/
        case ActiveRole:
        case IONumberRole:
        case NameRole:
        default:
            qWarning() << "Invalid role for setData!" << role;
            return false;

    };

    // FIXME: Check this correction
    emit dataChanged(index, index);
    return true;
}

QHash<int, QByteArray> PlcIOModel::roleNames() const
{
    return
    {
        { IONumberRole, "ioNumber" },
        { NameRole, "name" },
        { DisplayNameRole, "displayName" },
        { OnDelayIntervalRole, "onDelayInterval" },
        { OffDelayIntervalRole, "offDelayInterval" },
        { BlinkIntervalRole, "blinkInterval" },
        { IOTypeRole, "ioType" },
        { ContactTypeRole, "contactType" },
        { CoilActiveRole, "coilActive" },
        { ActiveFeedbackRole, "activeFeedback" },
        { ActiveRole, "active" },
        { OutputEnabledRole, "outputEnabled" },
        { StopInterruptTargetsRole, "stopInterruptTargets" },
        { SignalForwardInterruptTargetsRole, "signalForwardInterruptTargets" },
    };
}

const QList<PlcIOItem*>& PlcIOModel::inputs() const
{
    return m_inputs;
}

const QList<PlcIOItem*>& PlcIOModel::outputs() const
{
    return m_outputs;
}

bool PlcIOModel::addItem(int ioIndex, int ioType, const QString& name)
{
    return addItem(new PlcIOItem(ioIndex, ioType, name, this));
}

bool PlcIOModel::addItem(PlcIOItem* item)
{

    if (!item || item == nullptr)
    {
        qCritical() << "NULL PlcIOItem";
        return false;
    }

    int ioType = item->type();
    if (ioType < 0)
    {
        qCritical() << "Invalid IOType for: " << item->name()
                    << " IOType: " << ioType;
        return false;
    }

    int insertLoc = count();

    beginInsertRows(QModelIndex(), insertLoc, insertLoc);

    /** Connections **/
    connect(item, &PlcIOItem::stopInterruptTargetsChanged, this, [ = ]()
    {
        syncStopInterrupts(item);
        qDebug() << "StopInterruptTargetsChanged: " << item->displayName() << item->stopInterruptTargets();
    });
    connect(item, &PlcIOItem::signalForwardInterruptTargetsChanged, this, [ = ]()
    {
        syncSignalFwdInterrupts(item);
        qDebug() << "SignalForwardInterruptTargetsChanged: " << item->displayName() << item->signalForwardInterruptTargets();
    });

    //Test
    connect(item, &PlcIOItem::stepStart, this, [ = ]()
    {
        qDebug() << "Step Start Signal: " << item->name();
    });
    connect(item, &PlcIOItem::emergencyStop, this, [ = ]()
    {
        qDebug() << "Emergency STOP Signal: " << item->name();
    });


    m_items.append(item);
    if (item->type() == PlcIOItem::InputType)
    {
        m_inputs.append(item);
        emit inputsChanged();
    }
    else if (item->type() == PlcIOItem::OutputType)
    {
        int outputIdx = outputsCount();
        // Connection between coilChanged & Communication coil handler
        connect(item, &PlcIOItem::activeChanged, this, [ = ]()
        {
            emit outputCoilChanged(outputIdx, item->active());
        });

        m_outputs.append(item);
        emit outputsChanged();
    }

    emit countChanged();

    endInsertRows();

    return true;

}

void PlcIOModel::updateAll()
{
    if (!isEmpty())
    {
        emit dataChanged(index(0), index(count() - 1));
    }
}

void PlcIOModel::clear()
{
    beginResetModel();

    m_items.clear();
    emit countChanged();

    endResetModel();
}

bool PlcIOModel::isEmpty() const
{
    return empty();
}

bool PlcIOModel::empty() const
{
    return m_items.empty();
}

int PlcIOModel::count() const
{
    return m_items.count();
}

int PlcIOModel::inputsCount() const
{
    return m_inputs.count();
}

int PlcIOModel::outputsCount() const
{
    return m_outputs.count();
}

bool PlcIOModel::setCoilActive(int index, bool active)
{
    return setOutputData(index, active, CoilActiveRole);
}

bool PlcIOModel::setInputCoil(int index, bool value)
{
    bool res = true;
    res &= setInputData(index, value, ActiveFeedbackRole);
    res &= setInputData(index, value, CoilActiveRole);
    return res;
}

bool PlcIOModel::setOutputCoil(int index, bool value)
{
    /**
     *  CoilActive must be trigger by user, NOT communication
     *  ActiveFeedback is enough
     **/
    return setOutputData(index, value, ActiveFeedbackRole);
    // setData(modelIndex, value, CoilActiveRole);
}

bool PlcIOModel::setInputData(int index, const QVariant& value, IORoles role)
{
    if (index < 0 || index >= inputsCount())
    {
        qWarning() << "Invalid Input index!" << index;
        return false;
    }

    auto modelIndex = this->index(index);
    return setData(modelIndex, value, role);
}

bool PlcIOModel::setOutputData(int index, const QVariant& value, IORoles role)
{
    if (index < 0 || index >= outputsCount())
    {
        qWarning() << "Invalid Input index!" << index;
        return false;
    }
    int realIndex = index + inputsCount(); // Because setData will locate from m_items not m_outputs

    auto modelIndex = this->index(realIndex);
    return setData(modelIndex, value, role);
}

void PlcIOModel::syncStopInterrupts(PlcIOItem* target)
{
    if (!target || target == nullptr)
    {
        qCritical() << "NULL PlcIOItem";
        return;
    }

    // Target Index required for ignoring itself if has included in any interrupts
    bool isInput = target->type() == PlcIOItem::InputType;
    int targetIdx = isInput ? -1 : m_outputs.indexOf(target);
    if (!isInput && targetIdx < 0)
    {
        qWarning() << "Target output is not contains in outputs!" << targetIdx;
        return;
    }

    QList<PlcIOItem*> interruptItems;
    for (auto& interruptIndex : target->stopInterruptTargets())
    {
        int intrIdx = interruptIndex.toInt();
        if (intrIdx == targetIdx)
        {
            // Self ignore
            continue;
        }

        interruptItems.append(m_outputs[intrIdx]);
    }

    target->addInterruptItem(PlcIOItem::StopInterrupt, qMove(interruptItems));
}

void PlcIOModel::syncSignalFwdInterrupts(PlcIOItem* target)
{
    if (!target || target == nullptr)
    {
        qCritical() << "NULL PlcIOItem";
        return;
    }

    // Target Index required for ignoring itself if has included in any interrupts
    bool isInput = target->type() == PlcIOItem::InputType;
    int targetIdx = isInput ? -1 : m_outputs.indexOf(target);
    if (!isInput && targetIdx < 0)
    {
        qWarning() << "Target output is not contains in outputs!" << targetIdx;
        return;
    }

    QList<PlcIOItem*> interruptItems;
    for (auto& interruptIndex : target->signalForwardInterruptTargets())
    {
        int intrIdx = interruptIndex.toInt();
        if (intrIdx == targetIdx)
        {
            // Self ignore
            continue;
        }

        interruptItems.append(m_outputs[intrIdx]);
    }

    target->addInterruptItem(PlcIOItem::SignalForwardInterrupt, interruptItems);

}
