#ifndef TCPCONNECTION_H
#define TCPCONNECTION_H

#include <WeaCore/utils.h>

class TcpConnection : public QObject
{
        Q_OBJECT
        W_PROP_HDEF(QString, host, Host, "192.168.1.1");
        W_PROP_HDEF(int, port, Port, 502);
    public:
        explicit TcpConnection(QObject* parent = nullptr)
            : QObject{parent}
        {

        }

};

#endif // TCPCONNECTION_H
