#include "../include/InjectionMolding/plcmodbusdevice.h"
#include "../include/InjectionMolding/plciomodel.h"

#include <QDebug>

PlcModbusDevice::PlcModbusDevice(QObject* parent)
    : AbstractModbusDevice{parent}
{

    /** Defining IOs from model **/
    const auto& plcIOModel = PlcIOModel::getInstance();

    /** Connections **/
    connect(&plcIOModel, &PlcIOModel::countChanged, this, [ & ]()
    {
        updateIOs(plcIOModel.inputsCount(), plcIOModel.outputsCount());
    });

    connect(&plcIOModel, &PlcIOModel::outputCoilChanged, this, [ = ](int index, bool active)
    {
        if (active)
        {
            coilSet(index);
        }
        else
        {
            coilRst(index);
        }
    });

    updateIOs(plcIOModel.inputsCount(), plcIOModel.outputsCount());
    syncCoils();
}

void PlcModbusDevice::writeValuToProperty(int address, quint16 value)
{
    // Inputs
    if (isInputs(address))
    {
        PlcIOModel::getInstance().setInputCoil(address - PLC_X_START, static_cast<bool>(value));
    }
    else if (isOutputs(address))
    {
        PlcIOModel::getInstance().setOutputCoil(address - PLC_Y_START, static_cast<bool>(value));
    }
    else
    {
        qCritical() << "Invalid Address response! " << address << " Value: " << value;
    }
}

void PlcModbusDevice::syncCoils()
{

    // Wrte buffer should be update with output coils / depend on NC/NO type
    const auto& plcOutputs = PlcIOModel::getInstance().outputs();
    for (int i(0); i < m_numOutputs; ++i)
    {
        if (plcOutputs[i]->active())
        {
            coilSet(i);
        }
        else
        {
            coilRst(i);
        }
    }
}

bool PlcModbusDevice::coilSet(int index)
{
    if (!isValid(index))
    {
        qCritical() << "index is Invalid!" << index << m_numInputs;
        return false;
    }

    const QVector<quint16> values(1, true);
    return pushToWriteBuffer(PLC_Y_START + index,  values, QModbusDataUnit::Coils);
}

bool PlcModbusDevice::coilRst(int index)
{
    if (!isValid(index))
    {
        qCritical() << "index is Invalid!" << index << m_numInputs;
        return false;
    }

    const QVector<quint16> values(1, false);
    return pushToWriteBuffer(QModbusDataUnit(QModbusDataUnit::Coils, PLC_Y_START + index,  values));
}

bool PlcModbusDevice::isValid(int index) const
{
    return index >= 0 && index < m_numOutputs;
}

bool PlcModbusDevice::isInputs(int address) const
{
    return address >= PLC_X_START && address <= PLC_X_END;
}

bool PlcModbusDevice::isOutputs(int address) const
{
    return address >= PLC_Y_START && address <= PLC_Y_END;
}

void PlcModbusDevice::updateIOs(int inputNum, int outputNum)
{
    m_numInputs = inputNum;
    m_numOutputs = outputNum;

    /** Buffers **/
    m_readBuffer =
    {
        // Inputs
        QModbusDataUnit(QModbusDataUnit::DiscreteInputs, PLC_X_START, m_numInputs),

        // Outputs
        QModbusDataUnit(QModbusDataUnit::Coils, PLC_Y_START, m_numOutputs)
    };
}
