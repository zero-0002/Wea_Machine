#ifndef STEPITEM_H
#define STEPITEM_H

#include <QObject>
#include <QVariantList>
#include <QJsonObject>
#include <WeaCore/utils.h>

class StepItem : public QObject
{
        Q_OBJECT

        W_PROP_HDEF(QVariantList, plcOutputTargets, PlcOutputsTargets, {}) // referer PlcIOModel::outputs (indices)
        W_PROP_HDEF(QVariantList, conditionBits, ConditionBits, {})

        W_PROP_HDEF(QString, name, Name, "")
        W_PROP_HDEF(int, stepId, StepId, -1)

        W_PROP_HDEF(qint32, xServoPos, XServoPos, 0)
        W_PROP_HDEF(quint16, xServoSpeed, XServoSpeed, 250) // 0.1 rpm
        W_PROP_HDEF(quint16, xServoAcc, XServoAcc, 200) // ms
        W_PROP_HDEF(quint16, xServoDec, XServoDec, 200) // ms

        W_PROP_HDEF(qint32, yServoPos, YServoPos, 0)
        W_PROP_HDEF(quint16, yServoSpeed, YServoSpeed, 250) // 0.1 rpm
        W_PROP_HDEF(quint16, yServoAcc, YServoAcc, 200) // ms
        W_PROP_HDEF(quint16, yServoDec, YServoDec, 200) // ms

        W_PROP_HDEF(int, delay, Delay, 0)
        W_PROP_HDEF(int, bitwiseMethod, BitwiseMethod, BitwiseAND)
        W_PROP_HDEF(bool, bitwiseEnable, BitwiseEnable, false)

        W_PROP_HDEF(bool, xPosActive, XPosActive, false)
        W_PROP_HDEF(bool, xServoOn, XServoON, false)
        W_PROP_HDEF(bool, xServoHome, XServoHome, false)

        W_PROP_HDEF(bool, yPosActive, YPosActive, false)
        W_PROP_HDEF(bool, yServoOn, YServoON, false)
        W_PROP_HDEF(bool, yServoHome, YServoHome, false)

    public:
        enum BitwiseMethod
        {
            BitwiseAND = 0,
            BitwiseOR,
            BitwiseXOR
        };

        explicit StepItem(QObject* parent = nullptr);

        /** Copy Constructures **/
        StepItem(const StepItem& other);
        StepItem& operator=(const StepItem& other);

        /** Public Functions **/
        // Q_INVOKABLE void readFromSettings();
        // Q_INVOKABLE void writeToSettings() const;

        QJsonObject toJson() const;
        void fromJson(const QJsonObject& jsonObj);
    protected:
        void doCopy(const StepItem& other);

    signals:
};

#endif // STEPITEM_H
