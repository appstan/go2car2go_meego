import QtQuick 1.1

Item {
    id: root
    property url iconSource

    width: 80; height: 64
    signal clicked


    Image {
        //source: mouseArea.pressed ? "qrc:///images/" : ""
        anchors.centerIn: parent

        Image {
            source: iconSource
            anchors.centerIn: parent
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
    }

    Component.onCompleted: mouseArea.clicked.connect(clicked)
}
