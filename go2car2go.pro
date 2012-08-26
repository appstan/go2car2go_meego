#############################################################################
# G2Car2Go - car2go client for Harmattan
# Copyright (C) 2011 Temirlan Tentimishov <temirlan@gmx.de>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>./
#############################################################################
# Add more folders to ship with the application, here
#folder_01.source = qml/go2car2go
#folder_01.target = qml
DEPLOYMENTFOLDERS = #folder_01

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

symbian:{
    TARGET.UID3 = 0xEE5CB828
    TARGET.CAPABILITY += Location NetworkServices ReadUserData
    TARGET.EPOCHEAPSIZE = 0x20000  0x8000000
    #for Symbian^1 missing QtOpenGL.dso whem compiling
    QT_CONFIG -= opengl
}else{
    QT +=  opengl
}

# Smart Installer package's UID
# This UID is from the protected range and therefore the package will
# fail to install if self-signed. By default qmake uses the unprotected
# range value if unprotected UID is defined for the application and
# 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
symbian:TARGET.CAPABILITY += NetworkServices

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
QT += core declarative gui network xml webkit
CONFIG += mobility
MOBILITY += systeminfo location sensors

# Speed up launching on MeeGo/Harmattan when using applauncherd daemon
CONFIG += qdeclarative-boostable

# Add dependency to Symbian components
# CONFIG += qt-components

# The .cpp file which was generated for your project. Feel free to hack it.

###########
# Sources #
###########
# Core

SOURCES += src/main.cpp \
    src/application.cpp \
    src/engine.cpp \
    src/utils.cpp \
    src/listmodel.cpp \
    src/vehicleitem.cpp \
    src/parkingitem.cpp \
    src/gasstationitem.cpp \
    src/settings.cpp \
    src/locationitem.cpp
# Json
SOURCES += \
    src/json.cpp

# OAuth
SOURCES += \
    src/koauth/kqoauthutils.cpp \
    src/koauth/kqoauthrequest.cpp \
    src/koauth/kqoauthmanager.cpp \
    src/koauth/kqoauthauthreplyserver.cpp\
    src/koauth/kqoauthrequest_1.cpp \
    src/koauth/kqoauthrequest_xauth.cpp

###########
# Headers #
###########
# Core
HEADERS += \
    src/application.h \
    src/engine.h \
    src/utils.h \
    src/listmodel.h \
    src/orientationfilter.h \
    src/vehicleitem.h \
    src/parkingitem.h \
    src/gasstationitem.h \
    src/settings.h \
    src/locationitem.h

# Json
HEADERS += \
    src/json.h
# OAuth
HEADERS += \
    src/koauth/kqoauthutils.h \
    src/koauth/kqoauthrequest_p.h \
    src/koauth/kqoauthrequest.h \
    src/koauth/kqoauthmanager_p.h \
    src/koauth/kqoauthmanager.h \
    src/koauth/kqoauthglobals.h \
    src/koauth/kqoauthauthreplyserver_p.h \
    src/koauth/kqoauthauthreplyserver.h \
    src/koauth/kqoauthrequest_1.h \
    src/koauth/kqoauthrequest_xauth.h


OTHER_FILES += \
    src/qml/go2car2go/main.qml \
    src/qml/go2car2go/Settings.qml \
    src/qml/go2car2go/LoginPage.qml \
    src/qml/go2car2go/VehiclesPage.qml \
    src/qml/go2car2go/ParkingSpotsPage.qml \
    src/qml/go2car2go/GasStationsPage.qml \
    src/qml/go2car2go/VehiclesDelegate.qml \
    src/qml/go2car2go/GasStationsDelegate.qml \
    src/qml/go2car2go/PageHeader.qml \
    src/qml/go2car2go/VehiclesMapPage.qml \
    src/qml/go2car2go/Car2GoMapItem.qml \
    src/qml/go2car2go/GasStationsMapPage.qml \
    src/qml/go2car2go/ParkingSpotsMapPage.qml \
    src/qml/go2car2go/ParkingSpotsDelegate.qml \
    src/qml/go2car2go/Car2GoMap.qml \
    src/qml/go2car2go/Car2GoMapItem.qml \
    src/qml/go2car2go/MyLocationMapItem.qml \
    src/qml/go2car2go/MapItemList.qml \
    src/qml/go2car2go/MapItemListItem.qml \
    src/qml/go2car2go/MapItemContainer.qml \
    src/qml/go2car2go/UserStatusContainer.qml \
    src/qml/go2car2go/ParkingMapItemListItem.qml \
    src/qml/go2car2go/GasStationMapItemListItem.qml \
    src/qml/go2car2go/BookingsPage.qml\
    src/qml/go2car2go/car2go.js \
    src/qml/go2car2go/oauth.js \
    src/qml/go2car2go/sha1.js \
    src/qml/go2car2go/storage.js \
    src/qml/go2car2go/settings.js \
    src/qml/go2car2go/script.js \
    src/qml/go2car2go/Separator.qml \
    src/qml/go2car2go/CustomIcon.qml \
    src/qml/go2car2go/SettingsPage.qml \
    src/qml/go2car2go/DropdownMenu.qml \
    src/qml/go2car2go/HorizontalDivider.qml \
    src/qml/go2car2go/DropDownMenuItem.qml \
    src/qml/go2car2go/LocationsDelegate.qml

RESOURCES += \
    src/go2car2go.qrc

##############
# Deployment #
##############
# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

OTHER_FILES += \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/manifest.aegis \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog
