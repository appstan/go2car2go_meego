import QtQuick 1.1
import QtWebKit 1.0
import com.nokia.meego 1.0
import "script.js" as Script

Page {
    id: car2goOAuth

    tools:loginToolbar

    focus : true

    property string name: "login"

    signal finished()
    signal loadFailed()
    property string token: ""
    property  int i: 0
    property bool loadingIndicatorPLAY :false

    function load(token) {
        loginView.url = "https://www.car2go.com/api/authorize?oauth_token=" + token;
    }

    Component.onCompleted: {
        main.log("login page is created");
        Script.getCar2goToken();
    }

//    Connections{
//         target:car2goManager
//         onAuthenticationRequired:{
//             Script.getCar2goToken();
//          }
//    }

    WebView {
        id: loginView
        visible: true
        anchors.fill: parent
        url: ""
        settings.fixedFontFamily: globalSettings.defaultFontFamily
        settings.minimumFontSize : globalSettings.mediumFontSize

        onUrlChanged: {
            main.log(++i);
            main.log("UrlChanged: URL is now " + loginView.url.toString());
            Script.urlChanged(loginView.url.toString());

        }

        onLoadStarted: {
            loadingIndicatorPLAY = true;
            main.log("LoadStarted: URL is now " + loginView.url.toString());
        }

        onLoadFinished: {
            loadingIndicatorPLAY = false;
            main.log("LoadFinished: URL is now " + loginView.url);
        }

        onLoadFailed: {
            loadingIndicatorPLAY = false;
            main.log("LoadFailed: URL is now " + loginView.url.toString());
        }

    }

    BusyIndicator {
        id: indicator
        anchors.centerIn: parent
        platformStyle: BusyIndicatorStyle { size: "large" }
        running: loadingIndicatorPLAY ? 1 : 0
        opacity: running ? 1:0
        Behavior on opacity { NumberAnimation { duration: 500; } }
    }

    PageHeader {
        id: header
        title: "Login"
        icons: false
    }

    ToolBarLayout {
        id: loginToolbar
        visible: true
        ToolIcon {
            platformIconId: "toolbar-back"
            anchors.left: (parent === undefined) ? undefined : parent.left
            onClicked: pageStack.pop()
        }
     }
}
