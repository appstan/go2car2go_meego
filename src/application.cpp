
#include <QtDeclarative/QDeclarativeContext>
#include <QtDeclarative/QDeclarativeEngine>
#include <QtDeclarative/QDeclarativePropertyMap>

#include <QGeoPositionInfo>
#include <QGeoPositionInfoSource>

#include <QSystemInfo>

#include "application.h"
#include "settings.h"
#include "engine.h"
#include "utils.h"
#include "qmlapplicationviewer/qmlapplicationviewer.h"

#include "listmodel.h"
#include "vehicleitem.h"
#include "gasstationitem.h"
#include "parkingitem.h"
#include "locationitem.h"

#include <QSortFilterProxyModel>
#include <QNetworkProxyFactory>

using namespace Utils;

Car2GoApplication::Car2GoApplication(QObject *parent)
    : QObject(parent)
{

#if defined(Q_WS_WIN) || defined(Q_WS_MAC) || defined (Q_WS_SIMULATOR)
    QNetworkProxyFactory::setUseSystemConfiguration(true);
#endif


    m_viewer = new QmlApplicationViewer();
    m_viewer->setOrientation(QmlApplicationViewer::ScreenOrientationLockPortrait);

    initSettings();

    m_engine = new Go2Car2GoEngine();

    m_viewer->rootContext()->setContextProperty("car2goManager", this);

    m_properties = new QDeclarativePropertyMap();
    m_viewer->rootContext()->setContextProperty("Depot", m_properties);


//    m_authentication = new MPAuthentication(this);
//    m_viewer->rootContext()->setContextProperty("MPAuthentication", m_authentication);

    // GPS
    m_gps = QGeoPositionInfoSource::createDefaultSource(this);
    if (m_gps) {
        positionSourceTimeout = new QTimer(this);
        connect(positionSourceTimeout, SIGNAL(timeout()), this, SLOT(positionSourceStop()));
        positionSourceTimeout->start(90000);
        // Emit updates every 30 seconds
        m_gps->setUpdateInterval(30000);

        connect(m_gps, SIGNAL(positionUpdated(const QGeoPositionInfo&)),
                this, SLOT(positionUpdated(const QGeoPositionInfo&)));

        m_gps->startUpdates();
    } else {
        qDebug() << "No GPS available";
        positionUpdated(QGeoPositionInfo(QGeoCoordinate(48.41000, 9.96000), QDateTime::currentDateTime()));
    }

    initVehicles();
    initParkingSpots();
    initGasStations();
    initLocations();

    connect(m_engine,SIGNAL(requestFinished ( int, QVariantMap, Car2goError )),
            this,SLOT(requestFinished ( int, QVariantMap, Car2goError )));

    m_viewer->setSource(QUrl("qrc:/qml/go2car2go/main.qml"));
    m_viewer->showFullScreen();

    getVehicles();
}

Car2GoApplication::~Car2GoApplication()
{
//    delete m_authentication;
    delete m_settings;
    delete m_properties;

    delete m_gps;

    // Vehicles
    delete v_model;

    // Parkings
    delete p_model;

    // Gasoline Stations
    delete g_model;

    delete m_viewer;
}

void Car2GoApplication::getVehicles()
{
    Car2goMethod method;
    method.method = "vehicles?";
    QString city = m_settings->city();
    method.args.insert("loc",city);
    method.args.insert("format","json");
    method.args.insert("oauth_consumer_key", "TemirlanTentimishov");
    m_requestId.insert(m_engine->get( method ), RequestVehicles);

}

void Car2GoApplication::getGasStations()
{
    Car2goMethod method;
    method.method = "gasstations?";
    QString city = m_settings->city();
    method.args.insert("loc",city);
    method.args.insert("format","json");
    method.args.insert("oauth_consumer_key", "TemirlanTentimishov");
    m_requestId.insert(m_engine->get(method), RequestGasStations);

}

void Car2GoApplication::getParkings()
{
    Car2goMethod method;
    method.method = "parkingspots?";
    QString city = m_settings->city();
    method.args.insert("loc",city);
    method.args.insert("format","json");
    method.args.insert("oauth_consumer_key", "TemirlanTentimishov");
    m_requestId.insert(m_engine->get(method), RequestParking);

}

void Car2GoApplication::getLocations()
{
    Car2goMethod method;
    method.method = "locations?";
    method.args.insert("format","json");
    method.args.insert("oauth_consumer_key", "TemirlanTentimishov");
    m_requestId.insert(m_engine->get(method), RequestLocations);

}

void Car2GoApplication::makeBooking(const QString & carVin)
{
    if(Utils::requireLogin()){
        //emit authenticationRequired();
    }
}

void Car2GoApplication::getBooking( const QString &bookingId )
{
    if(Utils::requireLogin()){
        //emit authenticationRequired();
    }
}

