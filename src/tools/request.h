
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
				emit onsuccess(QString::fromUtf8(reply->readAll()));
			}
			else {
				emit onerror(reply->errorString());
			}
		});
	}
	Q_INVOKABLE void send(const QString &url, const QJsonObject &headers = {}, const QString &data = "") {
		auto request = QNetworkRequest(QUrl(url));
		if (!headers.isEmpty()) {
			foreach(const QString &key, headers.keys()) {
				QString value = headers.value(key).toString();
				request.setRawHeader(key.toUtf8(), value.toUtf8());
			}
		}
		if (!data.isEmpty()) {
			m_manager.post(request, data.toUtf8());
		}
		else {
			m_manager.get(request);
		}
	}
	Q_SIGNAL void onsuccess(const QString &reply);
	Q_SIGNAL void onerror(const QString &reply);

};
