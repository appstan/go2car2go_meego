#ifndef LOCATIONITEM_H
#define LOCATIONITEM_H

#include "listmodel.h"

class LocationItem: public ListItem
{
     Q_OBJECT
public:
    enum Roles{
        LocationIdRole = Qt::UserRole+1,
        LocationNameRole,
        DefaultLanguageRole,
        CountryCodeRole,
        CenterLatitudeRole,
        CenterLongitudeRole,
        LowerRightLatitudeRole,
        LowerRightLongitudeRole,
        UpperRightLatitudeRole,
        UpperRightLongitudeRole
    };

    LocationItem(QObject *parent = 0);

    QVariant data(int role) const;
    QHash<int, QByteArray> roleNames() const;

    void setLocationName(QString name);
    void setLocationId(int id);
    void setDefaultLanguage(QString language);
    void setCountryCode(QString code);

    void setCenterLatitude(double latitude);
    void setCenterLongitude(double longitude);
    void setLowerRightLatitude(double latitude);
    void setLowerRightLongitude(double longitude);
    void setUpperRightLatitude(double latitude);
    void setUpperRightLongitude(double longitude);

    inline QString id() const{return m_name;}
    inline QString locationName() const{return m_name;}
    inline QString countryCode() const{return m_code;}
    inline QString defaultLanguage() const{return m_language;}
    inline int locationId() const{return m_id;}

    inline double centerLatitude() const{return m_latitude;}
    inline double centerLongitude() const{return m_longitude;}
    inline double lowerRightLatitude() const{return m_lr_latitude;}
    inline double lowerRightLongitude() const{return m_lr_longitude;}
    inline double upperRightLatitude() const{return m_ur_latitude;}
    inline double upperRightLongitude() const{return m_ur_longitude;}

    inline qreal distance() const{return 0;}

private:
    QString m_name;
    QString m_code;
    QString m_language;
    int m_id;

    double m_latitude;
    double m_longitude;
    double m_lr_latitude;
    double m_lr_longitude;
    double m_ur_latitude;
    double m_ur_longitude;

};

#endif // LOCATIONITEM_H
