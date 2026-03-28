#include <QGuiApplication>

#include <WeaQuick/initialize.h>

#include "InjectionMolding/Engine.h"

int main(int argc, char* argv[])
{
    qputenv("QT_ENABLE_HIGHDPI_SCALING", "1");
    // qputenv("QT_SCALE_FACTOR", "1.25");
    qputenv("QT_FONT_DPI", "96");
    // qputenv("QSG_INFO", "1");

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

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

    WeaQuick::initialize(&engine);

    engine.addEngineContextProperty();

    engine.load(url);

    return app.exec();
}
