#ifndef ENGINE_H
#define ENGINE_H

#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>

class Engine : public QQmlApplicationEngine
{
        Q_OBJECT

    public:
        using QQmlApplicationEngine::QQmlApplicationEngine;

        Q_INVOKABLE void clearCache()
        {
            qDebug() << "Clearing component cache...";

            clearComponentCache();

            qDebug() << "Component Cache cleared.";
        }

        void addEngineContextProperty()
        {
            rootContext()->setContextProperty("_engine", this);
        }

};

#endif // ENGINE_H
