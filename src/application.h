/****************************************************************************
*
* go2car2go - car2go client for Symbian devices.
*
* Author: Temirlan Tentimishov (temirlan@gmx.de)
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>.
*****************************************************************************/

#ifndef GO2CAR2GO_APPLICATION_H_
#define GO2CAR2GO_APPLICATION_H_


#include <QtCore>
#include <QtCore/QObject>
#include "engine.h"

class QmlApplicationViewer;
class Go2Car2GoEngine;

class QDeclarativePropertyMap;
class Settings;

// Vehicles
class QSortFilterProxyModel;
class ListModel;
class VehicleItem;


class Car2GoApplication : public QObject
{
Q_OBJECT
public:
    Car2GoApplication(QObject *parent = 0);
    ~Car2GoApplication();

    enum RequestId {
        RequestGasStations,
        RequestLocations,
        RequestBooking,
        RequestParking,
        RequestBookings,
        RequestVehicles,
        RequestPosition,
        RequestCancelBooking,
        RequestCount
    };

    Q_INVOKABLE void getVehicles();
    Q_INVOKABLE void getGasStations();
    Q_INVOKABLE void getParkings();
    Q_INVOKABLE void getLocations();
    Q_INVOKABLE void getBooking( const QString & bookingId );
    Q_INVOKABLE void getBookings();
    Q_INVOKABLE void makeBooking(const QString & vin );



Q_SIGNALS:
    void locationsUpdated();
    void vehiclesUpdated();
    void gasstationsUpdated();
    void parkingspotsUpdated();
    void bookingsUpdated( const QString & xml);
    void bookingUpdated(const QString & xml);
    void makeBookingDone();
    void positionChanged(const double latitude, const double longitude, const double horizontalAccuracy, qreal direction);
    void authenticationRequired();
    void errorOccured(const QString message);

public slots:
    int system();

protected slots:
    void requestFinished ( int reqId, const QVariantMap response, Car2goError error );
    void positionSourceStop();
private slots:
    void positionUpdated(const QGeoPositionInfo &info);

private:
    void initUI();
    void initSettings();
    void initVehicles();
    void initParkingSpots();
    void initGasStations();
    void initLocations();

    QmlApplicationViewer *m_viewer;
    Go2Car2GoEngine *m_engine;

    QDeclarativePropertyMap *m_properties;
    Settings *m_settings;

    QHash<int, Car2GoApplication::RequestId> m_requestId;


    // Location
    QGeoPositionInfoSource *m_gps;
    QGeoPositionInfo position;
    qreal m_direction;
    QTimer *positionSourceTimeout;

    // vehicles, gas stations, parking spots
    ListModel * v_model;
    ListModel * g_model;
    ListModel * p_model;
    ListModel * l_model;
};

#endif // GO2CAR2GO_APPLICATION_H_
