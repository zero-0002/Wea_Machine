#ifndef LOGGERSTREAM_H
#define LOGGERSTREAM_H

#include "utils.h"
#include "init.h"
#include <QDebug>

WEACORE_NAMESPACE_START

class DateTime;
class LoggerStreamPrivate;
/*!
 * \brief The LoggerStream class
 */
class LoggerStream
{
        Q_DISABLE_COPY(LoggerStream)
        Q_DECLARE_PRIVATE(LoggerStream)

    public:
        /*!
         * \brief The LogLevel enum
         */
        enum LogLevel
        {
            Debug = 0,
            Info,
            Warning,
            Critical
        };
        /*!
         * \brief The LogFilter enum
         */
        enum LogFilter
        {
            NoneLog = 0,
            Level = 1 << 0, // LogLevel
            Timestamp = 1 << 1,
            ClassName = 1 << 2,
            FuncName = 1 << 3,
            LineNo = 1 << 4,
            All = Level | Timestamp | ClassName | FuncName | LineNo
        };

        /** Statics **/
        /*!
         * \brief isLogLevelShort : global function getter
         * \details if LogLevelShort is enable the DEBUG, WARNING, etc will replace with first character.
         * \return  bool : true if logLevel short is enabled else false.
         */
        static bool isLogLevelShort();
        /*!
         * \brief logLevelShort : global function getter
         * \details if LogLevelShort is enable the DEBUG, WARNING, etc will replace with first character.
         * \return  bool : true if logLevel short is enabled else false.
         */
        static bool logLevelShort();
        /*!
         * \brief setLogLevelShort : global function setter.
         * \param value : bool.
         * \note This function will set for all instances.
         */
        static void setLogLevelShort(bool value);

        /*!
         * \brief defaultLogFilter : global function getter.
         * \return LogFilter : global LogFilter which will use for all instances.
         */
        static LogFilter defaultLogFilter();
        /*!
         * \brief setDefaultLogFilter : global function setter.
         * \param filter : LogFilter -> global LogFilter which want to use for all instances.
         */
        static void setDefaultLogFilter(LogFilter filter);

        /*!
         * \brief defaultDateTime : global function getter.
         * \return  DateTime : global DateTime which will use for all instances.
         */
        static DateTime defaultDateTime();
        /*!
         * \brief setDefaultDateTime : global function setter.
         * \param datetime : DateTime -> global DateTime which want to use for all instances.
         */
        static void setDefaultDateTime(const DateTime& datetime);


        /*!
         * \brief LoggerStream : Default Constructure .
         * \param obj : Current Class which creates current LoggerStream instance.
         * \param level : an integer based on LogLevel enum.
         * \param functionName : Current function name.
         * \param line : Current line number.
         */
        LoggerStream(const QObject* obj, int level, const char* functionName, int line);
        ~LoggerStream();

        /** Logics **/
        typedef QDebug& (*QDebugManipulator)(QDebug&);
        /*!
         * \brief operator << : based on QDebug & QLoggerStream classes.
         * \param manip : QDebugManipulator
         * \return LoggerStream& .
         */
        LoggerStream& operator<<(QDebugManipulator manip);

        /*!
         * \brief operator << : This function will handle the variantation inputs for print and streaming process.
         * \param value : template base value.
         * \return LoggerStream &.
         */
        template<typename T>
        inline LoggerStream& operator<<(T value)
        {
            debug() << value << ' ';
            return *this;
        }

        /*!
         * \brief nologlevel : removing logLevel from current streaming instance.
         * \return LoggerStream& .
         */
        LoggerStream& nologlevel();
        /*!
         * \brief loglevel : adding logLevel from current streaming instance.
         * \return LoggerStream& .
         */
        LoggerStream& loglevel();
        /*!
         * \brief notimestamp : removing timestamp from current streaming instance.
         * \return LoggerStream& .
         */
        LoggerStream& notimestamp();
        /*!
         * \brief timestamp : adding timestamp from current streaming instance.
         * \return LoggerStream& .
         */
        LoggerStream& timestamp();
        /*!
         * \brief noclassname : removing classname from current streaming instance.
         * \return LoggerStream& .
         */
        LoggerStream& noclassname();
        /*!
         * \brief classname : adding classname from current streaming instance.
         * \return LoggerStream& .
         */
        LoggerStream& classname();
        /*!
         * \brief nofunctionname : removing functionName from current streaming instance.
         * \return LoggerStream& .
         */
        LoggerStream& nofunctionname();
        /*!
         * \brief functionname : adding functionname from current streaming instance.
         * \return LoggerStream& .
         */
        LoggerStream& functionname();
        /*!
         * \brief noline : removing line number from current streaming instance.
         * \return LoggerStream& .
         */
        LoggerStream& noline();
        /*!
         * \brief line : adding line from current streaming instance.
         * \return LoggerStream& .
         */
        LoggerStream& line();
        /*!
         * \brief datetime : manual adding datetime format.
         * \param datetime : DateTime
         * \return LoggerStream& .
         */
        LoggerStream& datetime(const DateTime& datetime);
        /*!
         * \brief datetimeFormat : manual adding format based on DateTimeFormat enum.
         * \param format : int -> format based on DateTimeFormat enum.
         * \return LoggerStream & .
         */
        LoggerStream& datetimeFormat(int format);
        /*!
         * \brief datetimeMonthFormat : manual adding monthFormat based on MonthFormat enum.
         * \param format : int -> monthFormat based on MonthFormat enum.
         * \return LoggerStream & .
         */
        LoggerStream& datetimeMonthFormat(int format);

    protected:
        /*!
         * \brief debug : this function will get the debug instance from LoggerStreamPrivate class.
         * \return QDebug : m_debug from LoggerStreamPrivate.
         */
        QDebug& debug();

    private:
        QScopedPointer<LoggerStreamPrivate> d_ptr;
};

/** Macros **/
#if (!defined(WEA_DEBUG)) && defined(QT_DEBUG)
#define WEA_DEBUG true
#elif (!defined(WEA_DEBUG))
#define WEA_DEBUG false
#endif

/*!
 * \brief A ShortCut to implement debug property which can be used and automative for QtWea base classes.
 * \details LoggerStream class will find this property or `debugMode` property automatically and based on that will print the result.
 */
#define WEA_LOGGER(defaultValue) \
    W_PROP_HDEF(bool, debug, Debug, defaultValue)

#define wDebug() WeaCore::LoggerStream(this, WeaCore::LoggerStream::LogLevel::Debug, __FUNCTION__, __LINE__)
#define wInfo() WeaCore::LoggerStream(this, WeaCore::LoggerStream::LogLevel::Info, __FUNCTION__, __LINE__)
#define wWarning() WeaCore::LoggerStream(this, WeaCore::LoggerStream::LogLevel::Warning, __FUNCTION__, __LINE__)
#define wCritical() WeaCore::LoggerStream(this, WeaCore::LoggerStream::LogLevel::Critical, __FUNCTION__, __LINE__)
#define wError() WeaCore::LoggerStream(this, WeaCore::LoggerStream::LogLevel::Critical, __FUNCTION__, __LINE__)

WEACORE_NAMESPACE_END


#endif // LOGGERSTREAM_H
