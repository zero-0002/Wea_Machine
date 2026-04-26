#include "../include/InjectionMolding/stepitem.h"

#include <QDebug>
#include <QMetaObject>
#include <QMetaProperty>
#include <QJsonArray>

StepItem::StepItem(QObject* parent)
    : QObject{parent}
{}

StepItem::StepItem(const StepItem& other)
{
    if (this == &other)
    {
        return;
    }
    doCopy(other);
}

StepItem& StepItem::operator=(const StepItem& other)
{
    if (this == &other)
    {
        return *this;
    }
    doCopy(other);

    return *this;
}

QJsonObject StepItem::toJson() const
{
    QJsonObject jsonObj;
    const QMetaObject* metaObject = this->metaObject();
    for (int i = 0; i < metaObject->propertyCount(); ++i)
    {
        QMetaProperty metaProp = metaObject->property(i);
        // فقط property هایی که Q_PROPERTY هستند و قابل خواندن هستند را در نظر می گیریم
        if (metaProp.isReadable())
        {
            QString propName = metaProp.name();
            QVariant propValue = property(propName.toLatin1()); // خواندن مقدار property

            // تبدیل QVariant به QJsonValue
            // باید انواع داده خاص را هندل کنید، QVariant می تواند انواع مختلفی داشته باشد
            // برای QVariantList نیاز به تبدیل به QJsonArray داریم
            if (propValue.type() == QVariant::List)
            {
                QJsonArray jsonArray;
                QVariantList list = propValue.toList();
                for (const QVariant& item : list)
                {
                    // اگر آیتم های لیست خودشان QObject باشند، ممکن است بخواهید آنها را هم به JSON تبدیل کنید
                    // در این مثال فرض می کنیم آیتم های ساده هستند
                    if (item.canConvert<QString>())
                    {
                        jsonArray.append(item.toString());
                    }
                    else if (item.canConvert<int>())
                    {
                        jsonArray.append(item.toInt());
                    }
                    else if (item.canConvert<bool>())
                    {
                        jsonArray.append(item.toBool());
                    }
                    else if (item.canConvert<double>())
                    {
                        jsonArray.append(item.toDouble());
                    }
                    else
                    {
                        // برای انواع دیگر یا QObject های تو در تو، منطق بیشتری لازم است
                        // در اینجا فعلا به صورت رشته تبدیل می کنیم یا نادیده می گیریم
                        // jsonArray.append(item.toString()); // یا می توانید از QJsonValue(item) استفاده کنید اگر QVariant پشتیبانی شود
                        qWarning() << "Unsupported type in QVariantList for property:" << propName << "Type:" << item.typeName();
                    }
                }
                jsonObj[propName] = jsonArray;
            }
            else if (propValue.canConvert<QString>())
            {
                jsonObj[propName] = propValue.toString();
            }
            else if (propValue.canConvert<int>())
            {
                jsonObj[propName] = propValue.toInt();
            }
            else if (propValue.canConvert<bool>())
            {
                jsonObj[propName] = propValue.toBool();
            }
            else if (propValue.canConvert<double>())
            {
                jsonObj[propName] = propValue.toDouble();
            }
            else
            {
                // برای انواع دیگر مانند QObject های تو در تو، منطق بیشتری لازم است
                // می توانید از toVariant() استفاده کنید یا انواع خاص را هندل کنید
                // jsonObj[propName] = QJsonValue(propValue); // اگر QJsonValue بتواند QVariant را مستقیماً هندل کند
                qWarning() << "Unsupported type for property:" << propName << "Type:" << propValue.typeName();
            }
        }
    }
    return jsonObj;
}

