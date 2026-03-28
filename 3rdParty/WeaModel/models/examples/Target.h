#ifndef TARGET_H
#define TARGET_H

#include <QObject>
#include <QDebug>
#include <QVariant>
#include <math.h>
#include "models/QItemBase.h"

class Target : public QItemBase {
    Q_OBJECT

public:
    explicit Target(double az = 1.0, double elv = 1.0, double rc = 1.0 , double p = 1.0, QObject* parent = nullptr) :
        m_azimuth(az), m_elevation(elv), m_rangeCell(rc), m_power(p), QItemBase{parent}
    {
    }

    enum class TargetRoles : int {

//        ItemSelectedRole,
        AzimuthRole = Qt::UserRole + 1,
        IdRole,
        RowRole,
        ElevationRole,
        RangeCellRole,
        PowerRole,
        NameRole,
//        TargetObjectRole,
//        AllRole
    };
    Q_ENUM(TargetRoles)

    static QHash<int, QByteArray> getRoles() {
        return {
            {static_cast<int>(TargetRoles::AzimuthRole), "azimuth"},
            {static_cast<int>(TargetRoles::ElevationRole), "elevation"},
            {static_cast<int>(TargetRoles::RangeCellRole), "rangeCell"},
            {static_cast<int>(TargetRoles::NameRole), "name"},
            {static_cast<int>(TargetRoles::PowerRole), "power"},
//            {static_cast<int>(TargetRoles::ItemSelectedRole), "itemSelected"},
            {static_cast<int>(TargetRoles::RowRole), "row"},
            {static_cast<int>(TargetRoles::IdRole), "id"},

//            {ElevationRole, "elevation"},
//            {RangeCellRole, "rangeCell"},
//            {NameRole, "name"},
//            {PowerRole, "power"},
//            { ItemSelectedRole, "itemSelected" },
//            { RowRole, "row" },
//            { IdRole, "id" },
//            {TargetObjectRole, "targetObject",},
//            {AllRole, "all"}
        };
    }

    QVariant getValueByRole(int role) override {
        switch (role) {
        case static_cast<int>(TargetRoles::AzimuthRole): return azimuth();
        case static_cast<int>(TargetRoles::ElevationRole): return elevation();
        case static_cast<int>(TargetRoles::RangeCellRole): return rangeCell();
        case static_cast<int>(TargetRoles::NameRole): return name();
        case static_cast<int>(TargetRoles::PowerRole): return power();
//        case static_cast<int>(TargetRoles::ItemSelectedRole): return itemSelected();
        case static_cast<int>(TargetRoles::RowRole): return row();
        case static_cast<int>(TargetRoles::IdRole): return id();

//        case TargetObjectRole: return QVariant::fromValue(this);

        default: return {};
        }

    }

    QString getTitleByRole(int role) const override {
        switch (role) {
        case static_cast<int>(TargetRoles::AzimuthRole): return QString("Az");
        case static_cast<int>(TargetRoles::ElevationRole): return QString("Elv");
        case static_cast<int>(TargetRoles::RangeCellRole): return QString("Range Cell");
        case static_cast<int>(TargetRoles::NameRole): return QString("Target Name");
        case static_cast<int>(TargetRoles::PowerRole): return QString("Power");
//        case static_cast<int>(TargetRoles::ItemSelectedRole): return QString("Selected");
        case static_cast<int>(TargetRoles::RowRole): return QString("Row");
        case static_cast<int>(TargetRoles::IdRole): return QString("ID");
        default: return QString();
        }
    }

    QVariantMap getHeaderDataByRole(int role) const override {
        switch (role) {
        case static_cast<int>(TargetRoles::AzimuthRole): return QVariantMap({{"title", "Az"}, {"columnWidth", 100}, {"visible", true}, {"kill", false}}); // If False or not contains that will not kill else that gonna be removed from model.
        case static_cast<int>(TargetRoles::ElevationRole): return QVariantMap({{"title", "Elv"}, {"columnWidth", 100}, {"visible", true}});
        case static_cast<int>(TargetRoles::RangeCellRole): return QVariantMap({{"title", "RangeCell"}, {"columnWidth", 100}, {"visible", true}});
        case static_cast<int>(TargetRoles::NameRole): return QVariantMap({{"title", "Target Names"}, {"columnWidth", 100}, {"visible", true}});
        case static_cast<int>(TargetRoles::PowerRole): return QVariantMap({{"title", "Power"}, {"columnWidth", 100}, {"visible", true}});
//        case static_cast<int>(TargetRoles::ItemSelectedRole): return QVariantMap({{"title", "Select"}, {"columnWidth", 100}, {"visible", true}});
        case static_cast<int>(TargetRoles::RowRole): return QVariantMap({{"title", "Row"}, {"columnWidth", 100}, {"visible", true}});
        case static_cast<int>(TargetRoles::IdRole): return QVariantMap({{"title", "ID"}, {"columnWidth", 100}, {"visible", true}});
        default: return QVariantMap();
        }

    }


    double azimuth() const { return m_azimuth; }
    void setAzimuth(double az) {
        if (m_azimuth == az)
            return;
        m_azimuth = az;
        setUpdated(true);
    }

    double elevation() const{ return m_elevation; }
    void setElevation(double elv){
        if (m_elevation == elv)
            return;
        m_elevation = elv;
        setUpdated(true);
    }

    double rangeCell() const{ return m_rangeCell; }
    void setRangeCell(double range_cell){
        if (m_rangeCell == range_cell)
            return;
        m_rangeCell =  std::isnan(range_cell) ? 100.0: range_cell;
        setUpdated(true);
    }

    double power() const { return m_power; }
    void setPower(double power){
        if (m_power == power)
            return;
        m_power = power;
        setUpdated(true);
    }

    QString name() const { return m_name; }
    void setName(const QString &name) { m_name = name; setUpdated(true);}


private:
    double m_azimuth = 0.0;
    double m_elevation = 0.0;
    double m_rangeCell = 0.0;
    double m_power = 0.0;
    QString m_name;

};

#endif // TARGET_H
