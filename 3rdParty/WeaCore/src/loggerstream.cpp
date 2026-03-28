#include "WeaCore/loggerstream.h"
#include "loggerstream_p.h"

#include "WeaCore/datetime.h"

#include <QDateTime>

WEACORE_NAMESPACE_START

/** Template Shortcuts **/
using TLogFilter = LoggerStream::LogFilter;

/** Public Class **/

LoggerStream::LoggerStream(const QObject* obj, int level, const char* functionName, int line)
    :
    d_ptr(new LoggerStreamPrivate(this,
                                  level,
                                  obj,
                                  functionName,
                                  line))
{

}

LoggerStream::~LoggerStream()
{
    Q_D(LoggerStream);
    if (d->debugIsEnabled())
    {
        d->puzzleLogFilters();
        d->printLoggedMessage();
    }
}

LoggerStream& LoggerStream::nologlevel()
{
    Q_D(LoggerStream);
    d->params.logFilter = removeFlag(d->params.logFilter, TLogFilter::Level);
    return *this;
}

LoggerStream& LoggerStream::loglevel()
{
    Q_D(LoggerStream);
    d->params.logFilter = addFlag(d->params.logFilter, TLogFilter::Level);
    return *this;
}

LoggerStream& LoggerStream::notimestamp()
{
    Q_D(LoggerStream);
    d->params.logFilter = removeFlag(d->params.logFilter, TLogFilter::Timestamp);
    return *this;

}

LoggerStream& LoggerStream::timestamp()
{
    Q_D(LoggerStream);
    d->params.logFilter = addFlag(d->params.logFilter, TLogFilter::Timestamp);
    return *this;

}

LoggerStream& LoggerStream::noclassname()
{

    Q_D(LoggerStream);
    d->params.logFilter = removeFlag(d->params.logFilter, TLogFilter::ClassName);
    return *this;
}

LoggerStream& LoggerStream::classname()
{
    Q_D(LoggerStream);
    d->params.logFilter = addFlag(d->params.logFilter, TLogFilter::ClassName);
    return *this;

}

LoggerStream& LoggerStream::nofunctionname()
{
    Q_D(LoggerStream);
    d->params.logFilter = removeFlag(d->params.logFilter, TLogFilter::FuncName);
    return *this;
}

LoggerStream& LoggerStream::functionname()
{
    Q_D(LoggerStream);
    d->params.logFilter = addFlag(d->params.logFilter, TLogFilter::FuncName);
    return *this;

}

LoggerStream& LoggerStream::noline()
{
    Q_D(LoggerStream);
    d->params.logFilter = removeFlag(d->params.logFilter, TLogFilter::LineNo);
    return *this;
}

LoggerStream& LoggerStream::line()
{
    Q_D(LoggerStream);
    d->params.logFilter = addFlag(d->params.logFilter, TLogFilter::LineNo);
    return *this;
}

LoggerStream& LoggerStream::datetime(const DateTime& datetime)
{
    Q_D(LoggerStream);
    d->params.datetime = datetime;
    return *this;
}

LoggerStream& LoggerStream::datetimeFormat(int format)
{
    Q_D(LoggerStream);
    d->params.datetime.setFormat(format);
    return *this;
}

LoggerStream& LoggerStream::datetimeMonthFormat(int format)
{
    Q_D(LoggerStream);
    d->params.datetime.setMonthFormat(format);
    return *this;
}

bool LoggerStream::isLogLevelShort()
{
    return logLevelShort();
}

bool LoggerStream::logLevelShort()
{
    return LoggerStreamPrivate::globalLogLevelShort;
}

void LoggerStream::setLogLevelShort(bool value)
{
    LoggerStreamPrivate::globalLogLevelShort = value;
}

LoggerStream::LogFilter LoggerStream::defaultLogFilter()
{
    return (LoggerStream::LogFilter) LoggerStreamPrivate::globalLogFilter;
}

void LoggerStream::setDefaultLogFilter(LogFilter filter)
{
    LoggerStreamPrivate::globalLogFilter = filter;
}

DateTime LoggerStream::defaultDateTime()
{
    return LoggerStreamPrivate::globalDateTime;
}

void LoggerStream::setDefaultDateTime(const DateTime& datetime)
{
    LoggerStreamPrivate::globalDateTime = datetime;
}

QDebug& LoggerStream::debug()
{
    Q_D(LoggerStream);
    return d->m_debug;
}

typedef QDebug& (*QDebugManipulator)(QDebug&);
LoggerStream& LoggerStream::operator<<(QDebugManipulator manip)
{
    Q_D(LoggerStream);
    d->m_debug << manip;
    return *this;
}

/** Private Impelmentation Class **/

LoggerStreamPrivate::LoggerStreamPrivate(
    LoggerStream* q,
    int level,
    const QObject* obj,
    const char* functionName,
    int line)

    :
    q_ptr(q),
    m_buffer(),
    m_debug(&m_buffer)
{
    this->params.level = level;
    this->params.obj = obj;
    this->params.function = functionName;
    this->params.line = line;
    this->params.logFilter = globalLogFilter;
    this->params.datetime = globalDateTime;

    m_debug.noquote().noquote();
}

const QString LoggerStreamPrivate::logLevelToString(int level) const
{
    switch (level)
    {
        case LoggerStream::LogLevel::Debug:
            return globalLogLevelShort ? "D" : "DEBUG";
        case LoggerStream::LogLevel::Info:
            return globalLogLevelShort ? "I" : "INFO";
        case LoggerStream::LogLevel::Warning:
            return globalLogLevelShort ? "W" : "WARNING";
        case LoggerStream::LogLevel::Critical:
            return globalLogLevelShort ? "E" : "ERROR";
        default:
            return globalLogLevelShort ? "U" : "UNKNOWN";
    }
}

bool LoggerStreamPrivate::debugIsEnabled()
{
    return debugIsEnabled(params.obj);
}

bool LoggerStreamPrivate::debugIsEnabled(const QObject* obj)
{
    if (!obj  || obj == nullptr)
    {
        return false;
    }
    const QMetaObject* meta = obj->metaObject();
    int propIndex = -1;
    const char* propName = "debug";
    propIndex = meta->indexOfProperty(propName);

    if (propIndex < 0)
    {
        propName = "debugMode";
        propIndex = meta->indexOfProperty(propName);
    }
    if (propIndex >= 0)
    {
        QVariant value = obj->property(propName);
        if (value.isValid() && value.canConvert<bool>())
        {
            return value.toBool();
        }
    }
    return WEA_DEBUG;
}

void LoggerStreamPrivate::puzzleLogFilters()
{
    QString prefix = "";
    prefix.reserve(256);
    if (hasFlag(TLogFilter::Level, params.logFilter))
    {
        prefix += QString("[%1]").arg(logLevelToString(params.level));
    }
    if (hasFlag(TLogFilter::Timestamp, params.logFilter))
    {
        prefix += QString("[%1]").arg(params.datetime.currentDateTimeStr());
    }
    if (hasFlag(TLogFilter::ClassName, params.logFilter) || hasFlag(TLogFilter::FuncName, params.logFilter))
    {
        prefix += "[";
        if (hasFlag(TLogFilter::ClassName, params.logFilter) && params.obj)
        {
            prefix += QString("%1::").arg(params.obj->metaObject()->className());
        }
        if (hasFlag(TLogFilter::FuncName, params.logFilter))
        {
            prefix += QString("%1").arg(params.function);
        }
        prefix += "]";
    }
    if (hasFlag(TLogFilter::LineNo, params.logFilter))
    {
        prefix += QString("[Line:%1]").arg(params.line);
    }
    if (!isSameFlag(TLogFilter::NoneLog, params.logFilter))
    {
        prefix += ": ";
    }

    if (!m_buffer.isEmpty())
    {
        m_buffer.prepend(prefix);
    }
}

void LoggerStreamPrivate::printLoggedMessage() const
{
    qDebug().noquote().nospace() << m_buffer;
}

WEACORE_NAMESPACE_END
