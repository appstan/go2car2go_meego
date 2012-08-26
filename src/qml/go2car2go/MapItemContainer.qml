import QtQuick 1.1
import QtMobility.location 1.2
Item {
    id:wrapper

    property variant map
    property real latitude
    property real longitude

    property variant mapSize: map.size

    property bool scaleWithZoom: true
    property int zoomLevel: map.zoomLevel
    property int minZoomLevel: 9
    property int defaultItemZoomLevel: 11
    property int currentItemZoomLevel: 11

    property int offsetX: 0
    property int offsetY: 0

    property int effectOffsetX: 0
    property int effectOffsetY: 0

    property int _anchorOffsetX: 0
    property int _anchorOffsetY: 0

    property int _x: 0
    property int _y: 0

    x: _x + _anchorOffsetX + offsetX + effectOffsetX
    y: _y + _anchorOffsetY + offsetY + effectOffsetY

    property int originalWidth
    property int originalHeight

    property int coordinateAnchors: cCoordinateAnchorCenter
    property int cCoordinateAnchorTopLeft: 0
    property int cCoordinateAnchorTopRight: 1
    property int cCoordinateAnchorBottomLeft: 2
    property int cCoordinateAnchorBottomRight: 3
    property int cCoordinateAnchorCenter: 4
    property int cCoordinateAnchorHCenterBottom: 5
    property int cCoordinateAnchorHCenterTop: 6
    property int cCoordinateAnchorVCenterLeft: 7
    property int cCoordinateAnchorVCenterRight: 8

    property variant mapItemClickedHandler
    signal clicked(variant clickedItem, bool exapandItem)

    // if changed then all items should go to default state
    property int toDefaultState: mapItemClickedHandler ? mapItemClickedHandler.itemsToDefaultState : 0


    property bool inVisibleArea: ((_x + _anchorOffsetX + offsetX) >= 0
                                  && (_x + _anchorOffsetX + offsetX) < mapSize.width
                                  &&  (_y + _anchorOffsetY + offsetY) >= 0
                                  &&  (_y + _anchorOffsetY + offsetY) < mapSize.height)


    property int mapCenterChanged:  map ? map.mapCenterChanged : 0
    onMapCenterChangedChanged: {
        contentUpdate()
    }

    Coordinate{
        id: coordinate
    }

    Component.onCompleted: {
        contentUpdate()
    }

    onMapSizeChanged:{
       contentUpdate()
    }

    onClicked: {
        main.playEffect()
        mapItemClickedHandler.itemClicked(clickedItem, exapandItem)
    }

    Connections{
       target:  map
       onMapMoved:{
           var point = map.toScreenPosition(coordinate)
           wrapper._x = point.x
           wrapper._y = point.y
       }
    }

    onZoomLevelChanged: {
        if (minZoomLevel<=zoomLevel){
            contentUpdate(zoomLevel)
        }
        else{
            contentUpdate(minZoomLevel)
        }
    }

    onLatitudeChanged: {
        coordinate.latitude = latitude
        contentUpdate()
    }
    onLongitudeChanged: {
        coordinate.longitude = longitude
        contentUpdate()
    }

    onCoordinateAnchorsChanged: {
        updatePos()
    }

    onWidthChanged: {
        updatePos()
    }
    onHeightChanged: {
        updatePos()
    }
    // coordinateAnchors defines how this item is anchored to given coordinates

    function updatePos(){
        switch(coordinateAnchors){
        case cCoordinateAnchorTopLeft:
            _anchorOffsetX = 0
            _anchorOffsetY = 0
            break;
        case cCoordinateAnchorTopRight:
             _anchorOffsetX = -width
             _anchorOffsetY = 0
            break;
        case cCoordinateAnchorBottomLeft:
             _anchorOffsetX = 0
            _anchorOffsetY = -height
            break;
        case cCoordinateAnchorBottomRight:
            _anchorOffsetY = -height
            _anchorOffsetX = -width
            break;
        case cCoordinateAnchorCenter:
            _anchorOffsetY = -height/2
            _anchorOffsetX = -width/2
            break;
        case cCoordinateAnchorHCenterBottom:
            _anchorOffsetY = -height
            _anchorOffsetX = -width/2
            break;
        case cCoordinateAnchgorHCenterTop:
            _anchorOffsetY = 0
            _anchorOffsetX = -width/2
            break;
        case cCoordinateAnchorVCenterLeft:
            _anchorOffsetY = -height/2
            _anchorOffsetX = 0
            break;
        case cCoordinateAnchorVCenterRight:
            _anchorOffsetY = -height/2
            _anchorOffsetX = -width
            break;
        default:
            main.log("Unknown coordinate anchors value: " + coordinateAnchors)
            break;
        }
    }

    function contentUpdate(aZoom){
        if (!coordinate.latitude){
            coordinate.latitude = latitude
        }
        if (!coordinate.longitude ){
            coordinate.longitude = longitude
        }

        if (!originalWidth){
            originalWidth = width
            width = Math.ceil(originalWidth*zoomFactor(zoomLevel))
        }
        if (!originalHeight){
            originalHeight = height
            height = Math.ceil(originalHeight*zoomFactor(zoomLevel))
        }
        if (map){
            var point = map.toScreenPosition(coordinate)
            _x = point.x
            _y = point.y
        }
        if (scaleWithZoom && aZoom && currentItemZoomLevel != aZoom ){
            width = Math.ceil(originalWidth*zoomFactor(aZoom))
            height = Math.ceil(originalHeight*zoomFactor(aZoom))
            currentItemZoomLevel = aZoom
        }
       // updatePos()
    }

    function zoomFactor(aZoomLevel){
        if (minZoomLevel<=aZoomLevel){
            return aZoomLevel/defaultItemZoomLevel
        }
        else{
             return minZoomLevel/defaultItemZoomLevel
        }
    }
}
