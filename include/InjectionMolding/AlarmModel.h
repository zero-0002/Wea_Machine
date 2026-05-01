#ifndef ALARMMODEL_H
#define ALARMMODEL_H

#include <QAbstractListModel>
#include <QDebug>
#include "AlarmItem.h"

/*!
 * \brief The AlarmModel class Singleton
 */
class AlarmModel : public QAbstractListModel
{
        Q_OBJECT
        Q_PROPERTY(int count READ count NOTIFY countChanged)
    public:
        enum AlarmRoles
        {
            NoRole = Qt::UserRole + 1,
            CodeRole,
            DescRole
        };
        Q_ENUM(AlarmRoles)


        explicit AlarmModel(QObject* parent = nullptr)
            : QAbstractListModel(parent)
        {
            // addAlarm(AlarmItem(0, "Emergency", "PLC"));
            // addAlarm(AlarmItem(1, "Under Voltage", "S1"));
            // addAlarm(AlarmItem(11, "Negative Limit", "S2"));
            // addAlarm(AlarmItem(7, "Positive Limit", "S1"));
        }

        static AlarmModel& getInstance()
        {
            static AlarmModel instance;
            return instance;
        }

        int rowCount(const QModelIndex& parent = QModelIndex()) const override
        {
            Q_UNUSED(parent)
            return m_alarms.count();
        }

        QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override
        {
            int idx = index.row();
            if (!index.isValid() || idx < 0 || idx >= rowCount())
            {
                qWarning() << "Invalid index position: " << idx;
                return QVariant();
            }

            switch (role)
            {
                case NoRole:
                    return idx + 1; // NOTE: Check this out
                case CodeRole:
                    return m_alarms.at(idx).codeStr();
                case DescRole:
                    return m_alarms.at(idx).description();
            };

            return QVariant();
        }

        QHash<int, QByteArray> roleNames() const override
        {
            return
            {
                {NoRole, "no"},
                {CodeRole, "code"},
                {DescRole, "desc"}
            };
        }

        Q_INVOKABLE bool addAlarm(int code, const QString& desc, const QString& codePrefix = "")
        {
            return addAlarm(AlarmItem(code, desc, codePrefix));
        }

        Q_INVOKABLE bool addAlarm(const AlarmItem& alarmItem)
        {

            const auto code = alarmItem.code();
            if (code < 0)
            {
                qWarning() << "Invalid Alarm Code: " << code;
                return false;
            }

            if (exists(code))
            {
                // qWarning() << "Alarm Code is already exist: " << code;
                return false;
            }

            int insertLoc = count();
            beginInsertRows(QModelIndex(), insertLoc, insertLoc);

            m_alarms.append(alarmItem);
            emit countChanged();

            endInsertRows();

            return true;
        }

        Q_INVOKABLE bool removeAlarm(int code)
        {
            if (code < 0)
            {
                qWarning() << "Invalid Alarm Code: " << code;
                return false;
            }

            int idx = getIndex(code);
            if (idx < 0)
            {
                qWarning() << "Alarm Code doesn't exists: " << code;
                return false;
            }

            beginRemoveRows(QModelIndex(), idx, idx);

            m_alarms.removeAt(idx);
            emit countChanged();

            endRemoveRows();

            return true;
        }

        Q_INVOKABLE void removeByCodePrefix(const QString& prefix)
        {
            for (int i(0); i < count(); ++i)
            {
                if (m_alarms[i].codePrefix() == prefix)
                {
                    removeAlarm(m_alarms[i].code());
                }
            }
        }

        Q_INVOKABLE int getIndex(int code) const
        {
            for (int i(0); i < count(); ++i)
            {
                if (m_alarms[i].code() == code)
                {
                    return i;
                }
            }
            return -1;
        }

        Q_INVOKABLE bool exists(int code) const
        {
            for (auto& alarmItem : qAsConst(m_alarms))
            {
                if (alarmItem.code() == code)
                {
                    return true;
                }
            }

            return false;
        }

        Q_INVOKABLE void updateAll()
        {
            if (!isEmpty())
            {
                emit dataChanged(index(0), index(count() - 1));
            }
        }

        Q_INVOKABLE void clear()
        {
            beginResetModel();

            m_alarms.clear();
            emit countChanged();

            endResetModel();
        }

        Q_INVOKABLE bool isEmpty() const
        {
            return empty();
        }

        Q_INVOKABLE bool empty() const
        {
            return m_alarms.empty();
        }

        Q_INVOKABLE int count() const
        {
            return m_alarms.count();
        }
    signals:
        void countChanged();

    private:
        QList<AlarmItem> m_alarms;
};


#endif // ALARMMODEL_H
