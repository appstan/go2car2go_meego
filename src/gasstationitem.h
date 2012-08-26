#ifndef GASSTATIONITEM_H
#define GASSTATIONITEM_H

#include "listmodel.h"

class GasstationItem : public ListItem
{
         Q_OBJECT
public:
    enum Roles{
        DistanceRole = Qt::UserRole+1,
        NameRole,
        LatitudeRole,
        LongitudeRole
    };

//    GasstationItem(QObject* parent = 0): ListItem(parent){}
    GasstationItem( QObject *parent = 0);
    QVariant data(int role) const;
    QHash<int, QByteArray> roleNames() const;
    void setDistance(qreal distance);
    void setName(QString name);
    void setLatitude(double latitude);
    void setLongitude(double longitude);
    void calculateDistance(const double latitude, const double longitude, const double hAccuracy);


    inline QString id() const{return m_name;}
    inline QString name() const{return m_name;}
    inline qreal distance() const{return m_distance;}
    inline double latitude() const{return m_latitude;}
    inline double longitude() const{return m_longitude;}

private:
    QString m_name;
    qreal m_distance;
    double m_latitude;
    double m_longitude;
};

#endif // GASSTATIONITEM_H
