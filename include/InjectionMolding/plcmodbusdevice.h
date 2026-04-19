#ifndef PLCMODBUSDEVICE_H
#define PLCMODBUSDEVICE_H

#include "abstractmodbusdevice.h"
#include "Addresses.h"

class PlcModbusDevice : public AbstractModbusDevice
{
        Q_OBJECT

        using TAddr = PLCAddr;
    public:
        explicit PlcModbusDevice(QObject* parent = nullptr);

        void writeValuToProperty(int address, quint16 value) override;

        Q_INVOKABLE void syncCoils();
        Q_INVOKABLE bool coilSet(int index);
        Q_INVOKABLE bool coilRst(int index);

        /*!
         * \brief isValid
         * \param index
         * \return true if index is in range of numOutputs.
         */
        bool isValid(int index) const;

        bool isInputs(int address) const;
        bool isOutputs(int address) const;
    protected:
        void updateIOs(int inputNum, int outputNum);

    private:
        int m_numInputs, m_numOutputs;
};

#endif // PLCMODBUSDEVICE_H
