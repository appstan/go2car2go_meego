import QtQuick 1.1
import com.nokia.meego 1.0

Dialog{
    id: dropdownMenu
    property int menuTopY:200
    property int menuHeight:540

    property alias model: locations.model
    platformStyle: DialogStyle { dim: 0.7 }

    function triggered() {
        if(status == DialogStatus.Open) {
            close();
        } else {
            if(true){
                console.log(locations.model.count)
                car2goManager.getLocations()
            }
            open();
        }
    }

    Rectangle{
        id: menuBackground

        radius:8
        color:"#cacbcc"
        height:  dropdownMenu.status != DialogStatus.Closed ? (dropdownMenu.menuHeight):50
        width: 300
        anchors.margins: 10
        anchors.right: parent.right
        y: dropdownMenu.menuTopY
        visible: dropdownMenu.status != DialogStatus.Closed

        Behavior on height {
            NumberAnimation {
                duration: 400
            }
        }

        Rectangle {
            radius:8
            anchors.margins: 20
            anchors.fill: parent
            border.width: 1
            border.color: "#b6b7b8"
            color: "#edeff4"
            ListView {
                id: locations
                anchors.fill: parent
                width: menuBackground.width
                clip: true
                model:locationsModel
                delegate:LocationsDelegate{}

            }
            ScrollDecorator {
                flickableItem: locations
            }

        }
    }
}

