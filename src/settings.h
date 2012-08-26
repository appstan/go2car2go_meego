#ifndef SETTINGS_H
#define SETTINGS_H

#include <QtCore/QSettings>

class Settings : public QSettings
{
Q_OBJECT
public:
    Settings(QObject * parent = 0);
    ~Settings();

    Q_INVOKABLE void readSettings();
    Q_INVOKABLE void writeSettings();

    // General
    Q_INVOKABLE inline QString city() const { return m_city; }
    Q_INVOKABLE inline void setCity(const QString &city) { m_city = city; emit cityChanged();}

    Q_INVOKABLE inline QString unitSystem() const { return m_unit; }
    Q_INVOKABLE inline void setUnitSystem(const QString &unit) { m_unit = unit; }

    // Authentication
    inline QString accessToken() const { return _accessToken; }
    inline void setAccessToken(const QString &s) { _accessToken = s; }
    inline QString refreshToken() const { return _refreshToken; }
    inline void setRefreshToken(const QString &s) { _refreshToken = s; }
Q_SIGNALS:
    void cityChanged();

private:
    // General
    QString m_city;
    QString m_unit;

    // Authentication
    QString _accessToken;
    QString _refreshToken;
};

#endif // SETTINGS_H
