import QtQuick 2.12
import CustomItems 1.0

QtObject {
    id: root

    /** Properties **/
    property bool optimizeMode: false
    property AxisConfig xAxisConfig: AxisConfig {
        objectName: "X_AXIS_CONFIG" // REQUIRED for AppSettings
    }
    property AxisConfig yAxisConfig: AxisConfig {
        objectName: "Y_AXIS_CONFIG" // REQUIRED for AppSettings
    }
}
