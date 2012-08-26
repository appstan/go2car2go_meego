#ifndef PARKINGITEM_H
#define PARKINGITEM_H

#include "listmodel.h"

class ParkingItem : public ListItem
{
     Q_OBJECT
public:
    enum Roles{
        DistanceRole = Qt::UserRole+1,
        NameRole,
        LatitudeRole,
        LongitudeRole,
        TotalCapacityRole,
        UsedCapacityRole,
        ChargingRole
    };

//    ParkingItem(QObject* parent = 0): ListItem(parent){}
    ParkingItem( QObject *parent = 0);
    QVariant data(int role) const;
    QHash<int, QByteArray> roleNames() const;
    void setDistance(qreal distance);
    void setName(QString name);
    void setTotalCapacity(int total);
    void setUsedCapacity(int used);
    void setCharging(bool charging);
    void setLatitude(double latitude);
    void setLongitude(double longitude);
    void calculateDistance(const double latitude, const double longitude, const double hAccuracy);

    inline QString id() const{return m_name;}
    inline QString name() const{return m_name;}
    inline bool charging() const{return m_charging;}
    inline int usedCapacity() const{return m_usedCapacity;}
    inline int totalCapacity() const{return m_totalCapacity;}
    inline qreal distance() const{return m_distance;}
    inline double latitude() const{return m_latitude;}
    inline double longitude() const{return m_longitude;}

private:
    QString m_name;
    int m_usedCapacity;
    int m_totalCapacity;
    bool m_charging;
    qreal m_distance;
    double m_latitude;
    double m_longitude;
};

#endif // PARKINGITEM_H
