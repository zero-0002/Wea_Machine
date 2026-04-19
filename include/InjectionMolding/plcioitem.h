#ifndef PLCIOITEM_H
#define PLCIOITEM_H

#include <WeaCore/utils.h>
#include "Addresses.h"

#include <QTimer>
#include <QHash>
#include <QMap>

class PlcIOItem : public QObject
{
        Q_OBJECT

        W_PROP_HDEF(int, ioIndex, IoIndex, -1) // Required property (also ioIndex is unique only at same ioType)
        W_PROP_HDEF(QString, name, Name, "")
        W_PROP_HDEF(QString, displayName, DisplayName, "")

        // Timers Unit is milliseconds
        W_PROP_HDEF(int, onDelayInterval, OnDelayInterval, 0) // 0 === disabled
        W_PROP_HDEF(int, offDelayInterval, OffDelayInterval, 0) // 0 === disabled
        W_PROP_HDEF(int, blinkInterval, BlinkInterval, 0) // 0 === disabled
        W_PROP_HDEF(int, feedbackTimeout, FeedbackTimeout, 3500) // CoilFeedback Timeout after activation

        W_PROP_HDEF(int, type, Type, -1) // Referer IOType enum
        W_PROP_HDEF(int, contactType, ContactType, NormallyOpen)
        W_PROP_HDEF(int, stopMethod, StopMethod, LatchedCoilRst)
        W_PROP_HDEF(int, signalForwardMethod, SignalForwardMethod, SetReset)
        W_PROP_HDEF(bool, hasStepStartInterrupt, HasStepStartInterrupt, false)

        UNSAFE_PROP_HDEF(bool, coilActive, CoilActive, false) // Immediately response of Input/Output
        W_PROP_HDEF(bool, activeFeedback, ActiveFeedback, false) // Response from communication (must be value from communication class)
        READ_PROP(bool, active) // Read-only- Input/Output response after OnDelay/OffDelay Timers

        W_PROP_HDEF(bool, outputEnabled, OutputEnabled, true) // This property holds condition for OutputType => coilActive/active properties

        W_PROP_HDEF(QVariantList, stopInterruptTargets, StopInterruptTargets, {}) // List of outputIndex
        W_PROP_HDEF(QVariantList, signalForwardInterruptTargets, SignalForwardInterruptTargets, {}) // List of outputIndex

    public:
        enum IOType
        {
            InputType = 0, // X
            OutputType // Y
        };
        Q_ENUM(IOType)

        enum ContactType
        {
            NormallyOpen = 0,
            NormallyClose,
        };
        Q_ENUM(ContactType)

        enum InterruptType
        {
            NoInterrupt = 0,
            StopInterrupt, // Emergency Interruption (This will be emit emergencyStop signal and can be use to reset siblings)
            SignalForwardInterrupt,
            StepStartInterrupt // Steps Start Interruption (This will be emit stepStart signal)
        };
        Q_ENUM(InterruptType)

        enum StopMethod
        {
            LatchedCoilRst = 0, // CoilActive will not be reset if stop is active
            ForceRst // Deactivating Active/CoilActive properties
        };
        Q_ENUM(StopMethod)

        enum SignalForwardMethod
        {
            SetReset = 0, // forward set and reset of current coil
            SetOnly, // Forward only set state
            ResetOnly, // Forward only reset state
            Togglable // Forward by toggling
        };
        Q_ENUM(SignalForwardMethod)

        enum PropertyName
        {
            DISPLAY_NAME = 0,
            ON_DELAY_INTERVAL,
            OFF_DELAY_INTERVAL,
            BLINK_INTERVAL,
            CONTACT_TYPE,
            STOP_METHOD,
            SIGNAL_FORWARD_METHOD,
            STEP_START_INTERRUPT,
            STOP_INTERRUPT_TARGETS,
            SIGNAL_FORWARD_INTERRUPT_TARGETS,
        };

        explicit PlcIOItem(int ioIndex, int ioType, const QString& name, QObject* parent = nullptr);

        /** Public Functions **/
        Q_INVOKABLE bool containsAtStopTargets(int index);
        Q_INVOKABLE bool containsAtSignalFwdTargets(int index);
        Q_INVOKABLE void readFromSettings();
        Q_INVOKABLE void writeToSettings() const;

        /** Getters / Setters **/
        bool isOutputEnabled() const;
        bool isCoilActive() const;
        bool invalidToActive() const;

        bool addInterruptItem(int interruptType, const QList<PlcIOItem*>& items);

        /** Copy Constructures **/
        PlcIOItem(const PlcIOItem& other);
        PlcIOItem& operator=(const PlcIOItem& other);

        /** Statics **/
        inline static QHash<int, QString> PropertyNameSettings =
        {
            {DISPLAY_NAME, TO_STR(DISPLAY_NAME)},
            {ON_DELAY_INTERVAL, TO_STR(ON_DELAY_INTERVAL) },
            {OFF_DELAY_INTERVAL, TO_STR(OFF_DELAY_INTERVAL) },
            {BLINK_INTERVAL, TO_STR(BLINK_INTERVAL) },
            {CONTACT_TYPE, TO_STR(CONTACT_TYPE) },
            {STOP_METHOD, TO_STR(STOP_METHOD) },
            {SIGNAL_FORWARD_METHOD, TO_STR(SIGNAL_FORWARD_METHOD) },
            {STEP_START_INTERRUPT, TO_STR(STEP_START_INTERRUPT) },
            {STOP_INTERRUPT_TARGETS, TO_STR(STOP_INTERRUPT_TARGETS) },
            {SIGNAL_FORWARD_INTERRUPT_TARGETS, TO_STR(SIGNAL_FORWARD_INTERRUPT_TARGETS) },
        };

    signals:
        void errorOccured(int code, const QString& message);
        void dataChanged();
        void interruptTargetsChanged();

        void onDelayTriggered();
        void offDelayTriggered();

        void activated();
        void deactivated();

        // Interrupt Signal
        void stepStart();
        void emergencyStop();

    protected:
        void doCopy(const PlcIOItem& other);

        void applyInterrupts();
        void applyStopInterrupt();
        void applySignalForwardInterrupt();

    protected slots:
        /** Timer Functions **/
        void triggerOnDelay();
        void triggerOffDelay();


        /** Activation Functions **/
        bool setActive(bool value, bool force = false);
        void activate();
        void deactivate();

        void checkActiveResponse();

    private:
        void makeConnections();
        QString getSettingName(int property) const;

        /** Members **/
        bool m_lastDelayTmr = false; // False means Off Delay was last one otherwise onDelay
        bool m_toggled = false; // Referer SignalForwardMethod::Togglable type
        QTimer m_blinkTimer;
        QMap<int, QList<PlcIOItem*>> m_interruptItems; // key = InterruptType
};

#endif // PLCIOITEM_H
