
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>

#include "tools/process.h"
#include "tools/request.h"


int main(int argc, char *argv[]) {
  QApplication app(argc, argv);
  app.setApplicationName("QuickTube");
  app.setOrganizationName("sebaro");
  app.setOrganizationDomain("sebaro.pro");
  qmlRegisterType<Process>("Process", 1, 0, "Process");
  qmlRegisterType<Request>("Request", 1, 0, "Request");
  QQmlApplicationEngine engine;
  engine.load("qrc:/widgets/Window.qml");
  QObject *topLevel = engine.rootObjects().value(0);
  QQuickWindow *window = qobject_cast<QQuickWindow *>(topLevel);
  window->show();
  return app.exec();
}
