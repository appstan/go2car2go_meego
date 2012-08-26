import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: wrapper
    tools: commonTools
    orientationLock: PageOrientation.LockPortrait

    property string name: "gasstation"
    property variant model
    property bool updateContent: false

    Component.onCompleted: {
        main.log("gas stations page is created")
    }

    onStatusChanged: {
        if(wrapper.status == PageStatus.Activating && wrapper.updateContent){
            wrapper.updateContent = false
            car2goManager.getGasStations()
        }
    }

    Connections{
        target:car2goManager

        onGasstationsUpdated:{
            wrapper.model = gasstationsModel
            gasStationsView.model = wrapper.model

            textArea.opacity = model && gasstationsModel.count > 0 ? 0:1
        }
        onErrorOccured:{
            textArea.text = message
        }
    }
    // Delay network request till page is activated
    Connections{
        target:car2goSettings
        onCityChanged: { wrapper.updateContent = true }
    }

    ListView{
        id: gasStationsView
        anchors.fill: parent
        anchors.topMargin: globalSettings.headerPortraiHeight
        delegate: GasStationsDelegate{}
        cacheBuffer: gasStationsView.height
        clip: true
    }

    ScrollDecorator {
        flickableItem: gasStationsView
    }

    // placeholder for any kind of error messages
    Text{
        id: textArea
        anchors.topMargin: globalSettings.headerPortraiHeight
        height: opacity == 1? 600:0
        width: parent.width - 30
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: globalSettings.colorGray
        font.pixelSize: globalSettings.megaLargeFontSize
        font.family: globalSettings.defaultFontFamily
        font.weight: Font.DemiBold
        text: "No gas stations"
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
        title: "Gas Stations"
        onMapIconClicked:  {
            main.playEffect()
            pageStack.push(main.openFile("GasStationsMapPage.qml"), { model: wrapper.model})
        }
        onSettingsIconClicked: {
            main.playEffect()
            car2goManager.getLocations()
            pageStack.push( main.openFile("SettingsPage.qml"))
        }
    }

}
