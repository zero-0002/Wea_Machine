#ifndef DATETIME_H
#define DATETIME_H

#include "init.h"

WEACORE_NAMESPACE_START

class DateTimePrivate;
/*!
 * \brief The DateTime class
 */
class DateTime
{
        Q_DECLARE_PRIVATE(DateTime)
    public:
        /*!
         * \brief The DateTimeFormat enum
         */
        enum DateTimeFormat
        {
            NoFormat = 0,
            Milli = 1 << 0,
            Second = 1 << 1,
            Minute = 1 << 2,
            Hour = 1 << 3,
            Day = 1 << 4,
            Month = 1 << 5,
            Year = 1 << 6,

            YMD = Year | Month | Day,
            HMS = Hour | Minute | Second,
            HMSZ = HMS | Milli,

            All = YMD | HMSZ,
        };
        /*!
         * \brief The MonthFormat enum
         */
        enum MonthFormat
        {
            Number = 0,
            ShortName,
            CompleteName
        };

        /*!
         * \brief DateTime
         * \details Default Constructrue
         */
        DateTime();
        /*!
         * \brief DateTime
         * \param datetimeFormat
         * \param monthFormat
         */
        DateTime(int datetimeFormat, int monthFormat = 1);
        /*!
         * \brief DateTime
         * \details Implementation Constructure.
         * \param d
         */
        DateTime(DateTimePrivate* d);
        /*!
         * \brief DateTime
         * \details Copy constructure.
         * \param other
         */
        DateTime(const DateTime& other);

        /*!
         * \brief DateTime destructure.
         */
        ~DateTime();

        /** Operators **/
        /*!
         * \brief operator = : Copy operator.
         * \param other
         * \return DateTime &.
         */
        DateTime& operator=(const DateTime& other);

        /** Getters & Setters **/
        /*!
         * \brief currentDateTimeStr
         * \details Same as QDateTime::currentDateTime().toString() but the format is referer d_ptr->params.format.
         * \return QString : string format.
         */
        QString currentDateTimeStr() const;

        /*!
         * \brief formatStr : Stringify of d_ptr->params.format.
         * \return QString : string format of d_ptr->params.format.
         */
        QString formatStr() const;
        /*!
         * \brief format : getter function of d_ptr->params.format.
         * \return int : format value based on DateTimeFormat enum.
         */
        int format() const;
        /*!
         * \brief setFormat : setter function of d_ptr->params.format.
         * \param fmt : int -> format value based on DateTimeFormat enum.
         */
        void setFormat(int fmt);

        /*!
         * \brief monthFormatStr : Stringify of d_ptr->params.monthFormat.
         * \return QString : string format of d_ptr->params.monthFormat.
         */
        QString monthFormatStr() const;
        /*!
         * \brief monthFormat : getter function of d_ptr->params.monthFormat.
         * \return  int : format value based on MonthFormat enum.
         */
        int monthFormat() const;
        /*!
         * \brief setMonthFormat : setter function of d_ptr->params.monthFormat.
         * \param fmt : int -> format value based on MonthFormat enum.
         */
        void setMonthFormat(int fmt);

    private:
        QScopedPointer<DateTimePrivate> d_ptr;
};

WEACORE_NAMESPACE_END

#endif // DATETIME_H
