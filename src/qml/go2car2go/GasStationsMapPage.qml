import QtQuick 1.1
import QtMobility.location 1.2
import com.nokia.meego 1.0


Page{
    id:wrapper
    tools: mapTools


    property variant model

    property real presetLatitude: NaN
    property real presetLongitude: NaN

    function setLocation (latitude, longitude , haccuracy, direction)  {
        wrapper.presetLatitude = latitude;
        wrapper.presetLongitude = longitude;
        geoCoord.latitude = wrapper.presetLatitude;
        geoCoord.longitude = wrapper.presetLongitude;
        pin.coordinate = geoCoord;
    }

    ListModel{
        id:mapModel
    }

    function filteredModel(){
        if(mapModel){
            mapModel.clear();
        }

        var limit = 15;
        if (limit > wrapper.model.count){
            limit =  wrapper.model.count;
        }

        for (var index = 0; index < limit; index++){

            var item = wrapper.model.get(index);

            mapModel.append({"distance": item.distance,
                                "gasstation_name": item.gasstation_name,
                                "lati":item.lati,
                                "longi":item.longi
                            });

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

   Component.onCompleted: {
      // filteredModel()
   }

    Connections{
        target: car2goManager

        onPositionChanged: {
            setLocation(latitude, longitude , direction);
            // update map model with new items
            filteredModel()
        }
    }
    focus : true

    Coordinate {
        id: geoCoord
    }

    MapImage{
        id:pin
        source:"qrc:///images/orange_dot_circle.png"
    }

    Car2GoMap{
       id: car2goMap
       clip: true
       interactive: true
       height:  wrapper.height
       width: wrapper.width
       defaultZoom: 13
       currentLatitude:!wrapper.presetLocation ? main.user.currentLatitude : wrapper.presetLatitude
       currentLongitude:!wrapper.presetLocation ? main.user.currentLongitude : wrapper.presetLongitude
       anchors.bottom:  mapTools.top
       anchors.fill:  parent
       onMapClicked: {
           mapItemList.selectItem(-1)
           mapItemList.opacity = 0
       }
       onMapLocationChanged:{
           if (wrapper.model && wrapper.model.reloadOnMapLoactionChange && mapItemList.opacity == 0){
               wrapper.model.mapLocationChanged( aLatitude, aLongitude)
           }
       }
       Repeater{
          id: placesRepeater
          model: mapModel
          Car2GoMapItem {
              defaultSource: "qrc:///images/poi-gasoline.svg"
              map:  car2goMap.mapElement
              latitude: lati ? lati : 0
              longitude: longi ? longi : 0
              expanded: index == car2goMap.selectedItemIndex
              onClicked: {
//                  main.playEffect()
                  mapItemList.selectItem(index)
                  mapItemList.opacity = 1
              }
          }
       }
       MapItemList{
           id: mapItemList
           anchors.top: parent.top
           anchors.right: parent.right
           anchors.left: parent.left
           opacity:  0
           z:car2goMap.z + 2

           height: 120
           model: mapModel
           delegate: GasStationMapItemListItem{}

           onSelectedItemChanged: {
               car2goMap.selectedItemIndex = index
           }
           onShowCurrentItemOnMapCenter: {
               var temmpi = model.get(index)
               car2goMap.setCenter(temmpi.lati, temmpi.longi)
           }

           onOpenDetails: {
               var clickedItem = model.get(index)
               if ( clickedItem ){
                   main.itemName = getGasStationName(clickedItem.gasstation_name)
                   main.itemAddress = getGasStationAddress(clickedItem.gasstation_name)
                   main.itemDistance = clickedItem.distance
                   main.itemLatitude = clickedItem.lati
                   main.itemLongitude = clickedItem.longi
                   main.itemClicked()
               }

           }
       }

    }
    BusyIndicator {
        id: indicator
        anchors.centerIn: parent
        platformStyle: BusyIndicatorStyle { size: "large" }
        running: !model || mapModel.count < 0
        opacity: running ? 1:0
        Behavior on opacity { NumberAnimation { duration: 500; } }
    }

    ToolBarLayout {
        id: mapTools
        ToolIcon {
            platformIconId: "toolbar-back"
            anchors.left: (parent === undefined) ? undefined : parent.left
            onClicked: pageStack.pop()
        }
        ToolIcon {
            id: mapToolbarCenter
            iconSource: "qrc:///images/black_dot_circle.png"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked:{
                if(userCurrentLocation.longitude && userCurrentLocation.latitude){
                    car2goMap.setCenter(userCurrentLocation.latitude, userCurrentLocation.longitude )}
                }
            }
        }
    }

