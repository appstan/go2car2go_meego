import QtQuick 1.1

Component{
    id: parkingItem
    Item{
        id: itemWrapper
        width: list.width
        height: list.height


        Text{
            id:parkCapacity
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 4
            font.pixelSize:  globalSettings.mediumFontSize
            font.family:  globalSettings.defaultFontFamily
            font.weight: Font.Bold
            text:  "Parking total / used:" + total_capacity + " / " + used_capacity
            color: "black"
            elide: Text.ElideRight
            height: total_capacity && total_capacity.length > 0 ?font.pixelSize:0
        }
        Text{
            id:parkName
            anchors.top: parkCapacity.bottom
            anchors.left: parent.left
            anchors.margins: 4
            font.pixelSize:  globalSettings.mediumFontSize
            font.family:  globalSettings.defaultFontFamily
            font.weight: Font.DemiBold
            text:  park_name ? park_name : ""
            height: park_name && park_name.length > 0 ?font.pixelSize:0
            color:  "black"
            elide: Text.ElideRight
        }
        Text{
            id: distanceText
            anchors.top: parkName.bottom
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
//                main.playEffect()
                list.openDetails(index)
            }
        }
    }
}
