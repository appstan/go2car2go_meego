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
                main.itemName = plate_number
                main.itemInterior = '<b>Interior: </b> ' + interior
                main.itemExterior =  '<b>Exterior: </b> ' + exterior
                main.itemFuel = '<b>Fuel: </b> ' + fuel + ' % '
                main.itemAddress = address
                main.itemDistance = distance
                main.itemLatitude = lati
                main.itemLongitude = longi
                main.itemClicked()
            }
        }

        HorizontalDivider { width: parent.width; margin: 5 }
        //PLATE NUMBER
        Text{
            id: car2goPlateNr
            anchors.left: parent.left
            anchors.top:  parent.top
            anchors.margins: globalSettings.largeMargin
            color: globalSettings.colorBlack
            font.family: globalSettings.defaultFontFamily
            font.pixelSize: globalSettings.bigFontSize
            text: plate_number
            elide: Text.ElideRight
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
        //INTERIOR
        Text{
            id: car2goInterior
            anchors.right: parent.right
            anchors.top:  car2goPlateNr.bottom
            anchors.margins: globalSettings.smallMargin
            color: globalSettings.colorBlack
            text: '<b>Interior: </b> ' + interior
            elide: Text.ElideRight
            width: parent.width - 40
            wrapMode: Text.Wrap
            font.family:globalSettings.defaultFontFamily
            font.pixelSize: globalSettings.normalFontSize
        }
        //EXTERIOR
        Text{
            id: car2goExterior
            anchors.right: parent.right
            anchors.top:  car2goInterior.bottom
            anchors.margins: globalSettings.smallMargin
            color: globalSettings.colorBlack
            text: '<b>Exterior: </b> ' + exterior
            elide: Text.ElideRight
            width: parent.width - 40
            wrapMode: Text.Wrap
            font.family:globalSettings.defaultFontFamily
            font.pixelSize: globalSettings.normalFontSize
        }
        //FUEL
        Text{
            id: car2goFuel
            anchors.right: parent.right
            anchors.top:  car2goExterior.bottom
            color: globalSettings.colorBlack
            text: '<b>Fuel: </b> ' + fuel + ' % '
            elide: Text.ElideRight
            width: parent.width - 40
            wrapMode: Text.Wrap
            anchors.margins: globalSettings.smallMargin
            font.family:globalSettings.defaultFontFamily
            font.pixelSize: globalSettings.normalFontSize
        }
        //ADDRESS
        Text{
            id: car2goAddress
            anchors.right: parent.right
            anchors.top:  car2goFuel.bottom
            anchors.margins: globalSettings.smallMargin
            color: globalSettings.colorOrange
            text: address
            elide: Text.ElideRight
            width: parent.width - 40
            wrapMode: Text.Wrap
            font.weight: Font.DemiBold
            font.family:globalSettings.defaultFontFamily
            font.pixelSize: globalSettings.mediumFontSize
            anchors.bottomMargin: globalSettings.extraLargeMargin
        }

    }
}
