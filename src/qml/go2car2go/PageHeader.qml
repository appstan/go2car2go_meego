
import QtQuick 1.1
import com.nokia.meego 1.0

Rectangle {
    property alias title: heading.text
    property bool icons: true
    property bool orientation: screen.currentOrientation === Screen.Landscape

    signal mapIconClicked
    signal settingsIconClicked


    color: globalSettings.headerBackgroundColor
    height: orientation ? globalSettings.headerLandscapeHeight : globalSettings.headerPortraiHeight
    width: parent.width

    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.topMargin: -parent.anchors.topMargin
    anchors.leftMargin: -parent.anchors.leftMargin
    anchors.rightMargin: -parent.anchors.rightMargin


    CustomIcon {
        id:settingsIcon
        iconSource: "qrc:///images/settings.png"
        anchors.left: parent.left
        visible: icons
    }

    BorderImage {
        anchors.left: parent.left
        anchors.leftMargin: 80
        height: parent.height
        width: 1
        source: "qrc:///images/separator-vertical.png"
        visible: icons
    }

    Text {
        id: heading
        color: globalSettings.headerTextColor
        font.family: globalSettings.defaultFontFamily
        font.pixelSize: globalSettings.megaLargeFontSize
        anchors.topMargin: orientation ? globalSettings.largeMargin : globalSettings.hugeMargin
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        width: parent.width
        height: parent.height
    }

    BorderImage {
        anchors.right: parent.right
        anchors.rightMargin: 80
        height: parent.height
        width: 1
        visible: icons
        source: "qrc:///images/separator-vertical.png"
    }

    CustomIcon {
        id:mapIcon
        iconSource: "qrc:///images/map.png"
        anchors.right: parent.right
        visible: icons
    }


    Component.onCompleted: {
        mapIcon.clicked.connect(mapIconClicked)
        settingsIcon.clicked.connect(settingsIconClicked)
    }

    Image{
        id: shadow
        height: 4
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.bottom
        source: "qrc:///images/shadow.png"
    }

}
