#include <QtCore/QDir>

#include "settings.h"

Settings::Settings(QObject *parent)
    : QSettings(QSettings::IniFormat,
                QSettings::UserScope,
                "Go2Car2Go",
                "Main",
                parent)
{
    readSettings();
}

Settings::~Settings() { }

void Settings::readSettings()
{
    setCity(value("general/city").toString());
    setUnitSystem(value("general/unit").toString());

//    setAccessToken(value("auth/access-token").toString());
//    setRefreshToken(value("auth/refresh-token").toString());
}

void Settings::writeSettings()
{
    setValue("general/city", city());
    setValue("general/unit", unitSystem());

//    setValue("auth/access-token", accessToken());
//    setValue("auth/refresh-token", refreshToken());

    sync();
}
