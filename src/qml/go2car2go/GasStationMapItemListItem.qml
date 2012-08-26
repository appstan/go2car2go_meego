import QtQuick 1.1

Component{
    id: gasstationItem
    Item{
        id: itemWrapper
        width: list.width
        height: list.height


        Text{
            id:stationName
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 4
            font.pixelSize:  globalSettings.mediumFontSize
            font.family:  globalSettings.defaultFontFamily
            font.weight: Font.DemiBold
            text:  gasstation_name ? gasstation_name : ""
            height: gasstation_name && gasstation_name.length > 0 ?font.pixelSize:0
            color:  "black"
            elide: Text.ElideRight
        }
        Text{
            id: distanceText
            anchors.top: stationName.bottom
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
