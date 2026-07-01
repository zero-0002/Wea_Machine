#ifndef STEPMODEL_H
#define STEPMODEL_H

#include <QAbstractListModel>
#include <QTimer>
#include <QJSValue>
#include <QElapsedTimer>
#include <QDebug>

#include <WeaCore/utils.h>
#include "Addresses.h"

enum ExecutionState
{
    Idle,
    Dispatching,
    WaitingMotion,
    WaitingDelay,
    Finished,
    Emergency,
    Error
};

enum RunMode
{
    Sequence,
    SingleStep
};

class ServoModbusDevice;
class PlcIOModel;
class StepItem;
class  StepModel : public QAbstractListModel
{
        Q_OBJECT
        Q_PROPERTY(int count READ count NOTIFY countChanged)
        W_PROP_HDEF(int, currentSelected, CurrentSelected, -1) // Index
        W_PROP_HDEF(int, currentRunning, CurrentRunning, -1) // Index

        // Q_PROPERTY(QList<StepItem> steps READ steps WRITE setSteps NOTIFY stepsChanged)
        Q_PROPERTY(QList<StepItem*> steps READ steps WRITE setSteps NOTIFY stepsChanged)

        Q_PROPERTY(PlcIOModel* plcModel READ plcModel WRITE setPlcModel NOTIFY plcModelChanged)
        Q_PROPERTY(ServoModbusDevice* xServoDevice READ xServoDevice WRITE setXServoDevice NOTIFY xServoDeviceChanged)
        Q_PROPERTY(ServoModbusDevice* yServoDevice READ yServoDevice WRITE setYServoDevice NOTIFY yServoDeviceChanged)

        W_PROP_HDEF(bool, enabled, Enabled, false)
        W_PROP_HDEF(int, interval, Interval, 250)
        READ_PROP(bool, running) // isRunning
        READ_PROP(bool, ready) // isReady


    public:
        enum StepRoles
        {
            IdRole = Qt::UserRole + 1, // Item Index
            NameRole,

            BitwiseEnableRole,
            BitwiseMethodRole,

            XPosActiveRole,
            XServoONRole,
            XServoHomeRole,
            XServoPosRole,
            XServoSpdRole,
            XServoAccRole, // Deactive yet
            XServoDecRole, // Deactive yet

            YPosActiveRole,
            YServoONRole,
            YServoHomeRole,
            YServoPosRole,
            YServoSpdRole,
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
        void setData(StepItem* step, const QVariant& value, int role);
        QHash<int, QByteArray> roleNames() const override;

        void reverseRoleNames();
        bool isJsValid(const QJSValue& jsValue);

        /** Model Helper **/
        Q_INVOKABLE bool addItem(QJSValue jsItem); // JS Value should be an object key-based on roleNames
        Q_INVOKABLE bool addItem(StepItem* item);
        Q_INVOKABLE bool editItem(int index, QJSValue jsItem); // JS Value should be an object key-based on roleNames
        Q_INVOKABLE bool remove(int index);
        Q_INVOKABLE bool removeItem(int index);

        Q_INVOKABLE bool move(int from, int to);
        Q_INVOKABLE bool moveUp(int index);
        Q_INVOKABLE bool moveDown(int index);

        Q_INVOKABLE QStringList stepNames() const;

        Q_INVOKABLE void updateAll();
        Q_INVOKABLE void clear();
        Q_INVOKABLE bool isEmpty() const;
        Q_INVOKABLE bool empty() const;
        Q_INVOKABLE int count() const;

        /** StepModel Specification **/
        Q_INVOKABLE StepItem* getItem(int index) const;
        Q_INVOKABLE bool saveToJsonFile(const QString& filePath) const;
        Q_INVOKABLE bool loadFromJsonFile(const QString& filePath);


        /** StepModel Logic handlers **/
        Q_INVOKABLE bool start();
        Q_INVOKABLE bool runSelected();
        Q_INVOKABLE bool runStep(int index);
        Q_INVOKABLE void stop();
        Q_INVOKABLE void emergencyStop();

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

        void onStepTrigger();

    protected:
        void dispatchCurrentStep();
        void updateRunningState();
        void updateDelay();
        void finishExecution();

        virtual void applyServosStep(StepItem* step);
        // virtual void applyServoHoming(ServoModbusDevice* servo);
        // virtual void applyServoGotoPosition(ServoModbusDevice* servo, StepItem* step);

        virtual void applyPlcStep(StepItem* step);

        virtual bool servosStepCompleted(StepItem* step);
        virtual bool plcStepCompleted(StepItem* step);


        virtual void readyMemories();
        virtual void restoreMemories();
        virtual bool currentStepCompleted(StepItem* step);

        void makePlcModelConnection();
        void makeXServoConnection();
        void makeYServoConnection();

    private:
        StepItem* current();
        void syncJsWithStepItem(const QJSValue& jsValue, StepItem* step);

        PlcIOModel* m_plcModel = nullptr;
        ServoModbusDevice* m_xServoDevice = nullptr;
        ServoModbusDevice* m_yServoDevice = nullptr;

        QHash<QByteArray, int> m_roleNameToId; // Reverse of RoleNames
        QList<StepItem*> m_items; // All IO

        // QList<StepItem> m_steps;
        QTimer m_stepsTimer;

        StepItem* m_currentStep = nullptr;
        QElapsedTimer m_delayTimer;

        ExecutionState m_state = ExecutionState::Idle;
        RunMode m_runMode = RunMode::Sequence;

        bool m_servosCompleted = false;
        bool m_plcCompleted = false;
};
#endif // STEPMODEL_H