void StepItem::fromJson(const QJsonObject& jsonObj)
{
    const QMetaObject* metaObject = this->metaObject();
    for (int i = 0; i < metaObject->propertyCount(); ++i)
    {
        QMetaProperty metaProp = metaObject->property(i);
        if (metaProp.isWritable())   // فقط property هایی که قابل نوشتن هستند
        {
            QString propName = metaProp.name();
            if (jsonObj.contains(propName))
            {
                QJsonValue jsonValue = jsonObj.value(propName);
                QVariant propValue;

                // تبدیل QJsonValue به QVariant
                // باید انواع داده خاص را هندل کنید
                if (jsonValue.isString())
                {
                    propValue = jsonValue.toString();
                }
                else if (jsonValue.isDouble())
                {
                    propValue = jsonValue.toDouble();
                }
                else if (jsonValue.isBool())
                {
                    propValue = jsonValue.toBool();
                }
                else if (jsonValue.isObject())
                {
                    // اگر مقدار JSON یک شیء باشد و property مربوطه هم بتواند QJsonObject را بپذیرد
                    // در این مثال، فرض می کنیم property از نوع QJsonObject است یا باید با منطق خاصی تبدیل شود
                    // jsonObj.value(propName).toObject() را مستقیماً set نمی کنیم چون QVariant می تواند انواع مختلفی را نگه دارد
                    // شما باید مطمئن شوید که نوع property شما با نوع داده JSON مطابقت دارد
                    qWarning() << "JSON value is an object, requires specific handling for property:" << propName;
                    // ممکن است نیاز به ساخت یک شیء جدید و فراخوانی fromJson روی آن داشته باشید
                    // propValue = QVariant(jsonValue.toObject()); // اگر QVariant بتواند QJsonObject را نگه دارد
                }
                else if (jsonValue.isArray())
                {
                    QJsonArray jsonArray = jsonValue.toArray();
                    QVariantList list;
                    for (const QJsonValue& item : jsonArray)
                    {
                        // تبدیل آیتم های آرایه به QVariant
                        if (item.isString())
                        {
                            list.append(item.toString());
                        }
                        else if (item.isDouble())
                        {
                            list.append(item.toDouble());
                        }
                        else if (item.isBool())
                        {
                            list.append(item.toBool());
                        }
                        else if (item.isObject())
                        {
                            // اگر آیتم آرایه یک شیء باشد، می توانید یک StepItem جدید بسازید و fromJson را روی آن فراخوانی کنید
                            // و سپس آن را به لیست اضافه کنید (اگر لیست از نوع StepItem* یا مشابه باشد)
                            // در این مثال فرض می کنیم لیست حاوی مقادیر ساده است
                            qWarning() << "Array item is an object, requires specific handling for property:" << propName;
                            // list.append(item.toObject()); // اگر QVariant بتواند QJsonObject را نگه دارد
                        }
                        else
                        {
                            qWarning() << "Unsupported type in JSON array for property:" << propName;
                        }
                    }
                    propValue = list;
                }
                else
                {
                    qWarning() << "Unsupported JSON value type for property:" << propName;
                }

                // تنظیم مقدار property اگر تبدیل موفق بود و نوع property پشتیبانی می شود
                if (!propValue.isNull())
                {
                    // اطمینان حاصل کنید که نوع QVariant با نوع property مطابقت دارد یا قابل تبدیل است
                    // metaProp.type() نوع داده property را برمی گرداند
                    // شما می توانید بررسی کنید و در صورت نیاز تبدیل بیشتری انجام دهید
                    // مثال: اگر propValue از نوع int است ولی property از نوع double انتظار دارد
                    if (propValue.canConvert(metaProp.userType()))
                    {
                        setProperty(propName.toLatin1(), propValue);
                    }
                    else
                    {
                        qWarning() << "Type mismatch for property:" << propName << "Expected:" << QMetaType::typeName(metaProp.userType()) << "Got:" << propValue.typeName();
                    }
                }
            }
        }
    }

    qDebug() << "StepItem: " << name() << xPosActive() << yPosActive() << xServoPos() << yServoPos() << plcOutputTargets() << delay();
}

void StepItem::doCopy(const StepItem& other)
{
    this->m_plcOutputTargets = other.m_plcOutputTargets;
    this->m_conditionBits = other.m_conditionBits;

    this->m_name = other.m_name;
    this->m_stepId = other.m_stepId;

    this->m_xServoPos = other.m_xServoPos;
    this->m_xServoSpeed = other.m_xServoSpeed;
    this->m_xServoAcc = other.m_xServoAcc;
    this->m_xServoDec = other.m_xServoDec;

    this->m_yServoPos = other.m_yServoPos;
    this->m_xServoSpeed = other.m_yServoSpeed;
    this->m_yServoAcc = other.m_yServoAcc;
    this->m_yServoDec = other.m_yServoDec;

    this->m_delay = other.m_delay;
    this->m_bitwiseMethod = other.m_bitwiseMethod;
    this->m_bitwiseEnable = other.m_bitwiseEnable;

    this->m_xPosActive = other.m_xPosActive;
    this->m_xServoOn = other.m_xServoOn;
    this->m_xServoHome = other.m_xServoHome;

    this->m_yPosActive = other.m_yPosActive;
    this->m_yServoOn = other.m_yServoOn;
    this->m_yServoHome = other.m_yServoHome;
}
