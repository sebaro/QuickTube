
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>

#include "process.h"


int main(int argc, char *argv[]) {
  QApplication app(argc, argv);
  qmlRegisterType<Process>("Process", 1, 0, "Process");
  QQmlApplicationEngine engine;
  engine.load("src/main.qml");
  QObject *topLevel = engine.rootObjects().value(0);
  QQuickWindow *window = qobject_cast<QQuickWindow *>(topLevel);
  window->show();
  return app.exec();
}
