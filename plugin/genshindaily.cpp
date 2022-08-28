#include "genshindaily.h"


QMap<GenshinDaily::Server,QString> GenshinDaily::serverMap {
	{CN,"cn_gf01"},
	{BL,"cn_qd01"},
	{Asia,"os_asia"},
	{NA,"os_usa"},
	{EU,"os_euro"},
	{SAR,"os_cht"}
};

GenshinDaily::GenshinDaily(QObject *parent) : GenshinDaily("","", CN, parent) {
	qDebug() << "Empty constructor called";
}

GenshinDaily::GenshinDaily(QString uid, QString cookie, Server server, QObject *parent)
	: QObject(parent), m_uid(uid), m_cookie(cookie), m_server(server){
		this->m_updateTime = QDateTime::currentDateTime().toTime_t();
}

GenshinDaily::~GenshinDaily() {};

GenshinDaily::GenshinDaily(const GenshinDaily& other)
	: GenshinDaily(other.m_uid, other.m_cookie, other.m_server, other.parent()){
		qDebug() << "Copy constructor called";
}

// void GenshinDaily::setCookie(QString newCookie) {

// 	this->m_cookie = newCookie;
// 	emit cookieChanged(newCookie);
// 	if (this->m_uid != "" && this->m_cookie != "" && this->m_server != UNSET) {
// 		this->refresh();
// 	}
// }

void GenshinDaily::refresh() {
	qDebug() << "Refreshin……";
	qDebug() << "UID: " << this->m_uid;
	qDebug() << "Cookie: " << this->m_cookie;
	qDebug() << "Server: " << serverMap[this->m_server];

	QNetworkAccessManager* manager = new QNetworkAccessManager();
	connect(manager,&QNetworkAccessManager::finished,[=](QNetworkReply *reply) {
            if (reply->error()) {
                qDebug() << reply->errorString();
                return;
            }
            QByteArray bytes = reply->readAll();
			// qDebug() << bytes;
            parseResponseJSON(bytes);
        });
	QNetworkRequest* request = new QNetworkRequest();
	if (this->m_proxy_enable == MANUAL) {
		qDebug() << "Manual Proxy";
		QNetworkProxy* proxy = new QNetworkProxy();
		switch(this->m_proxy_type){
			case HTTP:
				proxy->setType(QNetworkProxy::HttpProxy);
				break;
			case SOCKS5:
				proxy->setType(QNetworkProxy::Socks5Proxy);
		}
		proxy->setHostName(this->m_proxy_host);
		proxy->setPort(this->m_proxy_port);
		qDebug() << proxy->type();
		qDebug() << proxy->hostName();
		qDebug() << proxy->port();
		manager->setProxy(*proxy);
	}
	request->setUrl(QUrl((isCNServer() ? apiCN : apiGlobal) + "?" + getQuery()));
	request->setRawHeader("x-rpc-app_version",  isCNServer() ? "2.26.1" : "2.9.1");
	request->setRawHeader("x-rpc-client_type", isCNServer() ? "5" : "2");
	request->setRawHeader("DS",getDS().toUtf8());
	request->setRawHeader("Cookie",this->m_cookie.toUtf8());

	manager->get(*request);
}

QString GenshinDaily::getDS() {
	QString q = getQuery();
	QString n = isCNServer() ? "xV8v4Qu54lUKrEYFZkJhB8cuOh9Asafs" : "okr4obncj8bw5a65hbnn5oo6ixjc3l9w";
	QString t = QString::number(QDateTime::currentDateTime().toTime_t());
	QString r = QString::number(floor(QRandomGenerator::global()->generateDouble() * 900000 + 100000));
	QString ds = QString(QCryptographicHash::hash((QString("salt=%1&t=%2&r=%3&b=&q=%4").arg(n).arg(t).arg(r).arg(q).toUtf8()),QCryptographicHash::Md5).toHex());
	return QString("%1,%2,%3").arg(t).arg(r).arg(ds);
}

void GenshinDaily::parseResponseJSON(QByteArray& response) {
	QJsonParseError jsonError;
	QJsonDocument doc = QJsonDocument::fromJson(response,&jsonError);
	    if (jsonError.error != QJsonParseError::NoError) {
        qDebug() << " parse json error";
        return;
    }
	if (!doc.isObject()) {
		qDebug() << "Could not parse response: expected object as root JSON object";
		return;
	}
	QJsonObject data = doc.object()["data"].toObject();
	this->m_currentResin =  data["current_resin"].toInt();
	emit this->currentResinChanged(this->m_currentResin);
	this->m_resinRecoveryTime = data["resin_recovery_time"].toString().toInt();
	emit this->resinRecoveryTimeChanged(this->m_resinRecoveryTime);
	this->m_currentHomeCoin = data["current_home_coin"].toInt();
	emit this->currentHomeCoinChanged(this->m_currentHomeCoin);
	this->m_maxHomeCoin = data["max_home_coin"].toInt();
	emit this->maxHomeCoinChanged(this->m_maxHomeCoin);
	this->m_homeCoinRecoveryTime = data["home_coin_recovery_time"].toString().toInt();
	emit this->homeCoinRecoveryTimeChanged(this->m_homeCoinRecoveryTime);
	this->m_finishedTaskNum = data["finished_task_num"].toInt();
	emit this->finishedTaskNumChanged(this->m_finishedTaskNum);
	this->m_isExtraTaskRewardReceived = data["is_extra_task_reward_received"].toBool();
	emit this->isExtraTaskRewardReceivedChanged(this->m_isExtraTaskRewardReceived);
	this->m_remainResinDiscountNum = data["remain_resin_discount_num"].toInt();
	emit this->remainResinDiscountNumChanged(this->m_remainResinDiscountNum);
	this->m_currentExpeditionNum = data["current_expedition_num"].toInt();
	emit this->currentExpeditionNumChanged(this->m_currentExpeditionNum);
	this->m_maxExpeditionNum = data["max_expedition_num"].toInt();
	emit this->maxExpeditionNumChanged(this->m_maxExpeditionNum);
	this->m_expeditions = data["expeditions"].toArray().toVariantList();
	emit this->expeditionsChanged(this->m_expeditions);

	this->m_transformerObtained = data["transformer"].toObject()["obtained"].toBool();
	emit this->transformerObtainedChanged(this->m_transformerObtained);

	if(this->m_transformerObtained){
		QJsonObject transformerRecoveryTimeOBJ = data["transformer"].toObject()["recovery_time"].toObject();
		if(transformerRecoveryTimeOBJ["reached"].toBool()){
			this->m_transformerRecoveryTime = 0;
		} else {
			this->m_transformerRecoveryTime = transformerRecoveryTimeOBJ["Day"].toInt() * 24 * 60 * 60 + transformerRecoveryTimeOBJ["Hour"].toInt() * 60 * 60 + transformerRecoveryTimeOBJ["Minute"].toInt() * 60 + transformerRecoveryTimeOBJ["Second"].toInt();
		}
		emit this->transformerRecoveryTimeChanged(this->m_transformerRecoveryTime);
	}
	
	this->m_updateTime = QDateTime::currentDateTime().toTime_t();
	emit this->updateTimeChanged(this->m_updateTime);

}
