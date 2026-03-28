#ifndef WORKER_H
#define WORKER_H

#include <QObject>
#include "models/examples/TargetModel.h"

class Worker : public QObject
{
    Q_OBJECT
public:
    explicit Worker(TargetModel * targets, QObject *parent = nullptr);

    void timelaps();

    void quit();

    TargetModel *targets;

//    QThread *thread;

    TargetModel *model;
    bool loop = true;

signals:
    void signalUpdate();

private:
    bool m_quit = false;

};

#endif // WORKER_H
