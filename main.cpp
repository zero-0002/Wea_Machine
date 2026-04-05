#include <QGuiApplication>
#include <QSurfaceFormat>
#include <QSettings>
#include <QThread>

#include <WeaQuick/initialize.h>

#include "InjectionMolding/Engine.h"
#include "InjectionMolding/AlarmModel.h"
#include "InjectionMolding/Registerations.h"

const char* DEBUG_MESSAGE_PATTERN = "[%{type}][%{threadid}][%{function}:%{line}] - %{message}";

int main(int argc, char* argv[])
{

    /** OpenGL Properties **/
    QSurfaceFormat fmt;
    // fmt.setVersion(2, 6);
    // fmt.setProfile(QSurfaceFormat::CoreProfile);
    fmt.setDepthBufferSize(24);
    fmt.setStencilBufferSize(8);
    fmt.setSwapInterval(1);
    fmt.setRenderableType(QSurfaceFormat::OpenGL);
    fmt.setSwapBehavior(QSurfaceFormat::DoubleBuffer);
    QSurfaceFormat::setDefaultFormat(fmt);
    QSurfaceFormat curFmt = QSurfaceFormat::defaultFormat();

    // qputenv("QT_ENABLE_HIGHDPI_SCALING", "1");
    // qputenv("QT_FONT_DPI", "96");
    // qputenv("QT_SCALE_FACTOR", "1.25");
    qSetMessagePattern(DEBUG_MESSAGE_PATTERN); // qputenv("QT_MESSAGE_PATTERN", DEBUG_MESSAGE_PATTERN);
    qputenv("QML_DISABLE_DISK_CACHE", "1");
    // qputenv("QT_ASSUME_STDERR_HAS_CONSOLE", "1");
    // qputenv("QSG_INFO", "1");



#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);
    QGuiApplication::setOrganizationName("WeaProject");
    QGuiApplication::setOrganizationDomain("com.wearily");
    QGuiApplication::setApplicationName("InjectionMolding");

    QSettings settings(QSettings::IniFormat, QSettings::UserScope,
                       QGuiApplication::organizationName(), QGuiApplication::applicationName());
    qDebug() << "Settings: " << settings.applicationName()
             << settings.organizationName();

    QList<QString> inputs = {"X0", "X1", "X2"};
    settings.setValue("DEVELOPER", "Wearily");
    qDebug() << "Setting PLC_INPUTS" << settings.value("PLC_INPUTS", QVariant(inputs).toStringList());

    const QString projectSourceDir(PROJECT_SOURCE_DIR);
    const QString mainQmlPath(projectSourceDir + "/main.qml");

    Engine engine;

    // const QUrl url(QStringLiteral("qrc:/main.qml"));
    const QUrl url(QUrl::fromLocalFile(mainQmlPath));

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject * obj, const QUrl & objUrl)
    {
        if (!obj && url == objUrl)
        {
            QCoreApplication::exit(-1);
        }
    },
    Qt::QueuedConnection);

    // 3rdParty initializing
    WeaQuick::initialize(&engine);


    // Engine Property Contexts
    engine.addEngineContextProperty();
    engine.rootContext()->setContextProperty("_alarmModel", &AlarmModel::getInstance());

    engine.load(url);

    return app.exec();
}
