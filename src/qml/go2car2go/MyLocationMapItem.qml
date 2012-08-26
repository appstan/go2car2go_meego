
import QtQuick 1.0

MapItemContainer{
    id: wrapper
    property string source
    coordinateAnchors: cCoordinateAnchorCenter
    scaleWithZoom: false
    property bool validCoordinate: true
    onValidCoordinateChanged: {
        if (validCoordinate){
            loactionImage.width = 80
        }
        else{
            loactionImage.width = 170
        }
    }

    Component.onCompleted: {
        if (validCoordinate){
            loactionImage.width = 80
        }
    }

    Timer{
       id: effectTimer
       interval: 1*1000
       repeat: true
       running: !wrapper.validCoordinate
       triggeredOnStart: true
       onTriggered: {
           if (loactionImage.width == 170){
               loactionImage.width = 80
           }
           else{
               loactionImage.width = 170
           }
       }
    }

    z: 250
    opacity: 0.9
    Image{
        id: loactionImage
        fillMode: Image.PreserveAspectFit
        Behavior on width { NumberAnimation { duration: 1000; easing.type: Easing.OutBounce } }
        source: wrapper.source
        anchors.centerIn: parent
        width: 170
        smooth:  true
        sourceSize.width: 170
        sourceSize.height: 170
    }
}
