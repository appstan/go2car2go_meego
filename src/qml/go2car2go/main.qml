import QtQuick 1.1
import QtMobility.systeminfo 1.2
import QtMobility.feedback 1.1
import QtMobility.location 1.2
import com.nokia.meego 1.0

PageStackWindow {
    id: main

    width: globalSettings.width
    height: globalSettings.height

    initialPage: vehiclesPage

    property bool loggingEnabled: true
    property bool unitMetric: car2goSettings.unitSystem() == "metric" ? true : false

    property bool hibernate: !Qt.application.active
    property variant user: userStatus

    signal cityChanged
    signal itemClicked()

    property string itemName: ""
    property string itemInterior: ""
    property string itemExterior: ""
    property string itemFuel: ""
    property string itemAddress: ""
    property string itemDistance: ""
    property string itemLatitude: ""
    property string itemLongitude: ""

    onItemClicked:  {
        itemText1.text = itemName
        itemText2.text = itemInterior
        itemText3.text = itemExterior
        itemText4.text = itemFuel
        itemText5.text = itemAddress
        itemText6.text = globalSettings.locateDistance(itemDistance, main.unitMetric)

        myMenu.open()
    }

    onHibernateChanged: {
//        if (hibernate){
//        } else {
//        }
    }

    DeviceInfo {
        id: devinfo
    }

    Settings{
        id:globalSettings
    }

    function playEffect(){
        actionEffect.play()
    }

    HapticsEffect {
         id: actionEffect
         attackIntensity: 0.0
         attackTime: 200
         intensity: 1.0
         duration: 100
         fadeTime: 200
         fadeIntensity: 0.0
         running: false
         function play(){
             running = true
             actionTimer.restart()
         }
     }

    Timer{
        id: actionTimer
        interval: 300
        onTriggered: {
            actionEffect.running = false
        }
    }

    function setMyLocation (latitude, longitude , direction)  {
        userCurrentLocation.latitude = latitude;
        userCurrentLocation.longitude = longitude;
     }

    Coordinate {
        id: userCurrentLocation
    }

    Connections{
        target:car2goManager
        onPositionChanged: {
            setMyLocation(latitude, longitude , direction);
        }

    }

    UserStatusContainer{
        id: userStatus
        currentLatitude: userCurrentLocation.latitude ? userCurrentLocation.latitude : 48.421711 // CAR2GO HQ Ulm
        currentLongitude: userCurrentLocation.longitude ? userCurrentLocation.longitude : 9.941962
    }

    VehiclesPage {
        id: vehiclesPage
    }

   //Remark: For better UX decided to preload all pages
    GasStationsPage {
        id: gasstationsPage
    }

    ParkingSpotsPage {
        id: parkingsPage
    }


    ToolBarLayout {
        id: commonTools
        visible: true

        // vehicles
        ToolIcon {
            id:toolbarItemVehicle
            iconSource: pageStack.currentPage === vehiclesPage ? "qrc:///images/vehicle_glow.png" : "qrc:///images/vehicle.png"
            onClicked: {
                if (pageStack.currentPage !== vehiclesPage){
                    pageStack.replace(vehiclesPage)
                }
            }
        }
        // parking spots
        ToolIcon {
            id:toolbarItemParking
            iconSource:pageStack.currentPage === parkingsPage ? "qrc:///images/parking_glow.png" : "qrc:///images/parking.png"
            onClicked: {
                if (pageStack.currentPage !== parkingsPage){
                    pageStack.replace(parkingsPage)
                    if (!parkingsPage.model)
                        car2goManager.getParkings()

                }
            }
        }
        // gas stations
        ToolIcon {
            id:toolbarItemGasstation
            iconSource: pageStack.currentPage === gasstationsPage ? "qrc:///images/station_glow.png" : "qrc:///images/station.png"
            onClicked: {
                if (pageStack.currentPage !== gasstationsPage){
                    pageStack.replace(gasstationsPage)
                    if (!gasstationsPage.model)
                        car2goManager.getGasStations()

                }
            }
        }
        // bookings
        ToolIcon {
            id:toolbarItemBooking
            iconSource: "qrc:///images/reserve.png"
            onClicked: {
                toBookings()
            }
        }
    }


    Dialog {
        id: myMenu
        property int menuTopY:314
        property int menuHeight:400

        platformStyle: DialogStyle { dim: 0.7 }
        width: parent.width
        height: parent.height
        onStatusChanged: {
            if (myMenu.status == DialogStatus.Closed){
                itemName = ""
                itemInterior = ""
                itemExterior = ""
                itemFuel = ""
                itemAddress = ""
                itemDistance = ""
                itemLatitude = ""
                itemLongitude = ""
            }
        }


        function triggered() {
            if(status == DialogStatus.Open) {
                close();
            } else {
                open();
            }
        }

        Rectangle{
            id: menuBackground
            radius:8
            color:"#E4E4E4"
            height:  myMenu.menuHeight
            width: parent.width
            y: myMenu.status != DialogStatus.Closed ? myMenu.menuTopY : 854
            anchors.bottom: parent.bottom
            visible: myMenu.status != DialogStatus.Closed

            Item{
                id:menuHeader
                anchors {left: parent.left; right: parent.right;top: parent.top}
                Text{
                    id: itemText1
                    height:itemText1.text == "" ? 0 : globalSettings.bigFontSize
                    color: globalSettings.colorOrange
                    font.family: globalSettings.defaultFontFamily
                    font.pixelSize: globalSettings.bigFontSize
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors {left: parent.left; top: parent.top; margins:globalSettings.largeMargin}
                }
                //INTERIOR
                Text{
                    id: itemText2
                    width: parent.width
                    height:itemText2.text == "" ? 0 : globalSettings.bigFontSize
                    color: globalSettings.colorBlack
                    elide: Text.ElideRight
                    wrapMode: Text.Wrap
                    font.family:globalSettings.defaultFontFamily
                    font.pixelSize: globalSettings.normalFontSize
                    anchors {left: parent.left; top: itemText1.bottom; margins:globalSettings.smallMargin; leftMargin: globalSettings.largeMargin}
                }
                //EXTERIOR
                Text{
                    id: itemText3
                    width: parent.width
                    height:itemText3.text == "" ? 0 : globalSettings.bigFontSize
                    elide: Text.ElideRight
                    wrapMode: Text.Wrap
                    font.family:globalSettings.defaultFontFamily
                    font.pixelSize: globalSettings.normalFontSize
                    anchors {left: parent.left; top: itemText2.bottom; margins:globalSettings.smallMargin; leftMargin: globalSettings.largeMargin}
                }
                //FUEL
                Text{
                    id: itemText4
                    width: parent.width
                    height:itemText4.text == "" ? 0 : globalSettings.bigFontSize
                    color: globalSettings.colorBlack
                    elide: Text.ElideRight
                    wrapMode: Text.Wrap
                    font.family:globalSettings.defaultFontFamily
                    font.pixelSize: globalSettings.normalFontSize
                    anchors {left: parent.left; top: itemText3.bottom; margins:globalSettings.smallMargin; leftMargin: globalSettings.largeMargin}
                }

                //ADDRESS
                Text{
                    id: itemText5
                    width: parent.width - 150
                    color: globalSettings.colorBlack
                    elide: Text.ElideRight
                    wrapMode: Text.Wrap
                    font.family:globalSettings.defaultFontFamily
                    font.pixelSize: globalSettings.mediumFontSize
                    anchors.bottomMargin: globalSettings.extraLargeMargin
                    anchors {left: parent.left; top: itemText4.bottom; margins:globalSettings.smallMargin; leftMargin: globalSettings.largeMargin}
                }
                //DISTANCE
                Text{
                    id: itemText6
                    color: globalSettings.colorOrange
                    elide: Text.ElideRight
                    font.family :globalSettings.defaultFontFamily
                    font.pixelSize: 18
                    anchors { top: itemText4.bottom;  right:parent.right; margins:globalSettings.smallMargin; rightMargin: globalSettings.largeMargin}
                }

                HorizontalDivider { width: parent.width ; margin: 20; anchors.topMargin: 25 ; anchors.top: itemText5.bottom}
            }

            Timer{
                id: actionDelay
                interval: 5000
                running: false
                repeat: false
            }

            //Dialog buttons
            MenuLayout {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: globalSettings.hugeMargin
                //Book button
//                Button{
//                    implicitHeight:70
//                    anchors {
//                        horizontalCenter: parent.horizontalCenter
//                    }
//                    width: parent.width
//                    text: qsTr("Book")
//                    onClicked: {
//                        myMenu.close()
//                        toBookings()
//                    }
//                }
//                Item { width: parent.width; height: 20}
                //Route button
                Button{
                    implicitHeight:70
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                    }
                    width: parent.width
                    text: qsTr("Route")
                    onClicked: {
                        main.playEffect()
                        var geoLocation = "geo:"+ itemLatitude + "," + itemLongitude
                        Qt.openUrlExternally(geoLocation)
                        actionDelay.start()
                    }
                }
                Item { width: parent.width; height: 20}
                //Cancel button
                Button{
                    implicitHeight:70
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                    }
                    width: parent.width
                    text: qsTr("Cancel")
                    onClicked: {
                        myMenu.close()
                    }
                }
            }

            Behavior on y {
                NumberAnimation {
                    duration: 300
                }
            }

        }

    }

    function toVehicles(){
        var stackItem = pageStack.find(function(page){return page.name == "vehicle"})
        if (pageStack.currentPage != stackItem){
            pageStack.replace(stackItem)
            if (!stackItem.model)
                car2goManager.getVehicles()
        }
    }

    function toBookings(){
        var stackItem = pageStack.find(function(page){return page.name == "bookings"})
        if (!stackItem){
            pageStack.replace(main.openFile("BookingsPage.qml"))
        }
        else{
            if (pageStack.currentPage != stackItem){
                pageStack.replace(stackItem)
            }
        }
    }

    function toSettings(){
        var stackItem = pageStack.find(function(page){return page.name == "settings"})
        if (!stackItem){
            pageStack.replace(main.openFile("SettingsPage.qml"))
            car2goManager.getLocations()
        }
        else{
            if (pageStack.currentPage != stackItem){
                pageStack.replace(stackItem)
                if (!stackItem.model)
                    car2goManager.getLocations()
            }
        }
    }

    function toGasStation(){
        var stackItem = pageStack.find(function(page){return page.name == "gasstation"})
        if (!stackItem){
            pageStack.replace(main.openFile("GasStationsPage.qml"))
            car2goManager.getGasStations()
        }
        else{
            if (pageStack.currentPage != stackItem){
                pageStack.replace(stackItem)
                if (!stackItem.model)
                    car2goManager.getGasStations()
            }
        }
    }

    function toLogin(){
        var stackItem = pageStack.find(function(page){return page.name == "login"})
        if (!stackItem){
            stackItem = openFile("LoginPage.qml")
            pageStack.push(stackItem)
        }
    }

    function toParkingSpots(){
        var stackItem = pageStack.find(function(page){return page.name == "parking"})
        if (!stackItem){
            pageStack.replace(main.openFile("ParkingSpotsPage.qml"))
            car2goManager.getParkings()
        }
        else{
            if (pageStack.currentPage != stackItem){
                pageStack.replace(stackItem)
                if (!stackItem.model)
                    car2goManager.getParkings()
            }
        }
    }

    function currentMainPage() {
        return pageStack.currentPage.name
    }

    function log(aData){
        if (loggingEnabled){
            var date = new Date()
            console.log(date + ":   " + aData)
        }
    }

    function openFile(file) {
        var component = Qt.createComponent(file)
        if (component.status != Component.Ready){
            main.log("Error loading component:" + component.errorString());
            return null;
        }
        return component
    }

    function addPage(file) {
        var component = Qt.createComponent(file)

        if (component.status === Component.Ready) {
            pageStack.push(component);
        } else {
            main.log("Error loading component:", component.errorString());
        }
    }

    function replacePage(file) {
        var component = Qt.createComponent(file)

        if (component.status === Component.Ready) {
            pageStack.replace(component);
        } else {
            main.log("Error loading component:", component.errorString());
        }
    }

}
