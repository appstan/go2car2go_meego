import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id: wrapper
    tools: commonTools
    orientationLock: PageOrientation.LockPortrait

    property string name: "vehicle"
    property variant model
    property bool updateContent: false

    Component.onCompleted: {
        main.log("vehicles page is created")
    }

    onStatusChanged: {
        if(wrapper.status == PageStatus.Activating && wrapper.updateContent){
            wrapper.updateContent = false
            car2goManager.getVehicles()
        }
    }

    Connections{
        target:car2goManager

        onVehiclesUpdated:{
            wrapper.model = vehiclesModel
            vehiclesView.model = wrapper.model

            textArea.opacity = model && vehiclesModel.count > 0 ? 0:1
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
        id: vehiclesView
        anchors.fill: parent
        anchors.topMargin: globalSettings.headerPortraiHeight
        delegate: VehiclesDelegate{}
        clip: true
        opacity: model && model.count > 0 ? 1:0
    }

    ScrollDecorator {
        flickableItem: vehiclesView
    }

    //
    Text{
        id: textArea
        anchors.topMargin: globalSettings.headerPortraiHeight
        opacity: indicator.running || vehiclesView.model && vehiclesView.model.count > 0 ? 0:1
        height: opacity == 1? 600:0
        width: parent.width - 30
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: globalSettings.colorGray
        font.pixelSize: globalSettings.megaLargeFontSize
        font.family: globalSettings.defaultFontFamily
        font.weight: Font.DemiBold
        text: "No vehicles"
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
        title: 'Vehicles'
        onMapIconClicked:  {
            main.playEffect()
            pageStack.push(main.openFile("VehiclesMapPage.qml"), { model: vehiclesView.model})
        }
        onSettingsIconClicked: {
            main.playEffect()
            pageStack.push( main.openFile("SettingsPage.qml"))
        }

    }

}
