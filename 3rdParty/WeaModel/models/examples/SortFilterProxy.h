#ifndef SORTFILTERPROXY_H
#define SORTFILTERPROXY_H

#include "models/QItemSortFilterProxyModel.h"

class SortFilterProxyModel : public QItemSortFilterProxyModel {
    Q_OBJECT
public:
    explicit SortFilterProxyModel(QObject *parent = nullptr) : QItemSortFilterProxyModel(parent) {}
};

#endif // SORTFILTERPROXY_H
