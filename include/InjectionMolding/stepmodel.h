#ifndef STEPMODEL_H
#define STEPMODEL_H

#include <QAbstractListModel>
#include <QTimer>
#include <QDebug>

#include <WeaCore/utils.h>
#include "Addresses.h"

class ServoModbusDevice;
class PlcIOModel;
class StepItem;
class  StepModel : public QAbstractListModel
{
        Q_OBJECT
        Q_PROPERTY(int count READ count NOTIFY countChanged)
        Q_PROPERTY(int currentSelected MEMBER m_currentSelected NOTIFY currentSelectedChanged) // Index
        Q_PROPERTY(int currentRunning MEMBER m_currentRunning NOTIFY currentRunningChanged) // Index

        // Q_PROPERTY(QList<StepItem> steps READ steps WRITE setSteps NOTIFY stepsChanged)
        Q_PROPERTY(QList<StepItem*> steps READ steps WRITE setSteps NOTIFY stepsChanged)

        Q_PROPERTY(PlcIOModel* plcModel READ plcModel WRITE setPlcModel NOTIFY plcModelChanged)
        Q_PROPERTY(ServoModbusDevice* xServoDevice READ xServoDevice WRITE setXServoDevice NOTIFY xServoDeviceChanged)
        Q_PROPERTY(ServoModbusDevice* yServoDevice READ yServoDevice WRITE setYServoDevice NOTIFY yServoDeviceChanged)

        W_PROP_HDEF(bool, enabled, Enabled, false)
        W_PROP_HDEF(int, interval, Interval, 100)
        READ_PROP(bool, running) // isRunning
        READ_PROP(bool, ready) // isReady


    public:
        enum StepRoles
        {
            IdRole = Qt::UserRole + 1,
            NameRole,

            BitwiseEnableRole,
            BitwiseMethodRole,

            XPosActive,
            XServoONRole,
            XServoHomeRole,
            XServoPosRole,
            XServoSpdRole,
            XServoTorqueRole,
            XServoAccRole, // Deactive yet
            XServoDecRole, // Deactive yet

            YPosActive,
            YServoONRole,
            YServoHomeRole,
            YServoPosRole,
            YServoSpdRole,
            YServoTorqueRole,
            YServoAccRole, // Deactive yet
            YServoDecRole, // Deactive yet

            PlcOutputTargetsRole, // Indices
            ConditionBitsRole,

            DelayRole
        };
        Q_ENUM(StepRoles)


        explicit StepModel(QObject* parent = nullptr);

        int rowCount(const QModelIndex& parent = QModelIndex()) const override;
        QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
        bool setData(const QModelIndex& index, const QVariant& value, int role) override;
        QHash<int, QByteArray> roleNames() const override;

        /** Model Helper **/
        Q_INVOKABLE bool addItem(int id);
        Q_INVOKABLE bool addItem(StepItem* item);

        Q_INVOKABLE void updateAll();

        Q_INVOKABLE void clear();

        Q_INVOKABLE bool isEmpty() const;

        Q_INVOKABLE bool empty() const;

        Q_INVOKABLE int count() const;

        /** StepModel Specification **/
        Q_INVOKABLE StepItem* getItem(int index) const;

        /** Properties **/
        // const QList<StepItem>& steps() const;
        // void setSteps(const QList<StepItem>& value);

        const QList<StepItem*>& steps() const;
        void setSteps(const QList<StepItem*>& value);


        PlcIOModel* plcModel() const;
        void setPlcModel(PlcIOModel* value);

        ServoModbusDevice* xServoDevice() const;
        void setXServoDevice(ServoModbusDevice* value);

        ServoModbusDevice* yServoDevice() const;
        void setYServoDevice(ServoModbusDevice* value);


        bool isRunning() const;
        bool isReady() const;

    signals:
        void countChanged();
        void currentSelectedChanged();
        void currentRunningChanged();

        void stepsChanged();

        void stepStarted();
        void stepFinished();

        void plcModelChanged();
        void xServoDeviceChanged();
        void yServoDeviceChanged();

    protected slots:
        void onEmergencyStop();
        void onStepStarted();
        void onStepFinished();

        void onXServoPosStarted();
        void onXServoPosCompleted();

        void onYServoPosStarted();
        void onYServoPosCompleted();

        void onStepTrigger();

    protected:
        virtual void applyServosStep(StepItem* step);
        // virtual void applyServoHoming(ServoModbusDevice* servo);
        // virtual void applyServoGotoPosition(ServoModbusDevice* servo, StepItem* step);

        virtual void applyPlcStep(StepItem* step);

        virtual bool servosStepCompleted(StepItem* step);
        virtual bool plcStepCompleted(StepItem* step);


        virtual void readyMemories();
        virtual void restoreMemories();
        virtual bool currentStepCompleted(StepItem* step);
        virtual void nextStep();

        void makePlcModelConnection();
        void makeXServoConnection();
        void makeYServoConnection();

    private:
        PlcIOModel* m_plcModel = nullptr;
        ServoModbusDevice* m_xServoDevice = nullptr;
        ServoModbusDevice* m_yServoDevice = nullptr;

        QList<StepItem*> m_items; // All IO

        // QList<StepItem> m_steps;

        int m_currentSelected = -1, m_currentRunning = -1; // -1 is Stop until stepStart active

        QTimer m_stepsTimer;
        bool m_processOnDemand = false;
        bool m_waitForNextStep = false;

        bool m_xServoHomeOnDemand = false;
        bool m_xServoGotoPosOnDemand = false;

        bool m_yServoHomeOnDemand = false;
        bool m_yServoGotoPosOnDemand = false;

        bool m_delayOnDemand = false;
};
#endif // STEPMODEL_H
