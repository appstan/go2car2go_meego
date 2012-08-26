import QtQuick 1.1

Item {
    id: wrapper
    width: 500
    height: 120

    property variant model: 0
    property variant delegate

    signal selectedItemChanged(int index)
    signal showCurrentItemOnMapCenter(int index)
    signal openDetails(int index)

    function selectItem(aIndex){
        //If the user clicks the item for the second time, open dialog
        if (aIndex == list.currentIndex ){
            openDetails(aIndex);
        }
        list.currentIndex = aIndex
        // avoid list scroll animation
        list.positionViewAtIndex(aIndex, ListView.Contain)
    }

    Behavior on opacity { NumberAnimation { duration: 200;  } }
    Rectangle{
        color: "#f1f1f1"
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: shadow.top
        Item{
            id: lessItem
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            width: 64
            Image{
                id: lessImage
                anchors.centerIn: parent
                source: "qrc:///images/arrow.svg"
                opacity: list.currentIndex > 0 ? 1:0
                rotation: 180
            }
            MouseArea{
                anchors.fill:  parent
                onClicked: {
                    if (lessImage.opacity > 0){
                        main.playEffect()
                        list.decrementCurrentIndex()
                        showCurrentItemOnMapCenter(list.currentIndex)
                    }
                }
            }
        }
        ListView{
            id: list
            signal openDetails(int index)
            clip: true
            spacing: 100
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.left: lessItem.right
            anchors.right: moreItem.left
            anchors.bottom: parent.bottom
            orientation: ListView.Horizontal
            highlightFollowsCurrentItem: true
            highlightRangeMode: ListView.StrictlyEnforceRange
            snapMode: ListView.SnapToItem
            highlightMoveDuration: 1000
            currentIndex: -1
            onCurrentIndexChanged: {
                wrapper.selectedItemChanged(currentIndex)
            }
            onOpenDetails: {
                wrapper.openDetails(index)
            }

            model:  wrapper.model
            delegate: wrapper.delegate
        }
        Item{
            id: moreItem
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            width: 64
            Image{
                id: moreImage
                anchors.centerIn: parent
                source: "qrc:///images/arrow.svg"
                opacity: list.currentIndex < (list.count-1) ? 1:0
            }
            MouseArea{
                anchors.fill:  parent
                onClicked: {
                    if (moreImage.opacity > 0){
                        main.playEffect()
                        list.incrementCurrentIndex()
                        showCurrentItemOnMapCenter(list.currentIndex)
                    }
                }
            }
        }
    }
    Image{
        id: shadow
        height: 6
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        source: "qrc:///images/shadow.png"
    }
}
