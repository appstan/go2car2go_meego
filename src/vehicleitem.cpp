#include "vehicleitem.h"
#include "utils.h"
#include "QDebug"

using namespace Utils;

VehicleItem::VehicleItem(const QString &name, const QString &address,
                         const QString &interior, const QString &exterior, const QString &fuel,
                         const qreal &distance, const QString &vin, QObject *parent):
    ListItem(parent), m_name(name), m_interior(interior),
    m_exterior(exterior),m_fuel(fuel),m_distance(distance),
    m_address(address), m_vin(vin),m_latitude(0),m_longitude(0)
{
}


QHash<int, QByteArray> VehicleItem::roleNames()const
{
    QHash<int, QByteArray> names;
    names[DistanceRole] = "distance";
    names[AddressRole] = "address";
    names[FuelRole] = "fuel";
    names[InteriorRole] = "interior";
    names[ExteriorRole] = "exterior";
    names[VinRole] = "vin";
    names[NameRole] = "plate_number";
    names[LatitudeRole] = "lati";
    names[LongitudeRole] = "longi";

    return names;
}

QVariant VehicleItem::data(int role) const
{
    switch(role) {
    case NameRole:
        return name();
    case DistanceRole:
        return distance();
    case AddressRole:
        return address();
    case FuelRole:
        return fuel();
    case InteriorRole:
        return interior();
    case ExteriorRole:
        return exterior();
    case VinRole:
        return vin();
    case LatitudeRole:
        return latitude();
    case LongitudeRole:
        return longitude();
    default:
        return QVariant();
    }
}

void VehicleItem::setDistance(qreal distance)
{
    if(m_distance != distance){
        m_distance = distance;
        emit dataChanged();
    }
}

void VehicleItem::setLatitude(double latitude)
{
    if(m_latitude != latitude){
        m_latitude = latitude;
        emit dataChanged();
    }
}

void VehicleItem::setLongitude(double longitude)
{
    if(m_longitude != longitude){
        m_longitude = longitude;
        emit dataChanged();
    }
}

void VehicleItem::setAddress(QString address)
{
    if(m_address != address){
        m_address = address;
        emit dataChanged();
    }

}

void VehicleItem::setName(QString name)
{
    if(m_name != name){
        m_name = name;
        emit dataChanged();
    }

}

void VehicleItem::setInterior(QString interior)
{
    if(m_interior != interior){
        m_interior = interior;
        emit dataChanged();
    }
}

void VehicleItem::setExterior(QString exterior)
{
    if(m_exterior != exterior){
        m_exterior = exterior;
        emit dataChanged();
    }
}
void VehicleItem::setFuel(QString fuel)
{
    if(m_fuel != fuel){
        m_fuel = fuel;
        emit dataChanged();
    }
}

void VehicleItem::setVin(QString vin)
{
    if(m_vin != vin){
        m_vin = vin;
        emit dataChanged();
    }
}

void VehicleItem::calculateDistance(const double latitude, const double longitude, const double horizontalAccuracy)
{
    setDistance( Utils::calculateDistance(latitude, longitude, m_latitude, m_longitude));
}
