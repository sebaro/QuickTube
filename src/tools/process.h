
#include <QProcess>
#include <QVariant>


class Process : public QProcess {
  Q_OBJECT

public:
  Process(QObject *parent = 0) : QProcess(parent) { }
  Q_INVOKABLE void start(const QString &program, const QVariantList &arguments) {
    QStringList args;
    for (int i = 0; i < arguments.length(); i++) {
      args << arguments[i].toString();
    }
    QProcess *p = new QProcess;
    //QProcess::start(program, args);
    p->start(program, args);
    p_list.append(p);
  }
  Q_INVOKABLE void stop() {
    for(int i=0; i < p_list.count(); ++i) {
      p_list[i]->close();
    }
  }

protected:
  QList<QProcess*> p_list;

};
