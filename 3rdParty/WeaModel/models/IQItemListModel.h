#ifndef IQITEMLISTMODDELBASE_H
#define IQITEMLISTMODDELBASE_H

#include <QObject>
#include <QAbstractListModel>
#include <QtGlobal>
#include <QString>
#include <QMap>
#include <QHash>
#include <QVector>
#include <QDebug>
#include <QVariant>


class IQItemListModel : public QAbstractListModel {
    Q_OBJECT
public:
    explicit IQItemListModel(QObject *parent = nullptr) : QAbstractListModel(parent) {}

    virtual Q_INVOKABLE int insertItem(QObject* itemObj, quint32 itemId) = 0;

    virtual Q_INVOKABLE bool removeItem(quint32 itemId) = 0;

    virtual Q_INVOKABLE bool editItem(int key, QObject* itemObj) = 0;

    virtual Q_INVOKABLE bool editItemById(int itemId, QObject* itemObj) = 0;

    virtual Q_INVOKABLE QVariantList getRowData(int row) const = 0;

    virtual Q_INVOKABLE void selectItem(int index) = 0;

    virtual Q_INVOKABLE QVariantList headersData() const = 0;
};

#endif // IQITEMLISTMODDELBASE_H
