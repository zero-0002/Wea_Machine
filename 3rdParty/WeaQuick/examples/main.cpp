#include <QGuiApplication>
#include <QSettings>
#include <QDebug>

#include "CustomEngine.h"

#include "WeaQuick/initialize.h"

/// TODO: add Bar and RotaryBar which AnalogIndicator.
/// TODO: add AnalogIndicator which can be "vertical/horizontal filler" or "circular filler" or "color brightness" (also it must have from/to value)
/// TODO: add ComboBox component
/// TODO: add ComboCheckBox component
/// TODO: make CheckBox shaderEffect better, and add Border and marker color
/// TODO: add TickMarks for Slider.
/// TODO: add ShaderEffects such as GradientEffect and ... which can be implement for each QML component as layer.effect.
/// TODO: add two different style SpinBox
/// TODO: add IPEditBox which inherited and has tabularity events
/// TODO: add GeoEditBox which inherited from EditBox and has DMS, DD units type (with tabularity event)
/// TODO: add PhoneEditBox which inherited from EditBox (with tabularity event)
/// TODO: add SecureEditBox which inherited from EditBox and has DMS, DD units type (with tabularity event)
/// TODO: add IconBox which inherited from EditBox with false editable and has animation for valueChanged
/// TODO: add Multi State SpinBox component which the unit can changed by wheel event or tumbler
/// TODO: add AudioButton component
/// TODO: add DelayButton component
/// TODO: add TaskButton component
/// TODO: add PageButton component
/// TODO: add RadioButton component
/// TODO: add Dial component
/// TODO: add RangeSlider component
/// TODO: add DropDown component
/// TODO: add TextEdit component
/// TODO: add Notification component
/// TODO: add Scrollbar/Flickable component
/// TODO: add TabWidget component (also Crud Type)
/// TODO: add Scrollable component (Flickable with StopAtBounds)
/// TODO: add HelpWizard component for application help info
/// TODO: add DragView component which can drag delegate Item by layout or non-layout
/// TODO: add CodeEdit component (line code, scroll, comment shortcut)
/// TODO: find a solution to avoid using wQuick (hit: test .js pragma library assignment)
/// TODO: add Translator referer TaoQuick .
/// TODO: add B Homa font and AutoFontLoader for Theme.
/// TODO: compatible with Qt6
/// TODO: add SideMenu Component with optional overlay effect.

int main(int argc, char* argv[])
{

    qputenv("QT_ENABLE_HIGHDPI_SCALING", "1");
    // qputenv("QT_SCALE_FACTOR", "1.25");
    // qputenv("QT_SCALE_FACTOR", "1.3");
    qputenv("QT_FONT_DPI", "96");
    // qputenv("QSG_INFO", "1");

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);
    QGuiApplication::setOrganizationName("QtWea");
    QGuiApplication::setOrganizationDomain("com.wearily");
    QGuiApplication::setApplicationName("WeaQuick Gallery");
    QSettings settings;
    qDebug() << "Settings: " << settings.applicationName()
             << settings.organizationName();

    QString mainQmlPath = QString("%1/main.qml").arg(PROJECT_SOURCE_DIR);
    CustomEngine engine;
    // const QUrl url(QStringLiteral("qrc:/main.qml"));
    const QUrl url(QUrl::fromLocalFile(mainQmlPath));
    QObject::connect(
        &engine,
        &CustomEngine::objectCreated,
        &app,
        [url](QObject * obj, const QUrl & objUrl)
    {
        if (!obj && url == objUrl)
        {
            QCoreApplication::exit(-1);
        }
    },
    Qt::QueuedConnection);

    WeaQuick::initialize(&engine);

    engine.rootContext()->setContextProperty("_qmlEngine", &engine);
    engine.rootContext()->setContextProperty("_examplesPages", EXAMPLES_PAGES_DIR);


    qDebug() << engine.importPathList();
    engine.load(url);

    return app.exec();
}
