#ifndef VEHICLEITEM_H
#define VEHICLEITEM_H

#include "listmodel.h"

class VehicleItem : public ListItem
{
    Q_OBJECT
public:
    enum Roles{
        DistanceRole = Qt::UserRole+1,
        AddressRole,
        FuelRole,
        InteriorRole,
        ExteriorRole,
        VinRole,
        LatitudeRole,
        LongitudeRole,
        NameRole
    };

    VehicleItem(QObject* parent = 0): ListItem(parent){}
    explicit VehicleItem(const QString &name, const QString &address,
                         const QString &interior, const QString &exterior,
                         const QString &fuel, const qreal &distance,
                         const QString &vin, QObject *parent = 0);

    QVariant data(int role) const;
    QHash<int, QByteArray> roleNames() const;
    void setDistance(qreal distance);
    void setAddress(QString address);
    void setName(QString name);
    void setInterior(QString interior);
    void setExterior(QString exterior);
    void setFuel(QString fuel);
    void setVin(QString vin);
    void setLatitude(double latitude);
    void setLongitude(double longitude);
    void calculateDistance(const double latitude, const double longitude, const double hAccuracy);

    inline QString id() const{return m_name;}
    inline QString name() const{return m_name;}
    inline QString interior() const{return m_interior;}
    inline QString exterior() const{return m_exterior;}
    inline QString vin() const{return m_vin;}
    inline QString fuel() const{return m_fuel;}
    inline QString address() const{return m_address;}
    inline qreal distance() const{return m_distance;}
    inline double latitude() const{return m_latitude;}
    inline double longitude() const{return m_longitude;}

private:
    QString m_name;
    QString m_interior;
    QString m_exterior;
    QString m_address;
    QString m_vin;
    QString m_fuel;
    qreal m_distance;
    double m_latitude;
    double m_longitude;

};

#endif // VEHICLEITEM_H
