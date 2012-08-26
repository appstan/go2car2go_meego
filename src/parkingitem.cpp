#include "parkingitem.h"
#include "utils.h"

using namespace Utils;

ParkingItem::ParkingItem( QObject *parent ):  ListItem(parent),
    m_name(), m_distance(0),m_latitude(0),m_longitude(0),
    m_totalCapacity(0), m_usedCapacity(0),m_charging(false)
{
}

QHash<int, QByteArray> ParkingItem::roleNames()const
{
    QHash<int, QByteArray> names;
    names[DistanceRole] = "distance";
    names[UsedCapacityRole] = "used_capacity";
    names[TotalCapacityRole] = "total_capacity";
    names[ChargingRole] = "charging_pole";
    names[NameRole] = "park_name";
    names[LatitudeRole] = "lati";
    names[LongitudeRole] = "longi";

    return names;
}

QVariant ParkingItem::data(int role) const
{
    switch(role) {
    case NameRole:
        return name();
    case DistanceRole:
        return distance();
    case UsedCapacityRole:
        return usedCapacity();
    case TotalCapacityRole:
        return totalCapacity();
    case ChargingRole:
        return charging();
    case LatitudeRole:
        return latitude();
    case LongitudeRole:
        return longitude();
    default:
        return QVariant();
    }
}

void ParkingItem::setDistance(qreal distance)
{
    if(m_distance != distance){
        m_distance = distance;
        emit dataChanged();
    }
}

void ParkingItem::setLatitude(double latitude)
{
    if(m_latitude != latitude){
        m_latitude = latitude;
        emit dataChanged();
    }
}

void ParkingItem::setLongitude(double longitude)
{
    if(m_longitude != longitude){
        m_longitude = longitude;
        emit dataChanged();
    }
}

void ParkingItem::setName(QString name)
{
    if(m_name != name){
        m_name = name;
        emit dataChanged();
    }

}

void ParkingItem::setUsedCapacity(int capacity)
{
    if(m_usedCapacity != capacity){
        m_usedCapacity = capacity;
        emit dataChanged();
    }
}

void ParkingItem::setTotalCapacity(int capacity)
{
    if(m_totalCapacity != capacity){
        m_totalCapacity = capacity;
        emit dataChanged();
    }
}

void ParkingItem::setCharging(bool charging)
{
    if(m_charging != charging){
        m_charging = charging;
        emit dataChanged();
    }
}

void ParkingItem::calculateDistance(const double latitude, const double longitude, const double horizontalAccuracy)
{

    setDistance( Utils::calculateDistance(latitude, longitude, m_latitude, m_longitude));
}
