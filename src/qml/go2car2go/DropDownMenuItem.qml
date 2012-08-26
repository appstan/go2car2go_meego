import QtQuick 1.1

Item {
    id: menuItem
    property alias iconText: textItem.text
    property alias iconVisible:ticked.visible

    signal clicked
    Item {
        id: mainItem
        height:100
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: ticked.left
        HorizontalDivider {
            width: parent.width - 30
            anchors.leftMargin: 20
            anchors.rightMargin: 20
        }
        Text {
            id: textItem
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 20
            anchors.left: parent.left
            anchors.right: parent.right
            font.family: globalSettings.defaultFontFamily
            font.weight: Font.Light
            font.pixelSize:globalSettings.bigFontSize
            text: ""
        }
    }
    Image {
        id:ticked
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 24
        width: sourceSize.width
        height: sourceSize.height
        visible: false
        source: "qrc:///images/selected.svg"
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            main.playEffect()
            menuItem.clicked();
        }
    }
}
