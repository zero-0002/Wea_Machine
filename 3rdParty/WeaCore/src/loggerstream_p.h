#ifndef LOGGERSTREAM_P_H
#define LOGGERSTREAM_P_H

#include "WeaCore/datetime.h"
#include <QDebug>

WEACORE_NAMESPACE_START

class LoggerStream;
/*!
 * \brief The LoggerStreamPrivate class
 */
class LoggerStreamPrivate
{
        Q_DISABLE_COPY(LoggerStreamPrivate)
        Q_DECLARE_PUBLIC(LoggerStream)

    public:
        /*!
         * \brief The LoggerStreamParameters class
         * \details Includes LoggerStreamPrivate members much cleaner than implement as single member.
         */
        class LoggerStreamParameters
        {
            public:
                const QObject* obj = nullptr;
                int level;
                int line;
                int logFilter;
                const char* function;
                DateTime datetime;
        };

        /*!
         * \brief LoggerStreamPrivate : Default constructure.
         * \param q
         * \param level
         * \param obj
         * \param functionName
         * \param line
         */
        LoggerStreamPrivate(LoggerStream* q,
                            int level,
                            const QObject* obj,
                            const char* functionName,
                            int line);

        /** Configurations **/
        /*!
         * \brief logLevelToString : converts LoggerStreamParamters.level to string value.
         * \details Also this function will check globalLogLevelShort value for return.
         * \param level : int -> based on LogLevel enum.
         * \return const QString : the stringified logLevel based on level param & globalLogLevelShort.
         */
        const QString logLevelToString(int level) const;
        /*!
         * \brief debugIsEnabled : checks the params.obj has `debug` or `debugMode` property or not.
         * \return bool : true if params.obj has `debug` or `debugMode` property else false.
         */
        bool debugIsEnabled();
        /*!
         * \brief debugIsEnabled : checks the obj has `debug` or `debugMode` property or not.
         * \param obj : const QObject *
         * \return bool : true if obj(arg) has `debug` or `debugMode` property else false.
         */
        bool debugIsEnabled(const QObject* obj);

        /** Logics **/
        /*!
         * \brief puzzleLogFilters : Prepend the m_buffer using the LoggerStreamParameters and global static variables.
         * \note This function will be call in destructure.
         */
        void puzzleLogFilters();
        /*!
         * \brief printLoggedMessage : printing the `buffer` which that puzzled from puzzleLogFilters.
         * \note This function will be call in destructure.
         */
        void printLoggedMessage() const;

        /** Statics **/
        inline static bool globalLogLevelShort = false; // Make logLevelToString result with First 'Char'.
        inline static int globalLogFilter = 31; // Default Value is LogFilter::All.
        inline static DateTime globalDateTime; // Default datetime has All with Short Month value.

    private:
        LoggerStream* q_ptr = nullptr;
        LoggerStreamParameters params;
        QString m_buffer; // All params & user add data (with << operator) will be store in this variable.
        QDebug m_debug;
};

WEACORE_NAMESPACE_END

#endif // LOGGERSTREAM_P_H
