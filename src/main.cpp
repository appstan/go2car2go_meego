#include <QtGui/QApplication>
#include "Application.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    Q_INIT_RESOURCE(go2car2go);

    Car2GoApplication application;

    return app.exec();
}
