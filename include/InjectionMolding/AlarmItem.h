#ifndef ALARMITEM_H
#define ALARMITEM_H

#include <WeaCore/utils.h>

class AlarmItem : public QObject
{
        Q_OBJECT
        W_PROP_HDEF(int, code, Code, -1)
        W_PROP_HDEF(QString, description, Description, "")
        W_PROP_HDEF(QString, codePrefix, CodePrefix, "")
    public:
        explicit AlarmItem(int code, const QString& desc, const QString& codePrefix, QObject* parent = nullptr)
            : QObject(parent),
              m_code(code),
              m_description(desc),
              m_codePrefix(codePrefix)
        {

        }

        /** Copy Constructures **/
        AlarmItem(const AlarmItem& other)
        {
            if (this == &other)
            {
                return;
            }

            m_code = other.m_code;
            m_description = other.m_description;
            m_codePrefix = other.m_codePrefix;
        }

        AlarmItem& operator=(const AlarmItem& other)
        {

            if (this == &other)
            {
                return *this;
            }

            m_code = other.m_code;
            m_description = other.m_description;
            m_codePrefix = other.m_codePrefix;
            return *this;
        }


        const QString codeStr() const
        {
            return QString("%1-%2").arg(m_codePrefix).arg(m_code);
        }
};

#endif // ALARMITEM_H
