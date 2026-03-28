#ifndef TARGETMODEL_H
#define TARGETMODEL_H

//#include <QAbstractTableModel>
#include "models/QItemListModel.h"
#include "models/examples/Target.h"

class TargetModel: public QItemListModel<Target> {
    Q_OBJECT
public:
};

#endif // TARGETMODEL_H
