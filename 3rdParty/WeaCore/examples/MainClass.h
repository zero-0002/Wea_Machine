#ifndef MAINCLASS_H
#define MAINCLASS_H

#include "WeaCore/loggerstream.h"
#include "WeaCore/datetime.h"

// USE_NAMESPACE_WEACORE
enum Test
{
    First = 0,
    Second
};

class MainClass : public QObject
{

        Q_OBJECT
        W_PROP_HDEF(QString, prop1, Prop1, "Property1")
    public:
        MainClass()
        {
            WeaCore::LoggerStream::setLogLevelShort(true);
            WeaCore::LoggerStream::setDefaultDateTime({WeaCore::DateTime::HMSZ, WeaCore::DateTime::CompleteName});

            QString value = "Parsa POurnabi";
            wDebug() << value;
            wDebug().nologlevel() << value;
            wWarning().notimestamp() << value;
            wInfo().noclassname() << value;
            wCritical().nofunctionname() << value;
            wError().noline().line() << value;
            wDebug().datetimeFormat(WeaCore::DateTime::DateTimeFormat::All) << value;
            wDebug().datetimeMonthFormat(WeaCore::DateTime::MonthFormat::Number) << value;
            wDebug().datetimeMonthFormat(WeaCore::DateTime::MonthFormat::CompleteName) << value;
            // wDebug().noline() << value;
            Test t = First;
            qDebug() << Test::First;
        }
        Q_ENUM(Test)
};


#endif // MAINCLASS_H
