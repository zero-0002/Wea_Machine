#ifndef QITEMSORTFILTERPROXYMODEL_H
#define QITEMSORTFILTERPROXYMODEL_H

#include <QSortFilterProxyModel>
#include <QRegularExpression>

#include "models/IQItemListModel.h"


class QItemSortFilterProxyModel : public QSortFilterProxyModel {
    Q_OBJECT
    Q_PROPERTY(QString filterString READ filterString WRITE setFilterString NOTIFY filterStringChanged)
public:
    explicit QItemSortFilterProxyModel(QObject *parent = nullptr) : QSortFilterProxyModel(parent) {}

    QString filterString() const { return m_filterString; }

    Q_INVOKABLE void setFilterString(const QString &value) {
        if (m_filterString == value)
            return;
        m_filterString = value;
        filterRegex(m_filterString);
        emit filterStringChanged();
    }

    void setSourceRoleNames(QHash<int, QByteArray> roleNames) {
        QVariantList headers = dynamic_cast<IQItemListModel *>(sourceModel())->headersData();
        for (auto it = roleNames.constBegin(); it != roleNames.constEnd(); ++it) {
            QString roleNameStr = QString::fromUtf8(it.value());
            m_sourceRoleNames[roleNameStr.toLower()] = it.key();
            for (auto &header : headers) {
                auto mp_header = header.value<QVariantMap>();
                if (roleNameStr != mp_header["name"])
                    continue;
                m_sourceRoleNames[mp_header["title"].value<QString>().toLower()] = it.key();
                break;
            }
        }
        m_sourceIsAssigned = true;
    }

    /// @return int: m_sourceRoleNames key. if was not valid it returns -1.
    bool isValidRole(QString columnName) {
        if (!m_sourceIsAssigned)
            setSourceRoleNames(sourceModel()->roleNames());
        if (columnName.isEmpty())
            return true;
        return  m_sourceRoleNames.keys().contains(columnName);
    }

    /// @details: 1 < 130 isValid; 1203 isValid; 123 ~ 12367 isValid; & ...
    /// @details Operations are = "<=>~"
    void filterRegex(QString &textInput) {
        QStringList textPatterns = textInput.toLower().split(',');
        QString pattern = R"((?:(\w+):\s*)?(-?\d+(?:\.\d+)?)[\t| ]*(>=|<=|=|<|>|~)[\t| ]*(-?\d+(?:\.\d+)?|(?=.*))|(-?\d+(?:\.\d+)?))";
        QRegularExpression re(pattern);
        m_roleFilters.clear();
        for (auto &text : textPatterns) {
            QRegularExpressionMatch match = re.match(text);
            if (!match.hasMatch())
                continue;
            QString roleName = match.captured(1);
            double numMinRange = match.captured(2).toDouble();
            QString op = match.captured(3);
            double numMaxRange = match.captured(4).toDouble();
            double numBaseFilter = match.captured(5).toDouble();

            if (!isValidRole(roleName))
                continue;
            if (roleName.isEmpty())
                roleName = "id";
            m_roleFilters[m_sourceRoleNames[roleName]] = {roleName, numMinRange, op, numMaxRange, numBaseFilter};

        }
    }

    // Interface IQItemListModel class Functions
    Q_INVOKABLE QVariant headerData(int section, Qt::Orientation orientation = Qt::Horizontal, int role = Qt::DisplayRole) {
        return dynamic_cast<IQItemListModel *>(sourceModel())->headerData(section, orientation, role);
    }
    Q_INVOKABLE QVariantList headersData() {
        return dynamic_cast<IQItemListModel *>(sourceModel())->headersData();
    }
    Q_INVOKABLE int insertItem(QObject* itemObj, quint32 itemId) {
        return dynamic_cast<IQItemListModel *>(sourceModel())->insertItem(itemObj, itemId);
    }

    Q_INVOKABLE bool removeItem(quint32 itemId) {
        return dynamic_cast<IQItemListModel *>(sourceModel())->removeItem(itemId);
    }

    Q_INVOKABLE bool editItem(int key, QObject* itemObj) {
        return dynamic_cast<IQItemListModel *>(sourceModel())->editItem(key, itemObj);
    }

    Q_INVOKABLE QVariantList getRowData(int row) const {
        return dynamic_cast<IQItemListModel *>(sourceModel())->getRowData(row);
    }

    Q_INVOKABLE void selectItem(int index) {
        dynamic_cast<IQItemListModel *>(sourceModel())->selectItem(index);
    }


signals:
    void filterStringChanged();

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override {
        if (m_roleFilters.isEmpty())
            return true;
    TODO: // Assign String equalation
        QModelIndex index0 = sourceModel()->index(sourceRow, 0, sourceParent);
        for (auto it = m_roleFilters.constBegin(); it != m_roleFilters.constEnd(); ++it) {
            QString data = sourceModel()->data(index0, it.key()).toString();
            bool okDouble = false;
            double dataDouble = data.toDouble(&okDouble);
            Filters filters = it.value();

            // Custom Filtering queries
            if (filters.operatorSign == "<") {
                if (okDouble && dataDouble < filters.minRange) {
                    continue;
                }
                return false;
            }
            else if (okDouble && filters.operatorSign == ">") {
                if (dataDouble > filters.minRange) {
                    continue;
                }
                return false;
            }
            else if (filters.operatorSign == "=") {
                if (dataDouble == filters.minRange) {
                    continue;

                }
                return false;
            }
            else if (okDouble && filters.operatorSign == ">=") {
                if (dataDouble >= filters.minRange) {
                    continue;

                }
                return false;
            }
            else if (okDouble && filters.operatorSign == "<=") {
                if (dataDouble <= filters.minRange) {
                    continue;

                }
                return false;
            }
            else if (okDouble && filters.operatorSign == "~") {
                if (filters.minRange <= dataDouble && dataDouble < filters.maxRange) {
                    continue;
                }
                return false;
            }
            else if (filters.operatorSign.isEmpty()) {
                if (data.contains(m_filterString)) {
                    continue;
                }
                return false;
            }
            else {
                //  qCritical() << "Error: " << "Non of the statements are valid on filterRegex" << filters.operatorSign;
            }
        }
        return true;
    }

private:
    struct Filters {
        QString roleName;
        double minRange;
        QString operatorSign;
        double maxRange;
        double numBaseFilter;
    };

private:
    QString m_filterString;
    QHash<QString, int> m_sourceRoleNames; // columnName -> roleId(enum)
    QHash<int, Filters> m_roleFilters; // roleId -> filters
    bool m_sourceIsAssigned = false;

};

#endif // QITEMSORTFILTERPROXYMODEL_H
