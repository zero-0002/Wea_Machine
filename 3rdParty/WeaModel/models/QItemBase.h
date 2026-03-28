#ifndef QITEMBASE_H
#define QITEMBASE_H

#include <QObject>
#include <QDebug>
#include <QVariantList>
#include <qmetaobject.h>

enum class BaseItemRoles: int {
    IdRole = 1,
    RowRole,
    ItemSelectedRole
};

class QItemBase : public QObject {
    Q_OBJECT

public:

    explicit QItemBase(QObject *parent = nullptr) { setEmpty(true); };

    virtual QString getTitleByRole(int role) const {}
    virtual QVariant getValueByRole(int role) = 0;
    virtual QVariantMap getHeaderDataByRole(int role) const = 0;

    QVariant getBaseItemValueByRole(int role) const {
        //        qDebug() << "GET VALUE BY ROLE" << role << int(BaseItemRoles::IdRole) << int(BaseItemRoles::ItemSelectedRole);
        switch (role) {
        case static_cast<int>(BaseItemRoles::IdRole): return id();
        case static_cast<int>(BaseItemRoles::RowRole): return row();
        case static_cast<int>(BaseItemRoles::ItemSelectedRole): return itemSelected();
        default: return {};
        }

    }

    QVariantMap getBaseItemHeaderDataByRole(int role) const {
        //        qDebug() << "GET HEADER BY ROLE" << role << int(BaseItemRoles::IdRole) << int(BaseItemRoles::ItemSelectedRole);
        switch (role) {
        case static_cast<int>(BaseItemRoles::IdRole): return QVariantMap({{"title", "ID"}, {"columnWidth", 100}, {"visible", true}, {"kill", true}});
        case static_cast<int>(BaseItemRoles::RowRole): return QVariantMap({{"title", "ROW"}, {"columnWidth", 100}, {"visible", true}, {"kill", true}});
        case static_cast<int>(BaseItemRoles::ItemSelectedRole): return QVariantMap({{"title", "SELECTED"}, {"columnWidth", 100}, {"visible", true}, {"kill", true}});
        default: return QVariantMap();
        }

    }


    int id() const { return m_id; }
    void setId(int id) {
        if (m_id == id)
            return;
        m_id = id;
        setUpdated(true);
    }

    int row() const { return m_row; }
    void setRow(int row){
        if (m_row == row)
            return;
        m_row = row;
        setUpdated(true);
    }

    bool itemSelected() const { return m_itemSelected; }
    void setItemSelected(bool selected) {
        if (m_itemSelected == selected)
            return;
        m_itemSelected = selected;
        setUpdated(true);
    }

    bool isEmpty() const { return m_empty; }

    bool hasUpdated() const { return m_hasUpdated; }

    void setUpdated(const bool updated) { m_hasUpdated = updated; }

protected:
    void setEmpty(bool empty) { m_empty = empty; }

private:
    int m_row = 0;
    int m_id = -1; // -1 means Item has no Id!
    bool m_itemSelected = false;
    bool m_hasUpdated = false;

    bool m_empty = false;
    QVariantList m_roles;
};

#endif // QITEMBASE_H
