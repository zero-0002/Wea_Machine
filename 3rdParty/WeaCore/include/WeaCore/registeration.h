#ifndef REGISTERATION_H
#define REGISTERATION_H

#include <QMetaType>
#include <QtQml/qqml.h>

/*!
 * \brief QTQ_REGISTER_META_TYPE: easy qRegisterMetaType<type>(#type)
 * \param type: registerable type.
 */
#define QTQ_REGISTER_META_TYPE(type) \
    qRegisterMetaType<type>(#type)

/*!
 * \brief QTQML_REGISTER_TYPE: easy qmlRegisterType<module>(uri, 1, 0, #module)
 * \param uri: The import Uri as string.
 * \param module: the specify module class.
 */
#define QTQML_REGISTER_TYPE(uri, module) \
    qmlRegisterType<module>(uri, 1, 0, #module)

/*!
 * \brief QTQML_REGISTER_TYPE_VERSION: easy qmlRegisterType<module>(uri, versionMajor, versionMinor, #module)
 * \param uri: The import Uri as string.
 * \param versionMajor: int.
 * \param versionMinor: int.
 * \param module: the specify module class.
 */
#define QTQML_REGISTER_TYPE_VERSION(uri, versionMajor, versionMinor, module) \
    qmlRegisterType<module>(uri, versionMajor, versionMinor, #module)

/*!
 * \brief QTQML_REGISTER_UNCREATABLE_TYPE: easy qmlRegisterUncreatableType<type>(uri, 1, 0, #type, "Enum Register Reason")
 * \param uri: The import Uri as string.
 * \param type: the specify module class (Enum type).
 */
#define QTQML_REGISTER_UNCREATABLE_TYPE(uri, type) \
    qmlRegisterUncreatableType<type>(uri, 1, 0, #type, "Enum Register Reason")

/*!
 * \brief QTQML_REGISTER_UNCREATABLE_TYPE_NAMED: easy qmlRegisterType<module>(uri, 1, 0, qmlName, "Enum Register Reason")
 * \param uri: The import Uri as string.
 * \param qmlName: string.
 * \param type: the specify module class (Enum type).
 */
#define QTQML_REGISTER_UNCREATABLE_TYPE_NAMED(uri, type, qmlName) \
    qmlRegisterUncreatableType<type>(uri, 1, 0, qmlName, "Enum Register Reason")

/*!
 * \brief QTQML_REGISTER_UNCREATABLE_TYPE_VERSION: easy qmlRegisterType<module>(uri, versionMajor, versionMinor, qmlName, "Enum Register Reason")
 * \param uri: The import Uri as string.
 * \param versionMajor: int.
 * \param versionMinor: int.
 * \param qmlName: string.
 * \param type: the specify module class (Enum type).
 */
#define QTQML_REGISTER_UNCREATABLE_TYPE_VERSION(uri, type, versionMajor, versionMinor, qmlName) \
    qmlRegisterUncreatableType<type>(uri, versionMajor, versionMinor, qmlName, "Enum Register Reason")


#endif // REGISTERATION_H
