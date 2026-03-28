#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>
#include <QLoggingCategory>
#include <qloggingcategory.h>
#include <QThread>

#include "models/examples/SortFilterProxy.h"
#include "models/examples/Target.h"
#include "models/examples/TargetModel.h"

//#define USE_NETWORK_SOURCE
#define AUTO_REFRESH_UI

#ifdef USE_NETWORK_SOURCE
    #include <WeaNet/Manager.h>
#else
    #include "common/worker.h"
#endif


int main(int argc, char *argv[])
{
    #if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
        QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    #endif


    QGuiApplication app(argc, argv);

    qputenv("QT_ASSUME_STDERR_HAS_CONSOLE", "1");

    TargetModel targetModel;
    qDebug() << "Target roleNames" << targetModel.roleNames();
//    qDebug() << "Header Data" << targetModel.headerData(0, Qt::Horizontal);
    qDebug() << "HEADERS DATA: " << targetModel.headersData();
    // Custom Filtering class
    SortFilterProxyModel filter;
    filter.setSourceModel(&targetModel);
    filter.setFilterCaseSensitivity(Qt::CaseInsensitive);

#ifdef USE_NETWORK_SOURCE
    Target tar;
    targetModel.insertItem(&tar, 0);

    QThread threadRecv;
    Manager receiver;
    receiver.moveToThread(&threadRecv);

    receiver.setConnectionType(SocketType::Server); // Udp (0= TcpClient, 1 = TcpServer)
    receiver.setConnectionSetting(54321, 54321, "172.16.50.50"); // Change it to your Address & port
    receiver.onConnect();

    QObject::connect(&receiver, &Manager::destroyed, &threadRecv, [&] () { threadRecv.quit(); threadRecv.wait(); });
    QObject::connect(&receiver, &Manager::readyReads, &receiver, [&] (QSharedPointer<QList<QSharedPointer<LogDataType>>> logDatas,
                                                                   qreal az, qreal time) {
            qDebug() << "logDataSize is: " << logDatas->size() << az << time;
            Target *target = targetModel.returnItemObject(tar.id());
            target->setAzimuth(logDatas->constLast()->azimuth());
            target->setElevation(logDatas->constLast()->elevation());
            target->setRangeCell(logDatas->constLast()->range());
            target->setPower(logDatas->constLast()->power());
        }, Qt::DirectConnection);

    threadRecv.start();

#else
    QThread workerThread;
    Worker worker(&targetModel);
    worker.moveToThread(&workerThread);

    for (int i = 0; i < 10000; i++) {
        Target *tar = new Target();
        QString name = QString("Target i" + QString::number(i));
        tar->setName(name);
        targetModel.insertItem(tar, i);
    }

    QObject::connect(&workerThread, &QThread::started, &worker, &Worker::timelaps);
    QObject::connect(&worker, &Worker::destroyed, &workerThread, [&] () { worker.quit(); workerThread.quit(); workerThread.wait(); });

#ifdef AUTO_REFRESH_UI
    // Modify REFRESH_INTERVAL for update cycle (units ms)
    targetModel.refreshInterval = 100; // ms (By Default is 100ms)

//    targetModel.setAutoRefresh(true, false); // Update all
    targetModel.setAutoRefresh(true); // Update only changed items
#else
    QObject::connect(&worker, &Worker::signalUpdate, &targetModel, &TargetModel::updateChangedItems);
//    QObject::connect(&worker, &Worker::signalUpdate, &targetModel, &TargetModel::updateAll);
#endif
    workerThread.start();
#endif


    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.rootContext()->setContextProperty("tableModel", &targetModel);
    engine.rootContext()->setContextProperty("proxyModel", &filter); // If you want to use filtering else uncommnet above line
    engine.load(url);
    return app.exec();

}