void Car2GoApplication::getBookings()
{
    if(Utils::requireLogin()){
//        m_engine->authenticate();
//        connect(m_engine, SIGNAL(openAuthenticationUrl(const QVariant&)), this, SIGNAL(authenticationRequired(const QVariant&)));
        emit authenticationRequired();
        qDebug() << "emit authenticationRequired()";
    }

}

void Car2GoApplication::initVehicles()
{
    v_model = new ListModel(new VehicleItem, this);
    m_viewer->rootContext()->setContextProperty("vehiclesModel", v_model);

    connect(this, SIGNAL(positionChanged(double,double,double,qreal)),
            v_model, SLOT(positionChanged(double,double,double)));

}

void Car2GoApplication::initGasStations()
{
    g_model = new ListModel(new GasstationItem, this);

    m_viewer->rootContext()->setContextProperty("gasstationsModel", g_model);

    connect(this, SIGNAL(positionChanged(double,double,double,qreal)),
            g_model, SLOT(positionChanged(double,double,double)));

}

void Car2GoApplication::initParkingSpots()
{
    p_model = new ListModel(new ParkingItem, this);

    m_viewer->rootContext()->setContextProperty("parkingsModel", p_model);

    connect(this, SIGNAL(positionChanged(double,double,double,qreal)),
            p_model, SLOT(positionChanged(double,double,double)));

}

void Car2GoApplication::initLocations()
{
    l_model = new ListModel(new LocationItem, this);
    m_viewer->rootContext()->setContextProperty("locationsModel", l_model);

}

void Car2GoApplication::initSettings()
{
    m_settings = new Settings(this);
    m_viewer->rootContext()->setContextProperty("car2goSettings", m_settings);

    QSystemInfo s;
//    QString currentCountry = s.currentCountryCode();

    qDebug()<< "current country code:  " << s.currentCountryCode();
    QString currentCity = m_settings->city();
    qDebug()<< "city :" << currentCity;


    if(currentCity.isEmpty()){
        QString country_code = s.currentCountryCode();
        if ( country_code == "DE"){
            m_settings->setCity("Ulm");
        } else if( country_code == "NL"){
            m_settings->setCity("Amsterdam");
        } else if( country_code == "US"){
            m_settings->setCity("Austin");
        } else if( country_code == "FR"){
            m_settings->setCity("Lyon");
        } else if( country_code == "CA"){
            m_settings->setCity("Vancouver");
        } else if( country_code == "AT"){
            m_settings->setCity("Wien");
        } else {
            m_settings->setCity("Hamburg");
        }

    }

    qDebug()<< "unit system :" << m_settings->unitSystem();
    if((m_settings->unitSystem()).isEmpty()){
        QString country_code = s.currentCountryCode();
        if ( country_code == "GB" || country_code == "US"
             || country_code == "HK" || country_code == "EN"   )
        {
            m_settings->setUnitSystem("imperial");
        }
        else {
            m_settings->setUnitSystem("metric");
        }


    }


}

int Car2GoApplication::system()
{
    return Utils::environment();
}

void Car2GoApplication::positionUpdated(const QGeoPositionInfo &info) {

    positionSourceTimeout->stop();

    qDebug() << "GPS Position updated:" << QDateTime::currentDateTime().toString();
    qDebug() << "GPS accuracy:" << info.HorizontalAccuracy;
    position = info;

    // Cache the direction (not included in every gps update)
    if (info.hasAttribute(QGeoPositionInfo::Direction)) {
        m_direction = info.attribute(QGeoPositionInfo::Direction);
        //qDebug() << "GPS direction received:" << m_direction;
    }

    emit positionChanged(info.coordinate().latitude(), info.coordinate().longitude(),info.HorizontalAccuracy ,m_direction);

}

