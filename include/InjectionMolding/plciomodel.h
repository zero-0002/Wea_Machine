#ifndef PLCIOMODEL_H
#define PLCIOMODEL_H


#include <QAbstractListModel>
#include <QDebug>
#include "plcioitem.h"

/*!
 * \brief The PlcIOModel class Singleton
 */
class  PlcIOModel : public QAbstractListModel
{
        Q_OBJECT
        Q_PROPERTY(int count READ count NOTIFY countChanged)
        Q_PROPERTY(int inputsCount READ inputsCount NOTIFY inputsChanged)
        Q_PROPERTY(int outputsCount READ outputsCount NOTIFY outputsChanged)
        Q_PROPERTY(QList<PlcIOItem*> inputs READ inputs NOTIFY inputsChanged)
        Q_PROPERTY(QList<PlcIOItem*> outputs READ outputs NOTIFY outputsChanged)
    public:
        enum IORoles
        {
            IONumberRole = Qt::UserRole + 1,
            NameRole,
            DisplayNameRole,
            OnDelayIntervalRole,
            OffDelayIntervalRole,
            BlinkIntervalRole,
            IOTypeRole,
            ContactTypeRole,
            CoilActiveRole,
            ActiveFeedbackRole,
            ActiveRole,
            OutputEnabledRole,
            StopInterruptTargetsRole,
            SignalForwardInterruptTargetsRole,
        };
        Q_ENUM(IORoles)


        explicit PlcIOModel(QObject* parent = nullptr);

        inline static PlcIOModel& getInstance()
        {
            static PlcIOModel instance;
            return instance;
        }

        int rowCount(const QModelIndex& parent = QModelIndex()) const override;
        QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
        bool setData(const QModelIndex& index, const QVariant& value, int role) override;
        QHash<int, QByteArray> roleNames() const override;

        /** Model Helper **/
        Q_INVOKABLE const QList<PlcIOItem*>& inputs() const;
        Q_INVOKABLE const QList<PlcIOItem*>& outputs() const;

        Q_INVOKABLE bool addItem(int ioIndex, int ioType, const QString& name);
        Q_INVOKABLE bool addItem(PlcIOItem* item);

        Q_INVOKABLE void updateAll();

        Q_INVOKABLE void clear();

        Q_INVOKABLE bool isEmpty() const;

        Q_INVOKABLE bool empty() const;

        Q_INVOKABLE int count() const;

        Q_INVOKABLE int inputsCount() const;
        Q_INVOKABLE int outputsCount() const;

        /** User Interface IO **/
        Q_INVOKABLE bool setCoilActive(int index, bool active);

        /** Set From Communication **/
        /*!
         * \brief setInputCoil: Sets index by inputsIndices
         * \param index
         * \param value
         */
        bool setInputCoil(int index, bool value);
        /*!
         * \brief setOutputCoil: Sets index by outputsIndices
         * \param index
         * \param value
         */
        bool setOutputCoil(int index, bool value);

    signals:
        void countChanged();
        void inputsChanged();
        void outputsChanged();

        /** Communication Interface **/
        void outputCoilChanged(int outputIndex, bool active);

        void emergencyStop();
        void stepStarted();

    protected:
        bool setInputData(int index, const QVariant& value, IORoles);
        bool setOutputData(int index, const QVariant& value, IORoles role);

        void syncStopInterrupts(PlcIOItem* target);
        void syncSignalFwdInterrupts(PlcIOItem* target);

    private:
        QList<PlcIOItem*> m_inputs;
        QList<PlcIOItem*> m_outputs;

        QList<PlcIOItem*> m_items; // All IO
};

#endif // PLCIOMODEL_H
