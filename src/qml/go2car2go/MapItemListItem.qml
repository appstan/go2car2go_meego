import QtQuick 1.1

Component{
    id: placeItem
    Item{
        id: itemWrapper
        width: list.width
        height: list.height
        property bool special: false


        Text{
            id:vehiclePlateNumber
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 4
            font.pixelSize:  globalSettings.mediumFontSize
            font.family:  globalSettings.defaultFontFamily
            font.weight: Font.Bold
            text:  plate_number ? plate_number : ""
            color: "black"
            elide: Text.ElideRight
            height: plate_number && plate_number.length > 0 ?font.pixelSize:0
        }
        Text{
            id:streetName
            anchors.top: vehiclePlateNumber.bottom
            anchors.left: parent.left
            anchors.margins: 4
            font.pixelSize:  globalSettings.mediumFontSize
            font.family:  globalSettings.defaultFontFamily
            font.weight: Font.DemiBold
            text:  address ? address : ""
            height: address && address.length > 0 ?font.pixelSize:0
            color:  "black"
            elide: Text.ElideRight
        }
        Text{
            id: distanceText
            anchors.top: streetName.bottom
            anchors.left: parent.left
            anchors.margins: 4
            anchors.topMargin: 6
            font.pixelSize:  globalSettings.smallFontSize
            font.family:  globalSettings.defaultFontFamily
            font.weight: Font.Light
            text:  globalSettings.locateDistance(distance, main.unitMetric)
            color: globalSettings.colorOrange
        }
        MouseArea{
            anchors.fill:  parent
            onClicked: {
                main.playEffect()
                list.openDetails(index)
            }
        }
    }
}