void Car2GoApplication::requestFinished ( int reqId, const QVariantMap response, Car2goError err )
{
    // these are the coordinates of users current location
    double currentLocationLatitude, currentLocationLongitude = 0;

    if (position.isValid()) {
        currentLocationLatitude = position.coordinate().latitude();
        currentLocationLongitude = position.coordinate().longitude();
    }
    qDebug() << "request id: " << m_requestId.value(reqId);


    switch( m_requestId.value(reqId)){
    case RequestVehicles:
    {
        v_model->clearAll();

        if(err.code != 0){
            emit errorOccured(err.message);
            break;
        }

        foreach(QVariant placemark, response["placemarks"].toList()) {
            VehicleItem * vehicle = new VehicleItem;
            vehicle->setName( placemark.toMap()["name"].toString());
            vehicle->setExterior( placemark.toMap()["exterior"].toString());
            vehicle->setInterior( placemark.toMap()["interior"].toString());
            vehicle->setVin( placemark.toMap()["vin"].toString());
            vehicle->setAddress( placemark.toMap()["address"].toString());
            vehicle->setFuel(placemark.toMap()["fuel"].toString());

            // Extract latitude and longitude
            QListIterator<QVariant> i(placemark.toMap()["coordinates"].toList());
            vehicle->setLongitude(i.next().toDouble());
            vehicle->setLatitude(i.next().toDouble());
            // use known users current location coordinates
            // calculateDistance(currentLocationLatitude, currentLocationLongitude, currentLocationAccuracy)
            vehicle->calculateDistance(currentLocationLatitude, currentLocationLongitude,0);

            v_model->appendRow(vehicle);
        }
        v_model->sort();
        qDebug() << "vehicles request finished and successfully updated";

        emit vehiclesUpdated();

    }
    break;
    case RequestGasStations:
    {
        g_model->clearAll();

        if(err.code != 0){
            emit errorOccured(err.message);
            break;
        }


        foreach(QVariant placemark, response["placemarks"].toList()) {
            GasstationItem * gasstation = new GasstationItem;
            gasstation->setName( placemark.toMap()["name"].toString());

            // Extract latitude and longitude
            QListIterator<QVariant> i(placemark.toMap()["coordinates"].toList());
            gasstation->setLongitude(i.next().toDouble());
            gasstation->setLatitude(i.next().toDouble());

            gasstation->calculateDistance(currentLocationLatitude, currentLocationLongitude,0);
            g_model->appendRow(gasstation);

        }
        g_model->sort();

        qDebug() << "gas stations request finished and successfully updated";

        emit gasstationsUpdated();


    }
    break;
    case RequestParking:
    {
        p_model->clearAll();

        if(err.code != 0){
            emit errorOccured(err.message);
            break;
        }


        foreach(QVariant placemark, response["placemarks"].toList()) {
            ParkingItem * parkingspot = new ParkingItem;
            parkingspot->setName( placemark.toMap()["name"].toString());
            parkingspot->setCharging( placemark.toMap()["chargingPole"].toBool());
            parkingspot->setTotalCapacity( placemark.toMap()["totalCapacity"].toInt());
            parkingspot->setUsedCapacity( placemark.toMap()["usedCapacity"].toInt());

            // Extract latitude and longitude
            QListIterator<QVariant> i(placemark.toMap()["coordinates"].toList());
            parkingspot->setLongitude(i.next().toDouble());
            parkingspot->setLatitude(i.next().toDouble());

            parkingspot->calculateDistance(currentLocationLatitude, currentLocationLongitude,0);
            p_model->appendRow(parkingspot);

        }
        p_model->sort();

        qDebug() << "parking spots request finished and successfully updated";

        emit parkingspotsUpdated();

    }
    break;
    case RequestLocations:
    {
        l_model->clearAll();

        if(err.code != 0){
            emit errorOccured(err.message);
            break;
        }
        int counter = 0;


        foreach(QVariant location, response["location"].toList()) {
            LocationItem * car2goLocation = new LocationItem;
            car2goLocation->setLocationName( location.toMap()["locationName"].toString());
            car2goLocation->setDefaultLanguage(location.toMap()["defaultLanguage"].toString());
            car2goLocation->setLocationId(location.toMap()["locationid"].toInt());
            car2goLocation->setCountryCode(location.toMap()["countryCode"].toString());

            // Extract latitude and longitude
             foreach(QVariant center, location.toMap()["center"].toList()){
                 car2goLocation->setCenterLatitude(center.toMap()["latitude"].toDouble());
                 car2goLocation->setCenterLongitude(center.toMap()["longitude"].toDouble());
             }

//            QListIterator<QVariant> lowerRight(location.toMap()["lowerRight"].toList());
//            car2goLocation->setCenterLatitude(lowerRight.toMap()["latitude"].toDouble());
//            car2goLocation->setCenterLongitude(lowerRight.toMap()["longitude"].toDouble());

//            QListIterator<QVariant> upperRight(location.toMap()["upperRight"].toList());
//            car2goLocation->setCenterLatitude(upperRight.toMap()["latitude"].toDouble());
//            car2goLocation->setCenterLongitude(upperRight.toMap()["longitude"].toDouble());

            l_model->appendRow(car2goLocation);
            counter = counter + 1;
        }

        emit locationsUpdated();
    }
    break;

    default:
    {
        if ( err.code != 0){
            emit errorOccured(err.message);
            qDebug()<<"Error: "<<err.message;
        }
    }
    break;
    }
}

void Car2GoApplication::positionSourceStop()
{
    // emit last position coordinates and
    // turn off gps module
    m_gps->lastKnownPosition(false);
    m_gps->stopUpdates();
    qDebug()<< "gps module stop";
}
