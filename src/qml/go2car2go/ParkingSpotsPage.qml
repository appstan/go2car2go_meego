import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: wrapper
    tools: commonTools
    orientationLock: PageOrientation.LockPortrait

    property string name: "parking"
    property variant model
    property bool updateContent: false

    Component.onCompleted: {
        main.log("parkings page is created")
        if(main.pageStack.currentPage === wrapper){
            if (!model)
                car2goManager.getParkings()
        }
    }
    onStatusChanged: {
        if(wrapper.status == PageStatus.Activating && wrapper.updateContent){
            wrapper.updateContent = false
            car2goManager.getParkings()
        }
    }

    Connections{
        target:car2goManager

        onParkingspotsUpdated:{
            wrapper.model = parkingsModel
            parkingSpotsView.model = wrapper.model

            textArea.opacity = model && parkingsModel.count > 0 ? 0:1

        }
        onErrorOccured:{
            textArea.text = message
        }
    }

    //Delay network request till page is activated
    Connections{
        target:car2goSettings
        onCityChanged:{ wrapper.updateContent = true }
    }

    ListView{
        id: parkingSpotsView
        anchors.topMargin: globalSettings.headerPortraiHeight
        anchors.fill: parent
        delegate: ParkingSpotsDelegate{}
        cacheBuffer: parkingSpotsView.height
        clip: true
    }

    ScrollDecorator {
        flickableItem: parkingSpotsView
    }

    // placeholder for any kind of error messages
    Text{
        id: textArea
        anchors.topMargin: globalSettings.headerPortraiHeight
        opacity: indicator.running || parkingSpotsView.model && parkingSpotsView.model.count > 0 ? 0:1
        height: opacity == 1? 600:0
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: globalSettings.colorGray
        font.pixelSize: globalSettings.largeFontSize
        font.family: globalSettings.defaultFontFamily
        font.weight: Font.DemiBold
        text: "No parking spots"
        wrapMode: Text.Wrap
    }

    BusyIndicator {
        id: indicator
        anchors.centerIn: parent
        platformStyle: BusyIndicatorStyle { size: "large" }
        running: !model
        opacity: running ? 1:0
        Behavior on opacity { NumberAnimation { duration: 500; } }
    }

    PageHeader {
        id: header
        title: "Parkings"
        onMapIconClicked:  {
            main.playEffect()
            pageStack.push(main.openFile("ParkingSpotsMapPage.qml"), { model: wrapper.model})
        }
        onSettingsIconClicked: {
            main.playEffect()
            car2goManager.getLocations()
            pageStack.push( main.openFile("SettingsPage.qml"))
        }
    }

}
