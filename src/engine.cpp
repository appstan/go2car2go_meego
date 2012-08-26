#include "engine.h"
#include "json.h"
#include <QNetworkAccessManager>
#include <QNetworkProxyFactory>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QNetworkDiskCache>
#include <QDateTime>
#include <QGeoCoordinate>
#include <math.h>
#include "koauth/kqoauthrequest.h"
#include "koauth/kqoauthmanager.h"


using namespace QtJson;


const QByteArray GO2CAR2GO_ConsumerKey    = "YOUR_CONSUMER_KEY";
const QByteArray GO2CAR2GO_ConsumerSecret = "YOUR_CONSUMER_SECRET";

const QByteArray GO2CAR2GO_HOST = "http://www.car2go.com/api/v2.1/";
const QByteArray GO2CAR2GO_SECURED_HOST = "https://www.car2go.com/api";

const QByteArray CAR2GO_REQUEST_TOKEN_URL = "https://www.car2go.com/api/reqtoken";
const QByteArray CAR2GO_ACCESS_TOKEN_URL  = "https://www.car2go.com/api/accesstoken";
const QByteArray CAR2GO_AUTHORIZE_TOKEN_URL = "https://www.car2go.com/api/authorize";
const QString CAR2GO_REQUEST_CALLBACK_URL = "foo";

Go2Car2GoEngine::Go2Car2GoEngine():
    m_authStep(-1)
{
    //OAuth specific stuff
    oauthRequest = new KQOAuthRequest;
    oauthManager = new KQOAuthManager(this);

    net_manager = new QNetworkAccessManager ( this );
    connect ( net_manager, SIGNAL ( finished ( QNetworkReply* ) ),
              this, SLOT ( replyFinished ( QNetworkReply* ) ) );

}

Go2Car2GoEngine::~Go2Car2GoEngine()
{
    delete oauthRequest;
    delete oauthManager;

    delete net_manager;
}

void Go2Car2GoEngine::readErrorElement( )
{
}

void Go2Car2GoEngine::readError()
{
}


int Go2Car2GoEngine::get ( const Car2goMethod &method )
{
    request ( method, true );
}

int Go2Car2GoEngine::post ( const Car2goMethod &method )
{
    request ( method, false );
}

int Go2Car2GoEngine::request ( const Car2goMethod &method, bool get )
{
    QMap<QString,QString> map = method.args;

    QMapIterator<QString, QString> i ( map );
    QStringList keyList;
    while ( i.hasNext() )
    {
        i.next();
        keyList << i.key();
    }
    qSort ( keyList.begin(), keyList.end() );

    QUrl url ( GO2CAR2GO_HOST + method.method, QUrl::TolerantMode );
    for ( int i = 0; i < keyList.size(); ++i )
    {
        url.addQueryItem ( keyList.at ( i ),  map.value ( keyList.at ( i ) ) );
    }


    requestCounter++;
    RequestData requestData;
    requestData.requestId = requestCounter;

    QNetworkReply *reply;

    if ( get )
        reply = net_manager->get ( QNetworkRequest ( url ) );
    else
        reply = net_manager->post ( QNetworkRequest ( QUrl(GO2CAR2GO_SECURED_HOST) ), url.encodedQuery () );

    requestDataMap.insert ( reply , requestData );
    qDebug() << "request id: " << url;

    return requestData.requestId;
}

void Go2Car2GoEngine::replyFinished ( QNetworkReply *reply )
{
    QByteArray data = reply->readAll();


    qDebug()<<"*******************************RESPONSE*******************************";
    qDebug() << QString::fromUtf8(data);
    qDebug()<<"**********************************************************************\n\n";

    response.list.clear();
    error.code = 0;
    error.message = "No Errors";

    if ( reply->error() != QNetworkReply::NoError )
    {
        error.code = 1001;
        error.message = reply->errorString ();
    }



    void* userData = requestDataMap.value ( reply ).userData;
    int replyId    = requestDataMap.value ( reply ).requestId;
    bool ok;



    QVariantMap result;

    if (data.isEmpty()){
        error.code = 1001;
        error.message = "Network session error";
    }
    else {
        result = Json::parse(QString::fromUtf8(data), ok).toMap();
        if(!ok) {
            error.code = 3000;
            error.message = QString::fromUtf8(data);
            qDebug() << "An error occurred during parsing";
        }

    }

    emit requestFinished(replyId, result , error );

    requestDataMap.remove ( reply );
    reply->deleteLater();
}

void Go2Car2GoEngine::authenticate()  {


   connect(oauthManager, SIGNAL(temporaryTokenReceived(QString,QString)),
       this, SLOT(onTemporaryTokenReceived(QString, QString)));

   connect(oauthManager, SIGNAL(authorizationReceived(QString,QString)),
       this, SLOT( onAuthorizationReceived(QString, QString)));

   connect(oauthManager, SIGNAL(accessTokenReceived(QString,QString)),
      this, SLOT(onAccessTokenReceived(QString,QString)));

//   connect(oauthManager, SIGNAL(requestReady(QByteArray)),
//      this, SLOT(onRequestReady(QByteArray)));
   m_authStep = 0;
   oauthRequest->initRequest(KQOAuthRequest::TemporaryCredentials,QUrl(CAR2GO_REQUEST_TOKEN_URL));
   oauthRequest->setConsumerKey(GO2CAR2GO_ConsumerKey);
   oauthRequest->setConsumerSecretKey(GO2CAR2GO_ConsumerSecret);
   oauthRequest->setCallbackUrl(CAR2GO_REQUEST_CALLBACK_URL);
   oauthManager->setHandleUserAuthorization(false);
   oauthManager->executeRequest(oauthRequest);
}

void Go2Car2GoEngine::onTemporaryTokenReceived(QString token, QString tokenSecret)
{
    qDebug() << "Temporary token received: " << token << tokenSecret;

    QUrl userAuthURL(CAR2GO_AUTHORIZE_TOKEN_URL);
    userAuthURL.addQueryItem( QString("oauth_token"), token);

    if( oauthManager->lastError() == KQOAuthManager::NoError) {
        qDebug() << "Asking for user's permission to access protected resources. Opening URL: " << userAuthURL;
        //oauthManager->getUserAuthorization(userAuthURL);
        //send this url to qml
        emit openAuthenticationUrl(userAuthURL);

    }

}

void Go2Car2GoEngine::onAuthorizationReceived(QString token, QString verifier) {
    qDebug() << "User authorization received: " << token << verifier;

    oauthManager->getUserAccessTokens(QUrl(CAR2GO_AUTHORIZE_TOKEN_URL));
    if( oauthManager->lastError() != KQOAuthManager::NoError) {
        qDebug() << "no issue seen durign authorization" ;
    }
}

void Go2Car2GoEngine::onAccessTokenReceived(QString token, QString tokenSecret) {
    qDebug() << "Access token received: " << token << tokenSecret;

    oauthSettings.setValue("oauth_token", token);
    oauthSettings.setValue("oauth_token_secret", tokenSecret);

    qDebug() << "Access tokens now stored.";
}

void Go2Car2GoEngine::onAuthorizedRequestDone() {
    qDebug() << "Authorization done";
}

void Go2Car2GoEngine::onRequestReady(QByteArray response) {
    switch(m_authStep){
    case 0:
    {
        if ( response.isEmpty()){
            qWarning() << "Empty response";
            return;
        }
    }
    break;
    case 1:
    {}
    break;
    default:
         qWarning() << "Unknown auth step" << m_authStep;
         break;
    }
    qDebug() << "Response from the service: " << response;
}
