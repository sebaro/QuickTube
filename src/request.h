
#include <QJsonObject>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QNetworkAccessManager>
#include <QUrl>


class Request : public QObject {
  Q_OBJECT
  QNetworkAccessManager m_manager;

public:
  Request(QObject * parent = 0) : QObject(parent) {
    connect(&m_manager, &QNetworkAccessManager::finished, [this](QNetworkReply *reply) {
      if (reply->error() == QNetworkReply::NoError) {
        emit response(QString::fromUtf8(reply->readAll()));
      }
    });
  }
  Q_INVOKABLE void send(const QString &url, const QJsonObject &headers) {
    auto request = QNetworkRequest(QUrl(url));
    foreach(const QString &key, headers.keys()) {
      QString value = headers.value(key).toString();
      request.setRawHeader(key.toUtf8(), value.toUtf8());
    }
    m_manager.get(request);
  }
  Q_SIGNAL void response(const QString &reply);
};
