#include <QCoreApplication>
#include <QDebug>

#include "MainClass.h"

/// TODO: Add FileIO class with linux commands (Also should be used in Qml).
/// TODO: Add FileTree class for FileIO which must includes (as Vector, List, Map)
/// TODO: Add Listener for FileIO which listens if any file is created or deleted.
/// TODO: Add FileStreamer class for parsing file contents. (Also == and other operators must be written).
/// TODO: Add Filtererer for FileIO which filters file/dir names (for example find or ls onlye .csv files)

int main(int argc, char** argv)
{
    QCoreApplication app(argc, argv);

    MainClass mainC;
    qDebug() << mainC.prop1();

    return 0;
}
