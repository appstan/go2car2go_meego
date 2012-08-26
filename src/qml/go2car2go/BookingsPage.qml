import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: wrapper
    tools: bookingTools

    property variant model
    property string name: "bookings"

    Component.onCompleted: {
        main.log("bookings page is created")
    }

    focus : true

//    Connections{
//        target:car2goManager

//        onAuthenticationRequired:{
//            main.toLogin()
//        }

//        onErrorOccured:{
//            textArea.text = message
//        }

//    }


//    ListView{
//        id: bookingsView
//        anchors.fill: parent
//        anchors.topMargin: globalSettings.headerPortraiHeight
//        cacheBuffer: bookingsView.height
//        clip: true
//    }

//    ScrollDecorator {
//        flickableItem: bookingsView
//    }

    // placeholder for any kind of error messages
    Text{
        id: textArea
        anchors.topMargin: globalSettings.headerPortraiHeight
//        opacity: indicator.running || bookingsView.model && bookingsView.model.count > 0 ? 0:1
        height: opacity == 1? 600:0
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: globalSettings.colorGray
        font.pixelSize: globalSettings.largeFontSize
        font.family: globalSettings.defaultFontFamily
        font.weight: Font.DemiBold
        text: "Booking is supported in paid version only!"
        wrapMode: Text.Wrap
    }

    ToolBarLayout {
        id: bookingTools
        visible: true
        // vehicles
        ToolIcon {
            id:toolbarItemVehicle
            iconSource: "qrc:///images/vehicle.png"
            onClicked: {
                pageStack.clear()
                pageStack.push(vehiclesPage)
            }
        }
        // parking spots
        ToolIcon {
            id:toolbarItemParking
            iconSource:"qrc:///images/parking.png"
            onClicked: {
                pageStack.clear()
                pageStack.push(parkingsPage)
            }
        }
        // gas stations
        ToolIcon {
            id:toolbarItemGasstation
            iconSource:"qrc:///images/station.png"
            onClicked: {
                pageStack.clear()
                pageStack.push(gasstationsPage)
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

//    BusyIndicator {
//        id: indicator
//        anchors.centerIn: parent
//        platformStyle: BusyIndicatorStyle { size: "large" }
//        running: !model
//        opacity: running ? 1:0
//        Behavior on opacity { NumberAnimation { duration: 500; } }
//    }

    PageHeader {
        id: header
        title: "Bookings"
        icons: false
    }


}
