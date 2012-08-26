#ifndef ENGINE_H
#define ENGINE_H

#include <QtCore>
#include <QObject>
#include <QXmlStreamReader>

//#ifdef Q_WS_SIMULATOR
#include <QGeoPositionInfo>
#include <QGeoPositionInfoSource>

QTM_USE_NAMESPACE
//#endif

class QNetworkAccessManager;
class QNetworkReply;
class KQOAuthManager;
class KQOAuthRequest;

/**
 * @struct Car2goError
 * car2go errors.
 * More at http://code.google.com/p/car2go/wiki/index_v2_0/
 * error codes:<br>
 * <ul>
 *   <li>0 - Operation successful.</li>
 *   <li>1 - Location invalid.</li>
 *   <li>2 - UserId invalid.</li>
 *   <li>3 - No valid accounts found.</li>
 *   <li>4 - Not all necessary url parameters provided.</li>
 *   <li>5 - A technical error occured.</li>
 *   <li>6 - Invalid url parameter provided.</li>
 *   <li>7 - No valid driver license information could be found.</li>
 *   <li>8 - The account is locked.</li>
 *   <li>9 - The vehicle can not be booked.</li>
 *   <li>10 - Vehicle invalid.</li>
 *   <li>11 - Booking id invalid.</li>
 *   <li>12 - No reserved vehicle found.</li>
 * </ul>
 */
struct Car2goError{
    int code;
    QString message;
};


/**
 * @struct Car2goMethod
 * Use this structure to create method for accessing car2go API<br>
 * Example:
 * @code
 * Car2goMethod method;
 * method.method = "car2go.com/api/v2.0/vehicles";
 * method.args.insert("loc","ulm");
 * method.args.insert("format","json");
 *
 * @endcode
 */
struct Car2goMethod{
    QString method;
    QMap<QString,QString> args;

    /** Default constructor */
    Car2goMethod(){}
    /** Construct and initialize method */
    Car2goMethod(const QString &method):method(method){}
};


/**
 * @struct Car2goRequest
 * Use this structure to provide information for the XML parser, parser will
 * search only those tags that you have been provided. Request is map container,
 * where key is a tag name and value is a comma delimited list of possible attributes.<br>
 * Attributes are optional, provide only empty string for tag only request.
 * Example:
 * @code
 * <Placemark>
 *      <name>Inner City Parkspot 2</name>
 *      <description>Capacity (used/total): 0/3</description>
 *      <styleUrl>#car2go</styleUrl>
 *      <ExtendedData>
 *           <Data name="usedCapacity"><value>0</value></Data>
 *           <Data name="totalCapacity"><value>3</value></Data>
 *      </ExtendedData>
 *      <Point>
 *           <coordinates>9.983611,48.398565,0</coordinates>
 *      </Point>
 * </Placemark>
 * @endcode
 * Let's assume you want to get all car2go parking places
 * car2go server responses  a XML above.
 * The code looks like this:
 * @code
 * Car2goRequest request;
 * request.requests.insert("","");
 *
 *  Car2goMethod method("parkingspots?");
 *  method.args.insert("loc","ulm");
 *  method.args.insert("format","xml");
 * @endcode
 */
struct Car2goRequest{
    QMap<QString,QString> requests;

    /** Default constructor */
    Car2goRequest(){}
    /** Constructs and initialize single request */
    Car2goRequest(const QString &tag, const QString &attrs = QString())
    {
        requests.insert(tag,attrs);
    }
};


struct Car2goResponse{
    QList< QMap<QString,QVariant> > list;
};

class Go2Car2GoEngine : public QObject
{
    Q_OBJECT

public:
     Go2Car2GoEngine();
    ~Go2Car2GoEngine();

    int request ( const Car2goMethod &method, bool get );


    int get ( const Car2goMethod &method);

    int post ( const Car2goMethod &method );

    void authenticate();


Q_SIGNALS:
    /**
     * Emitted after get(), post() and upload() functions
     * @param reqId The request id
     * @param data Response XML/JSON data
     * @param err possible error
     */
    void requestFinished ( int reqId, const QVariantMap response, Car2goError error );
    void openAuthenticationUrl(const QVariant &url);

private slots:
    void replyFinished ( QNetworkReply *reply );

    void onTemporaryTokenReceived(QString temporaryToken, QString temporaryTokenSecret);
    void onAuthorizationReceived(QString token, QString verifier);
    void onAccessTokenReceived(QString token, QString tokenSecret);
    void onAuthorizedRequestDone();
    void onRequestReady(QByteArray);

private:
    struct RequestData
    {
        void* userData;
        QMap<QString,QString> request;
        int requestId;
    };
    QMap<QNetworkReply*,RequestData> requestDataMap;

    void readErrorElement( );
    void readError();
    QMap<QString, QString> readData( const QMap<QString,QString> &request );

    Car2goError error;
    Car2goResponse response;
    int requestCounter;
    int m_authStep;

    QSettings oauthSettings;
    KQOAuthManager *oauthManager;
    KQOAuthRequest *oauthRequest;
    QNetworkAccessManager *net_manager;
};

#endif // ENGINE_H
