import QtQuick 1.1
import QtMobility.location 1.2

Item {
    id: wrapper
    width: 600
    height: 600

    property variant currentLatitude: NaN
    property variant currentLongitude: NaN

    property variant validCurrentPosition: true

    property bool enableZoom: interactive
    property bool enablePan: interactive
    property bool interactive:  true
    property bool mapPanned: false

    property bool followMyLocation: true
    property bool enableMyLocation: true
    property string myLocationImage: "qrc:///images/position.svg"

    property bool reversePinchZoom: false
    property int minMapZoom: 2
    property int maxMapZoom: 20
    property int defaultZoom: 12
    function setZoom( aZoom ){
        mapArea.zoomLevel = aZoom
    }

    property int itemsToDefaultState: 0
    signal itemClicked(variant clickedItem, bool expandItem)
    signal mapClicked()

    property int selectedItemIndex: -1
    property bool showBorderImage: true

    property variant mapElement:  mapArea

    signal mapLocationChanged(real aLatitude, real aLongitude)

    function setCenter(aLatitude, aLongitude){
        if (!mapArea.center){
            mapArea.center = Qt.createQmlObject( "import QtQuick 1.1; import QtMobility.location 1.2; Coordinate{ latitude:" +aLatitude + ";longitude:" +aLongitude + "}" , wrapper, "dynamicSnippet1" )
        }
        mapArea.center.latitude = aLatitude
        mapArea.center.longitude = aLongitude
        mapArea.mapCenterChanged++
        mapLocationChanged(aLatitude,aLongitude)
    }

    function setMapZoom (zoom)  {
        mapArea.zoomLevel = zoom;
    }

    function zoomOut() {
        if (mapArea.zoomLevel > mapArea.minimumZoomLevel + 1)
            setMapZoom(mapArea.zoomLevel - 1)
    }

    onCurrentLatitudeChanged:{
        if ( currentLatitude && currentLongitude && validCurrentPosition ){
            if (followMyLocation){
                mapArea.center = Qt.createQmlObject( "import QtQuick 1.1; import QtMobility.location 1.2; Coordinate{ latitude:" +currentLatitude + ";longitude:" +currentLongitude + "}" , wrapper, "dynamicSnippet1" )
                mapLocationChanged(currentLatitude,currentLongitude)
            }
        }
        if ( enableMyLocation ){
            myLocationItem.latitude = currentLatitude
        }
    }

    onCurrentLongitudeChanged:{
        if ( currentLatitude && currentLongitude && validCurrentPosition ){
            if (followMyLocation){
                mapArea.center = Qt.createQmlObject( "import QtQuick 1.1; import QtMobility.location 1.2; Coordinate{ latitude:" +currentLatitude + ";longitude:" +currentLongitude + "}" , wrapper, "dynamicSnippet1" )
               mapLocationChanged(currentLatitude,currentLongitude)
            }
        }
        if ( enableMyLocation ){
            myLocationItem.longitude = currentLongitude
        }
    }

    Component.onCompleted:{
        if ( currentLatitude && currentLongitude && validCurrentPosition ){
            if (followMyLocation){
                mapArea.center = Qt.createQmlObject( "import QtQuick 1.1; import QtMobility.location 1.2; Coordinate{ latitude:" +currentLatitude + ";longitude:" +currentLongitude + "}" , wrapper, "dynamicSnippet1" )
            }
            if ( enableMyLocation ){
                myLocationItem.longitude = currentLongitude
                myLocationItem.latitude = currentLatitude
            }
        }
    }

    Map {
        id: mapArea
        connectivityMode: Map.HybridMode
        plugin : Plugin { name : "nokia" }
        anchors.fill: parent
        size.width: parent.width
        size.height: parent.height
        zoomLevel: wrapper.defaultZoom

        property int mapCenterChanged:  0

        function itemSelection( model ){
            itemSelectionList.opacity = 1
            itemSelectionList.model = model
        }

        signal mapMoved()

        function moveMap(aDx, aDy){
            var dx = aDx
            var dy = aDy
            center = mapArea.toCoordinate(Qt.point( dx+ parent.width/2, dy+parent.height/2))
            dragUpdate(dx,dy)
            if (center){
                wrapper.mapLocationChanged(center.latitude,center.longitude)
            }
        }

        function dragUpdate(aX,aY){
            if (center){
                wrapper.mapLocationChanged(center.latitude,center.longitude)
            }
            mapMoved()
        }
        function centeringUpdate(aX,aY){
            if (center){
                wrapper.mapLocationChanged(center.latitude,center.longitude)
            }
            mapMoved()
        }
    }

    PinchArea {
        anchors.fill: parent
        enabled:  wrapper.enableZoom
        property double __oldZoom
        property double __orgCenterX
        property double __orgCenterY
        property variant __pinchCenterCoordinate
        onPinchStarted:{
            __oldZoom = mapArea.zoomLevel
           // __prevScale = pinch.scale
            __orgCenterX = pinch.center.x
            __orgCenterY = pinch.center.y
            __pinchCenterCoordinate = mapArea.toCoordinate(Qt.point( pinch.center.x, pinch.center.y))
        }

        function calcZoom(zoom, percent) {
           if (reversePinchZoom){
              return zoom - Math.log(percent)/Math.log(1.5)
           }
           else{
            return zoom + Math.log(percent)/Math.log(1.5)
           }
        }

        function reverseScaleForZoomLevel( aOldZoom, aZoom ){
            return Math.exp((aZoom - aOldZoom)*Math.log(1.5))
        }

        function doPinchPan(){
            var point = mapArea.toScreenPosition ( __pinchCenterCoordinate )
            var dX = point.x - __orgCenterX
            var dY = point.y - __orgCenterY
            mapArea.pan(dX,dY)
            mapArea.dragUpdate(dX,dY)
        }

        onPinchUpdated: {
            var pinch_scale = pinch.scale
            var mapZoom = calcZoom(__oldZoom, pinch_scale)
            if (mapZoom < minMapZoom){
                mapArea.zoomLevel  = minMapZoom
            }
            else if(mapZoom > maxMapZoom){
                mapArea.zoomLevel  = maxMapZoom
            }
            else{
                mapArea.zoomLevel  = mapZoom
            }
        }

        onPinchFinished: {
            //map.zoomLevel = calcZoom(__oldZoom, pinch.scale)
            var pinch_scale = pinch.scale
            var mapZoom = calcZoom(__oldZoom, pinch_scale)
            if (mapZoom < minMapZoom){
                mapArea.zoomLevel  = minMapZoom
            }
            else if(mapZoom > maxMapZoom){
                mapArea.zoomLevel  = maxMapZoom
            }
            else{
                mapArea.zoomLevel  = mapZoom
            }
            doPinchPan()
        }
    }


    MouseArea{
        id: dragArea
        anchors.fill:  parent
        property bool mouseDown : false

        enabled: wrapper.enablePan

        drag.axis: Drag.XandYAxis;
        drag.minimumX: 0;

        drag.maximumX: mapArea.width
        drag.minimumY: 0;
        drag.maximumY: mapArea.height

        property int centerX: width/2
        property int centerY: height/2
        property int prevX: centerX
        property int prevY: centerY
        onPressed: {
            mouseDown = true
            prevX = mouse.x
            prevY = mouse.y
        }
        onReleased : {
            mouseDown = false
            prevX = -1
            prevY = -1
            mapPanned = true
        }
        onPositionChanged: {
            if (mouseDown) {

                var dx = prevX-mouse.x
                var dy = prevY-mouse.y

                mapArea.pan(dx,dy)
                prevX = mouse.x
                prevY = mouse.y
                // User started to pan so we don't center to user anymore
                wrapper.followMyLocation = false
                mapArea.dragUpdate(dx,dy)
            }
        }

        onClicked: {
            wrapper.mapClicked()
        }

        onDoubleClicked: {
            mapArea.center = mapArea.toCoordinate(Qt.point(mouse.x, mouse.y))

            if (mapArea.zoomLevel < mapArea.maximumZoomLevel)
                mapArea.zoomLevel += 1
        }
    }

    MyLocationMapItem{
        id: myLocationItem
        map:  mapArea
        z: mapArea.z + 1
        visible:  wrapper.enableMyLocation
        width:80
        height:80
        source:  wrapper.myLocationImage
        mapItemClickedHandler: wrapper
        latitude: map.currentLatitude ? map.currentLatitude : NaN
        longitude: map.currentLongitude ? map.currentLongitude : NaN
    }





    onItemClicked: {
        wrapper.itemsToDefaultState++
    }
}

