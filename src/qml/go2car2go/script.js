Qt.include("car2go.js")
var car2go = null;

function initCar2GoLogin() {
    if(typeof(car2go)=="undefined" || car2go===null) {
        car2go = new Car2Go();
        //car2go.setErrorCallback( errorCallback );
    }
}

function getCar2goToken() {
    initCar2GoLogin();
    car2go.requestToken();
}

// call car2go's exchange token
function urlChanged(url) {
    if(typeof(url)!= "undefined" || url != "" ){
        car2go.urlChanged(url);
    }
}
