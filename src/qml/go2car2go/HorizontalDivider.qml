// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    width: 100
    height: 2
    opacity:  0.9
    property int margin

    Item{
        height: 2
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        Rectangle{
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.rightMargin: margin ? margin : 0
            anchors.leftMargin: margin ? margin : 0
            height: 1
            color:  "#cecfce"
            opacity: 1
        }
        Rectangle{
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.rightMargin: margin ? margin : 0
            anchors.leftMargin: margin ? margin : 0
            height: 1
            color:  "white"
        }
    }
}
