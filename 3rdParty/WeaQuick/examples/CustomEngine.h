#ifndef CUSTOMENGINE_H
#define CUSTOMENGINE_H

#include <QQmlApplicationEngine>
#include <QQmlContext>

class CustomEngine : public QQmlApplicationEngine
{
        Q_OBJECT

    public:
        Q_INVOKABLE void clearCache()
        {
            clearComponentCache();
        }

};

#endif // CUSTOMENGINE_H
