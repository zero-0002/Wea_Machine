#ifndef RECORDMODEL_H
#define RECORDMODEL_H

#include <QAbstractListModel>
#include <QVector>

/*!
 * \brief Persistent position samples captured during manual/auto runs.
 */
class RecordModel : public QAbstractListModel
{
        Q_OBJECT
        Q_PROPERTY(int count READ count NOTIFY countChanged)
    public:
        enum RecordRoles
        {
            NoRole = Qt::UserRole + 1,
            XPosRole,
            YPosRole
        };
        Q_ENUM(RecordRoles)

        explicit RecordModel(QObject* parent = nullptr)
            : QAbstractListModel(parent)
        {
        }

        static RecordModel& getInstance()
        {
            static RecordModel instance;
            return instance;
        }

        int rowCount(const QModelIndex& parent = QModelIndex()) const override
        {
            Q_UNUSED(parent)
            return m_records.count();
        }

        QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override
        {
            const int idx = index.row();
            if (!index.isValid() || idx < 0 || idx >= rowCount())
                return QVariant();

            const Record& record = m_records.at(idx);
            switch (role)
            {
                case NoRole:
                    return idx + 1;
                case XPosRole:
                    return QString::number(record.xPos, 'f', 3);
                case YPosRole:
                    return QString::number(record.yPos, 'f', 3);
                default:
                    return QVariant();
            }
        }

        QHash<int, QByteArray> roleNames() const override
        {
            return {
                {NoRole, "no"},
                {XPosRole, "xpos"},
                {YPosRole, "ypos"},
            };
        }

        Q_INVOKABLE bool addRecord(double xPos, double yPos)
        {
            const int insertLoc = count();
            beginInsertRows(QModelIndex(), insertLoc, insertLoc);
            m_records.append(Record{xPos, yPos});
            endInsertRows();
            emit countChanged();
            return true;
        }

        //! ListModel-compatible remove used by CusTableView.
        Q_INVOKABLE void remove(int index)
        {
            if (index < 0 || index >= count())
                return;

            beginRemoveRows(QModelIndex(), index, index);
            m_records.removeAt(index);
            endRemoveRows();
            emit countChanged();

            if (!isEmpty())
                emit dataChanged(this->index(0), this->index(count() - 1), QVector<int>{NoRole});
        }

        Q_INVOKABLE void clear()
        {
            beginResetModel();
            m_records.clear();
            endResetModel();
            emit countChanged();
        }

        Q_INVOKABLE bool isEmpty() const { return m_records.isEmpty(); }
        Q_INVOKABLE int count() const { return m_records.count(); }

    signals:
        void countChanged();

    private:
        struct Record
        {
            double xPos = 0.0;
            double yPos = 0.0;
        };

        QList<Record> m_records;
};

#endif // RECORDMODEL_H
