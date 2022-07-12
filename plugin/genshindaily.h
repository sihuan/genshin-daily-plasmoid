#ifndef GENSHINDAILY_H
#define GENSHINDAILY_H


#include <QBuffer>
#include <QDataStream>
#include <QDebug>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QMap>
#include <QObject>
#include <QStack>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QRandomGenerator>


const QString apiCN = "https://api-takumi-record.mihoyo.com/game_record/app/genshin/api/dailyNote";
const QString apiGlobal = "https://bbs-api-os.hoyolab.com/game_record/app/genshin/api/dailyNote";

class GenshinDaily : public QObject {
	Q_OBJECT
	Q_ENUMS(Server)
public:
    enum Server {
    	CN,
    	BL,
    	Asia,
    	NA,
    	EU,
    	SAR,
    	UNSET
    };
	GenshinDaily(QObject *parent = nullptr);
	GenshinDaily(QString uid, QString cookie, Server server, QObject *parent = nullptr);
    ~GenshinDaily() override;
    GenshinDaily(const GenshinDaily& other);
	
	Q_PROPERTY(QString uid MEMBER m_uid NOTIFY uidChanged)
	Q_PROPERTY(QString cookie MEMBER m_cookie NOTIFY cookieChanged)
	Q_PROPERTY(Server server MEMBER m_server NOTIFY serverChanged)

	Q_PROPERTY(int currentResin READ currentResin NOTIFY currentResinChanged STORED false)
	Q_PROPERTY(int resinRecoveryTime READ resinRecoveryTime NOTIFY resinRecoveryTimeChanged STORED false)
	Q_PROPERTY(int currentHomeCoin READ currentHomeCoin NOTIFY currentHomeCoinChanged STORED false)
	Q_PROPERTY(int maxHomeCoin READ maxHomeCoin NOTIFY maxHomeCoinChanged STORED false)
	Q_PROPERTY(int homeCoinRecoveryTime READ homeCoinRecoveryTime NOTIFY homeCoinRecoveryTimeChanged STORED false)
	Q_PROPERTY(int finishedTaskNum READ finishedTaskNum NOTIFY finishedTaskNumChanged STORED false)
	Q_PROPERTY(bool isExtraTaskRewardReceived READ isExtraTaskRewardReceived NOTIFY isExtraTaskRewardReceivedChanged STORED false)
	Q_PROPERTY(int remainResinDiscountNum READ remainResinDiscountNum NOTIFY remainResinDiscountNumChanged STORED false)
	Q_PROPERTY(bool transformerObtained READ transformerObtained NOTIFY transformerObtainedChanged STORED false)
    Q_PROPERTY(int transformerRecoveryTime READ transformerRecoveryTime NOTIFY transformerRecoveryTimeChanged STORED false)

	int currentResin() const { return this->m_currentResin; }
	int resinRecoveryTime() const { return this->m_resinRecoveryTime; }
	int currentHomeCoin() const { return this->m_currentHomeCoin; }
    int maxHomeCoin() const { return this->m_maxHomeCoin; }
    int homeCoinRecoveryTime() const { return this->m_homeCoinRecoveryTime; }
    int finishedTaskNum() const { return this->m_finishedTaskNum; }
    bool isExtraTaskRewardReceived() const { return this->m_isExtraTaskRewardReceived; }
    int remainResinDiscountNum() const { return this->m_remainResinDiscountNum; }
    bool transformerObtained() const { return this->m_transformerObtained; }
    int transformerRecoveryTime() const { return this->m_transformerRecoveryTime; }


signals:
	void uidChanged();
	void cookieChanged(QString newCookie);
	void serverChanged(Server newServer);

	void currentResinChanged(int newCurrentResin);
	void resinRecoveryTimeChanged(int newResinRecoveryTime);
    void currentHomeCoinChanged(int newCurrentHomeCoin);
    void maxHomeCoinChanged(int newMaxHomeCoin);
    void homeCoinRecoveryTimeChanged(int newHomeCoinRecoveryTime);
    void finishedTaskNumChanged(int newFinishedTaskNum);
    void isExtraTaskRewardReceivedChanged(bool newIsExtraTaskRewardReceived);
    void remainResinDiscountNumChanged(int newRemainResinDiscountNum);
    void transformerObtainedChanged(bool newTransformerObtained);
    void transformerRecoveryTimeChanged(int newTransformerRecoveryTime);


public slots:
	void refresh();
	

private:
    static QMap<Server,QString> serverMap;

	QString m_uid;
	QString m_cookie;
	Server m_server;

	int m_currentResin;
	int m_resinRecoveryTime;
    int m_currentHomeCoin;
    int m_maxHomeCoin;
    int m_homeCoinRecoveryTime;
    int m_finishedTaskNum;
    bool m_isExtraTaskRewardReceived;
    int m_remainResinDiscountNum;
    bool m_transformerObtained;
    int m_transformerRecoveryTime;

	QString getDS();
	void parseResponseJSON(QByteArray &response);

	bool isCNServer(){ return this->m_server == CN || this->m_server == BL; };
	QString getQuery(){ return QString("role_id=%1&server=%2").arg(this->m_uid).arg(serverMap[this->m_server]);};
};

#endif
