#ifndef DATETIME_P_H
#define DATETIME_P_H

#include "WeaCore/init.h"

WEACORE_NAMESPACE_START

class DateTime;
/*!
 * \brief The DateTimePrivate class
 */
class DateTimePrivate
{
        Q_DECLARE_PUBLIC(DateTime)
    public:
        /*!
         * \brief The DateTimeParameters class
         * \details Includes DateTimePrivate members much cleaner than implement as single member.
         */
        class DateTimeParameters
        {
            public:
                int format = 127; // Equal with DateTimeFormat::All enum.
                int monthFormat = 1; // Equal with MonthFormat::ShortName.

        };

        /*!
         * \brief DateTimePrivate
         * \param q : DateTime instance.
         */
        DateTimePrivate(DateTime* q);
        /*!
         * \brief DateTimePrivate
         * \param q
         * \param datetimeFormat : referer DateTimeParameters.format.
         * \param monthFormat : referer DateTimeParamteres.monthFormat.
         */
        DateTimePrivate(DateTime* q, int datetimeFormat, int monthFormat);

        /** Logics **/
        /*!
         * \brief monthFormatToString
         * \return const QString : converted DateTimeParamteres.monthFormat to string using DateTime::MonthFormat enum.
         */
        const QString monthFormatToString() const;
        /*!
         * \brief datetimeFormatToString
         * \return const QString : converted DateTimeParamteres.format to string using DateTime::DateTimeFormat enum.
         */
        const QString datetimeFormatToString() const;

    private:
        DateTime* q_ptr = nullptr;
        DateTimeParameters params;
};

WEACORE_NAMESPACE_END

#endif // DATETIME_P_H
