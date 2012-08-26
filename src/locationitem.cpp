
#include "locationitem.h"
#include "utils.h"

using namespace Utils;

LocationItem::LocationItem( QObject *parent ):  ListItem(parent)
{
}

QHash<int, QByteArray> LocationItem::roleNames()const
{
    QHash<int, QByteArray> names;
    names[LocationNameRole] = "location_name";
    names[LocationIdRole] = "location_id";
    names[DefaultLanguageRole] = "default_language";
    names[CountryCodeRole] = "country_code";
    names[CenterLatitudeRole] = "center_lati";
    names[CenterLongitudeRole] = "center_longi";

    names[LowerRightLatitudeRole] = "lower_lati";
    names[LowerRightLongitudeRole] = "lower_longi";

    names[UpperRightLatitudeRole] = "upper_lati";
    names[UpperRightLongitudeRole] = "upper_longi";

    return names;
}

QVariant LocationItem::data(int role) const
{
    switch(role) {
    case LocationNameRole:
        return locationName();
    case LocationIdRole:
        return locationId();
    case DefaultLanguageRole:
        return defaultLanguage();
    case CountryCodeRole:
        return countryCode();
    case CenterLatitudeRole:
        return centerLatitude();
    case CenterLongitudeRole:
        return centerLongitude();
    case LowerRightLatitudeRole:
        return lowerRightLatitude();
    case LowerRightLongitudeRole:
        return lowerRightLongitude();
    case UpperRightLatitudeRole:
        return upperRightLatitude();
    case UpperRightLongitudeRole:
        return upperRightLongitude();
    default:
        return QVariant();
    }
}

void LocationItem::setLocationName(QString name)
{
    if(m_name != name){
        m_name = name;
        emit dataChanged();
    }
}

void LocationItem::setDefaultLanguage(QString language)
{
    if(m_language != language){
        m_language = language;
        emit dataChanged();
    }
}

void LocationItem::setCountryCode(QString code)
{
    if(m_code != code){
        m_code = code;
        emit dataChanged();
    }
}

void LocationItem::setLocationId(int id)
{
    if(m_id != id){
        m_id = id;
        emit dataChanged();
    }
}

void LocationItem::setCenterLatitude(double latitude)
{
    if(m_latitude != latitude){
        m_latitude = latitude;
        emit dataChanged();
    }
}

void LocationItem::setCenterLongitude(double longitude)
{
    if(m_longitude != longitude){
        m_longitude = longitude;
        emit dataChanged();
    }
}

void LocationItem::setLowerRightLatitude(double latitude)
{
    if(m_lr_latitude != latitude){
        m_lr_latitude = latitude;
        emit dataChanged();
    }
}

void LocationItem::setLowerRightLongitude(double longitude)
{
    if(m_lr_longitude != longitude){
        m_lr_longitude = longitude;
        emit dataChanged();
    }
}

void LocationItem::setUpperRightLatitude(double latitude)
{
    if(m_ur_latitude != latitude){
        m_ur_latitude = latitude;
        emit dataChanged();
    }
}

void LocationItem::setUpperRightLongitude(double longitude)
{
    if(m_ur_longitude != longitude){
        m_ur_longitude = longitude;
        emit dataChanged();
    }
}
