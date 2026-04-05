#ifndef SERIALCONNECTION_H
#define SERIALCONNECTION_H

#include <QSerialPort>
#include <WeaCore/utils.h>

class SerialConnection : public QObject
{
        Q_OBJECT
        W_PROP_HDEF(QString, portName, PortName, "");
        W_PROP_HDEF(int, baudRate, BaudRate, QSerialPort::Baud115200);
        W_PROP_HDEF(int, stopBits, StopBits, QSerialPort::OneStop);
        W_PROP_HDEF(int, parity, Parity, QSerialPort::OddParity);
        W_PROP_HDEF(int, dataBits, DataBits, QSerialPort::Data8);
        W_PROP_HDEF(bool, connected, Connected, false);
    public:
        explicit SerialConnection(QObject* parent = nullptr)
            : QObject{parent}
        {

        }

};

#endif // SERIALCONNECTION_H
