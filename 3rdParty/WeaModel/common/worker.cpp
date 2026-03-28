#include "worker.h"
#include <QRandomGenerator>
#include <QThread>

Worker::Worker(TargetModel *targetModel, QObject *parent)
    : targets(targetModel), QObject{parent}
{


}

void Worker::quit() { m_quit = true; }

void Worker::timelaps() {
    // Example of data assigning
    qDebug() << "timelaps thread: " << QThread::currentThreadId() << this->thread();
    while (!m_quit) {
        if (!loop)
            continue;
//        if (targets->isEmpty())
//            return;
        for (int i = 0; i < targets->rowCount(); ++i) {
            if (!targets->validItemId(i)) {
                qDebug() << "Not contains: " << i;
                continue;

            }
            double max = 360.0;
            double maxr = 240.0;

            // Editing target example
            Target* target = targets->returnItemObject(i);
            target->setAzimuth(static_cast<float>(QRandomGenerator::global()->bounded(max)));
            target->setElevation(static_cast<float>(QRandomGenerator::global()->bounded(maxr)));
            target->setRangeCell(static_cast<float>(QRandomGenerator::global()->bounded(maxr)));
            target->setPower(static_cast<float>(QRandomGenerator::global()->bounded(maxr)));
//            qDebug() << target->azimuth() << target->elevation() << target->rangeCell() << target->power();

        }
//        QMetaObject::invokeMethod(targets, [=]() {targets->updateChangedItems();});
        emit signalUpdate();
        QThread::msleep(100);

    }
}
