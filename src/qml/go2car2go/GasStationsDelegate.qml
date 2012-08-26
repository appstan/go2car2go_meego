import Qt 4.7

Component{
    id: gasstationsDelegate
    Item{
        id: wrapper

        width: globalSettings.pageWidth
        height:  childrenRect.height

        MouseArea{
            anchors.fill: parent
            onClicked: {
                main.playEffect()
                main.itemName = getGasStationName(gasstation_name)
                main.itemAddress = getGasStationAddress(gasstation_name)
                main.itemDistance = distance
                main.itemLatitude = lati
                main.itemLongitude = longi
                main.itemClicked()
            }
        }

        function getGasStationName(string){
            var text = string.split(",")
            if (text[1]){
                return text[0]
            } else {
                return ""
            }
        }

        function getGasStationAddress(string){
            var text = string.split(",")
            if (text[1]){
                return text[1]
            } else {
                return string
            }
        }

        HorizontalDivider { width: parent.width; margin: 5 }

        //STATION NAME
        Text{
            id: space
            anchors.left: parent.left
            anchors.top:  parent.top
            anchors.margins: globalSettings.largeMargin
            color: globalSettings.colorBlack
            text: getGasStationName(gasstation_name)
            elide: Text.ElideRight
            wrapMode: Text.Wrap
            font.family:globalSettings.defaultFontFamily
            font.pixelSize: globalSettings.bigFontSize
        }
        //STATION ADDRESS
        Text{
            id: car2goAddress
            color:  space.text == "" ? globalSettings.colorBlack : globalSettings.colorOrange
            text: getGasStationAddress(gasstation_name)
            width: parent.width - 40
            anchors.right: parent.right
            anchors.top:   space.bottom
            anchors.margins: globalSettings.extraLargeMargin
            elide: Text.ElideRight
            wrapMode: Text.Wrap
            font.weight: Font.DemiBold
            font.family:globalSettings.defaultFontFamily
            font.pixelSize: space.text == "" ? globalSettings.bigFontSize : globalSettings.mediumFontSize
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
