import QtQuick 1.1

Component{
    id: listItem

    Item{
        id: wrapper

        width: parent.width
        height:  childrenRect.height

        function printMe(text){
            console.log(text)
            return text
        }

        Item {
            id: mainItem
            height:150
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: ticked.left
            HorizontalDivider { width: locations.width ; margin: 10}

            Text {
                id: textItem
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 20
                anchors.topMargin: 20
                anchors.bottomMargin: 20
                anchors.left: parent.left
                anchors.right: parent.right
                font.family: globalSettings.defaultFontFamily
                font.weight: Font.Light
                font.pixelSize:globalSettings.largeFontSize
                text: printMe(location_name)
            }

        }
        Image {
            id:ticked
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 24
            width: sourceSize.width
            height: sourceSize.height
            visible: textItem.text == locationItem.text
            source: "qrc:///images/selected.svg"
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                main.playEffect()
                locationItem.text = location_name
                dropdownMenu.triggered()
            }
        }
    }
}
