#ifndef AXISCONFIG_H
#define AXISCONFIG_H

#include <WeaCore/utils.h>
#include <QQmlParserStatus>

class AxisConfig : public QObject, public QQmlParserStatus
{
        Q_OBJECT
        W_PROP_HDEF(QString, unitName, UnitName, "PUU")
        Q_PROPERTY(qint64 numerator MEMBER m_numerator CONSTANT)
        Q_PROPERTY(qint64 denominator MEMBER m_denominator CONSTANT)
        Q_PROPERTY(qint64 zeroPUU MEMBER m_zeroPUU CONSTANT)
        Q_PROPERTY(qint32 maxDecimals MEMBER m_maxDecimals CONSTANT)
        W_PROP_HDEF(qint32, decimals, Decimals, 0)
    public:
        explicit AxisConfig(QObject* parent = nullptr);

        void classBegin() override;
        void componentComplete() override;

        /** Slots **/
        Q_INVOKABLE double toUnit(qint32 puu) const;
        Q_INVOKABLE qint32 toPUU(double unit) const;

        Q_INVOKABLE void setZeroPUU(qint32 zeroPUU);
        Q_INVOKABLE void setScale(qint64 numerator, qint64 denominator);

        Q_INVOKABLE void syncronize(AxisConfig* other);

    signals:
        void gearRatioChanged();

    protected:
        void updateAll();

        /** Settings Storage **/
        void readFromSettings();
        void writeToSettings() const;

    private:
        void applyMaxDecimals();

        qint64 m_numerator;
        qint64 m_denominator;

        qint32 m_zeroPUU; // Offset error of Encoder (Optional)
        qint32 m_maxDecimals;
};

#endif // AXISCONFIG_H
