import QtQuick 1.1

MapItemContainer{
    id: wrapper
    property string largeSource
    property string defaultSource: "qrc:///images/poi-indicator.svg"
    property string source: defaultSource
    coordinateAnchors: cCoordinateAnchorHCenterBottom
    scaleWithZoom: false
    property int expandedWidth:  80
    property int expandedHeight:  80
    property int normalWidth: 48
    property int normalHeight: 48
    property int mapTopReservedMargin: 100

    z: orgZ+zBoost
    property int zBoost: 0
    property int orgZ

//    effectOffsetY: -200
//    Behavior on effectOffsetY { NumberAnimation { duration: 500; easing.type: Easing.OutElastic } }
    Behavior on height { NumberAnimation { duration: 500; easing.type: Easing.OutElastic } }

    property bool expanded: false

    signal clicked()

    Component.onCompleted: {
        originalWidth = normalWidth
        originalHeight = normalHeight
        width = normalWidth
        height = 0
        orgZ = z
    }

    onExpandedChanged: {
        if (expanded){
            expand()
        }
        else{
            shrink()
        }
    }

    opacity: 0
    offsetX: 0
    offsetY: 0
    Image{
        id: image
        asynchronous: true
        width: parent.width
        height: parent.height
        source: wrapper.source
        anchors.fill: parent
        smooth: true
        fillMode: Image.PreserveAspectFit
        MouseArea{
            anchors.fill: parent
            onClicked: {
                wrapper.clicked()
            }
        }
    }


    onInVisibleAreaChanged: {
       if (inVisibleArea){
         effectTimer.start()
       }
    }

    Timer{
        id: effectTimer
        interval: (Math.random()*5000)
        repeat: false
        onTriggered: {
            wrapper.opacity = 1
            height = normalHeight
//            wrapper.effectOffsetY = 0
        }
    }

    function expand(){
        // First move map so that expanded item fits to screen
        // Update, I want to move map till image in the center
        var dx =  0
        var dy =  0
        if((y-(expandedHeight-normalHeight)) < wrapper.mapTopReservedMargin){
            dy =  (y-(expandedHeight-normalHeight))-wrapper.mapTopReservedMargin
        }
        if((x - ((expandedWidth-normalWidth)/2)) < 0){
            dx = x - (expandedWidth/2 - normalWidth/2 - 25)
        }
        if( wrapper.map && (x+normalWidth + ((expandedWidth-normalWidth)/2)) > wrapper.map.parent.width){
            dx = -(wrapper.map.parent.width - (x + normalWidth + ((expandedWidth-normalWidth)/2)))
        }

        if( wrapper.map && (y+normalHeight + ((expandedHeight-normalHeight)/2)) > wrapper.map.parent.height){
            dy = -(wrapper.map.parent.height - (y + normalHeight + ((expandedHeight-normalHeight)/2)))
        }

        dx = Math.floor(dx)
        dy = Math.floor(dy)
        if ((dx != 0 || dy != 0) && wrapper.map ){
            wrapper.map.moveMap(dx,dy)
        }
        wrapper.source = wrapper.largeSource ? wrapper.largeSource : wrapper.defaultSource
        // Make expanding
        width = expandedWidth
        height = expandedHeight
        zBoost = 100
    }

    function shrink(){
        width = Math.ceil(originalWidth*zoomFactor(currentItemZoomLevel))
        height = Math.ceil(originalHeight*zoomFactor(currentItemZoomLevel))
        wrapper.source = wrapper.defaultSource
        zBoost = 0
    }
}
