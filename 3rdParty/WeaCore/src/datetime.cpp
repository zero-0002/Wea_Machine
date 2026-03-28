#include "WeaCore/datetime.h"
#include "datetime_p.h"

#include "WeaCore/utils.h"
#include <QDateTime>

WEACORE_NAMESPACE_START

/** Template Shortcuts **/
using TDateTimeFmt = DateTime::DateTimeFormat;
using TMonthFmt = DateTime::MonthFormat;

/** Public Class **/

DateTime::DateTime()
    :
    DateTime(new DateTimePrivate(this))
{

}

DateTime::DateTime(int datetimeFormat, int monthFormat)
    :
    DateTime(new DateTimePrivate(this, datetimeFormat, monthFormat))
{

}

DateTime::DateTime(DateTimePrivate* d)
    :
    d_ptr(d)
{

}

DateTime::DateTime(const DateTime& other)
    :
    DateTime(new DateTimePrivate(this))
{
    if (this != &other)
    {
        this->d_ptr->params = other.d_ptr->params;
    }
}

DateTime::~DateTime()
{

}

DateTime& DateTime::operator=(const DateTime& other)
{
    if (this != &other)
    {
        this->d_ptr->params = other.d_ptr->params;
    }
    return *this;
}

QString DateTime::currentDateTimeStr() const
{
    return QDateTime::currentDateTime().toString(d_ptr->datetimeFormatToString());
}

QString DateTime::formatStr() const
{
    return d_ptr->datetimeFormatToString();
}

int DateTime::format() const
{
    return d_ptr->params.format;
}

void DateTime::setFormat(int fmt)
{
    Q_D(DateTime);
    d->params.format = fmt;
}

QString DateTime::monthFormatStr() const
{
    return d_ptr->monthFormatToString();
}

int DateTime::monthFormat() const
{
    return d_ptr->params.monthFormat;
}

void DateTime::setMonthFormat(int fmt)
{
    Q_D(DateTime);
    d->params.monthFormat = fmt;
}

/** Private Class Implementation **/

DateTimePrivate::DateTimePrivate(DateTime* q)
    :
    q_ptr(q)
{

}

DateTimePrivate::DateTimePrivate(DateTime* q, int datetimeFormat, int monthFormat)
    :
    DateTimePrivate(q)
{
    params.format = datetimeFormat;
    params.monthFormat = monthFormat;
}

const QString DateTimePrivate::monthFormatToString() const
{
    switch (params.monthFormat)
    {
        case TMonthFmt::Number:
            return "-MM";
        case TMonthFmt::ShortName:
            return "-MMM";
        case TMonthFmt::CompleteName:
            return "-MMMM";
        default:
            return "";
    }
}

const QString DateTimePrivate::datetimeFormatToString() const
{
    QString fmt = "";
    fmt.reserve(36);
    if (hasFlag(TDateTimeFmt::Year, params.format))
    {
        fmt += "yyyy";
    }
    if (hasFlag(TDateTimeFmt::Month, params.format))
    {
        fmt += monthFormatToString();
    }
    if (hasFlag(TDateTimeFmt::Day, params.format))
    {
        fmt += "-dd";
    }
    if (hasFlag(TDateTimeFmt::Hour, params.format))
    {
        fmt += " hh";
    }
    if (hasFlag(TDateTimeFmt::Minute, params.format))
    {
        fmt += ":mm";
    }
    if (hasFlag(TDateTimeFmt::Second, params.format))
    {
        fmt += ":ss";
    }
    if (hasFlag(TDateTimeFmt::Milli, params.format))
    {
        fmt += ".zzz";

    }
    if (fmt.startsWith(' '))
    {
        fmt.remove(0, 1);
    }
    return fmt;
}

WEACORE_NAMESPACE_END
