import Qt 4.7

Component{
    id: vehiclesDelegate
    Item{
        id: wrapper

        width: globalSettings.pageWidth
        height:  childrenRect.height


        MouseArea{
            anchors.fill: parent
            onClicked: {
                main.playEffect()
                main.itemName = getParkingSpotName(park_name)
                main.itemInterior = '<b>Free Spots: </b> ' + (  total_capacity > used_capacity ? total_capacity - used_capacity : 0 )
                main.itemExterior = '<b>Total Capacity: </b> ' + total_capacity
                main.itemFuel = '<b>Charging pole : </b>' + ( charging_pole ? "Yes" : "No" )
                main.itemAddress = getParkingSpotAddress(park_name)
                main.itemDistance = distance
                main.itemLatitude = lati
                main.itemLongitude = longi
                main.itemClicked()
            }
        }

        function getParkingSpotName(string){
            var text = string.split(",")
            if (text[1]){
                return text[0]
            } else {
                return ""
            }
        }

        function getParkingSpotAddress(string){
            var text = string.split(",")
            if (text[1] && text[2]){
                return text[1] + ', ' + text[2]
            } else if(text[1]){
                return text[1]
            } else {
                return string
            }
        }

        HorizontalDivider { width: parent.width; margin: 5 }
        //PARKING SPOT NAME
        Text{
            id: space
            anchors.left: parent.left
            anchors.top:  parent.top
            anchors.margins: globalSettings.largeMargin
            color: globalSettings.colorBlack
            text: getParkingSpotName(park_name)
            elide: Text.ElideRight
            wrapMode: Text.Wrap
            font.family:globalSettings.defaultFontFamily
            font.pixelSize: globalSettings.mediumFontSize
            height: space.text == "" ? 0 : globalSettings.bigFontSize
        }
        //FREE PARKING SPOTS
        Text{
            id: capacityFree
            anchors.right: parent.right
            anchors.top:  space.bottom
            anchors.margins:globalSettings.smallMargin
            color: globalSettings.colorBlack
            text: '<b>Free Spots: </b> ' + (  total_capacity > used_capacity ? total_capacity - used_capacity : 0 )
            elide: Text.ElideRight
            width: parent.width - 40
            wrapMode: Text.Wrap
            font.family:globalSettings.defaultFontFamily
            font.pixelSize: globalSettings.normalFontSize
        }

        Text{
            id: capacityTotal
            anchors.right: parent.right
            anchors.top:  capacityFree.bottom
            anchors.margins: globalSettings.smallMargin
            color: globalSettings.colorBlack
            text: '<b>Total Capacity: </b> ' + total_capacity
            elide: Text.ElideRight
            width: parent.width - 40
            wrapMode: Text.Wrap
            font.family:globalSettings.defaultFontFamily
            font.pixelSize: globalSettings.normalFontSize
        }

        Text{
            id: chargingPole
            anchors.right: parent.right
            anchors.top:  capacityTotal.bottom
            anchors.margins: globalSettings.smallMargin
            color: globalSettings.colorBlack
            text: '<b>Charging pole : </b>' + ( charging_pole ? "Yes" : "No" )
            elide: Text.ElideRight
            width: parent.width - 40
            wrapMode: Text.Wrap
            font.family:globalSettings.defaultFontFamily
            font.pixelSize: globalSettings.normalFontSize
        }

       //ADDRESS
        Text{
            id: address
            anchors.left: parent.left
            anchors.top:  chargingPole.bottom
            anchors.margins: globalSettings.smallMargin
            anchors.leftMargin: globalSettings.extraLargeMargin
            color: globalSettings.colorOrange
            text: getParkingSpotAddress(park_name)
            elide: Text.ElideRight
            width: parent.width - 40
            wrapMode: Text.Wrap
            font.weight: Font.DemiBold
            font.family:globalSettings.defaultFontFamily
            font.pixelSize: globalSettings.mediumFontSize
        }

        // corner rounded box for distance display
        Rectangle{
            id: distanceBackground
            color: globalSettings.distanceBoxBackgroundColor
            width: car2goDistance.width + 15
            height: 30
            radius: 7
            anchors.topMargin : globalSettings.largeMargin
            anchors.bottomMargin : globalSettings.hugeMargin
            anchors.rightMargin : globalSettings.largeMargin
            anchors.top:  parent.top
            anchors.right: parent.right
            opacity: car2goDistance.text.length > 0 ? 1 : 0


            Text{
                id: car2goDistance
                color: globalSettings.colorWhite
                text: globalSettings.locateDistance(distance, main.unitMetric)
                elide: Text.ElideRight
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.family :globalSettings.defaultFontFamily
                font.pixelSize: 18
            }

        }
    }
}
