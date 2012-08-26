#include "gasstationitem.h"
#include "utils.h"

using namespace Utils;

GasstationItem::GasstationItem(QObject *parent ):  ListItem(parent),
    m_name(), m_distance(0),m_latitude(0),m_longitude(0)
{
}

QHash<int, QByteArray> GasstationItem::roleNames()const
{
    QHash<int, QByteArray> names;
    names[DistanceRole] = "distance";
    names[NameRole] = "gasstation_name";
    names[LatitudeRole] = "lati";
    names[LongitudeRole] = "longi";

    return names;
}

QVariant GasstationItem::data(int role) const
{
    switch(role) {
    case NameRole:
        return name();
    case DistanceRole:
        return distance();
    case LatitudeRole:
        return latitude();
    case LongitudeRole:
        return longitude();
    default:
        return QVariant();
    }
}

void GasstationItem::setDistance(qreal distance)
{
    if(m_distance != distance){
        m_distance = distance;
        emit dataChanged();
    }
}

void GasstationItem::setLatitude(double latitude)
{
    if(m_latitude != latitude){
        m_latitude = latitude;
        emit dataChanged();
    }
}

void GasstationItem::setLongitude(double longitude)
{
    if(m_longitude != longitude){
        m_longitude = longitude;
        emit dataChanged();
    }
}

void GasstationItem::setName(QString name)
{
    if(m_name != name){
        m_name = name;
        emit dataChanged();
    }
}

void GasstationItem::calculateDistance(const double latitude, const double longitude, const double horizontalAccuracy)
{

    setDistance( Utils::calculateDistance(latitude, longitude, m_latitude, m_longitude));
}
