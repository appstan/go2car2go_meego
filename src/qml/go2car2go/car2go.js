Qt.include("oauth.js")
Qt.include("storage.js")

var Car2Go = function() {

    // OAuth specific parameters
    var SECURED_HOST = "https://www.car2go.com/api";
    var REQUEST_TOKEN_URL = "https://www.car2go.com/api/reqtoken";
    var AUTHORIZE_URL = "https://www.car2go.com/api/authorize";
    var ACCESS_TOKEN_URL = "https://www.car2go.com/api/accesstoken";
    // car2go developer keys
    var CONSUMER_KEY = "TemirlanTentimishov";
    var CONSUMER_SECRET = "QPCvPebF5P11mWX9";

    var sig = "hmac-sha1";
    var CALLBACK = "foo";
   // var oauth = new OAuth();
    var hasToken = false;

    var tokenDBCounter = 0;
    var token = "";
    var tokenSecret = "";


    var errorCallback;

//    this.setErrorCallback = function(error) {
//             errorCallback = error;
//             oauth.setErrorCallback(error);
//         }

    this.requestToken = function (){

             var doc = new XMLHttpRequest();
             doc.onreadystatechange = function() {
                         if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {
                             var status = doc.status;
                             if(status!=200) {
                                 main.log("XMLHttpRequest.HEADERS_RECEIVED CAR2GO API returned " + status + " " + doc.statusText);
                             }
                         }
                         else if (doc.readyState == XMLHttpRequest.DONE) {
                             status = doc.status;
                             if(status!=200) {
                                 main.log("HTTP status " + status);
                                 main.log("XMLHttpRequest.DONE CAR2GO API returned " + status + " " + doc.statusText);
                             }

                             var response = doc.responseText;
                             if (/oauth_token/i.test(response)) {
                                 var tSplit = response.split('=');
                                 var car2goToken = tSplit[1].split('&')[0];
                                 var car2goSecret = tSplit[2].split('&')[0];
                                 // Direct user to service provider for login
                                 load(car2goToken);
                             }
                             else {
                                 main.log("Unable to obtain car2go request token");
                             }
                         }
                     }

             var url = REQUEST_TOKEN_URL;
             var params = {
                 "url": url,
                 "callback": CALLBACK,
                 "method": 'GET'
             };
             var oauthHeader = this.signHeader(params);
             main.log("oauthHeader :" + oauthHeader);

             doc.open("GET", url);
             doc.setRequestHeader('Authorization', oauthHeader);
             doc.setRequestHeader('encoding', 'charset=UTF-8');
             doc.send();
         }


    this.urlChanged = function(url){

        if(typeof(url)!= "undefined" || url != "" ){
            var responseVars = url.split("?");
//            main.log("responseVars : " + responseVars);
//            main.log("car2go.SECURED_HOST : " + SECURED_HOST);
            if( responseVars[0]== SECURED_HOST +'/' || responseVars[0]== SECURED_HOST ){
                var response_param = responseVars[1];
                var result = response_param.match(/oauth_verifier=*/g);
                if(result!= null){
                    var params = response_param.split("&");
                    var token = params[0].replace("oauth_token=","");
                    var verifier = params[1].replace("oauth_verifier=","");

 //                   main.log("oauth_token,oauth_verifier : " + token + " , " +verifier);

                    this.accessToken( token, verifier);
                }

            }
        }
    }


    this.accessToken = function( token, verifier) {

        main.log("[oauth_token , oauth_verifier] : " + token + " , " +verifier);

        var doc = new XMLHttpRequest();

        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {
                var status = doc.status;
                if(status!=200) {
                    main.log("XMLHttpRequest.HEADERS_RECEIVED CAR2GO API returned " + status + " " + doc.statusText);
                }
            }
            else  if (doc.readyState == XMLHttpRequest.DONE) {

                status = doc.status;
                if(status == 200) {
                    var response = doc.responseText;
                    main.log("HTTP response " + response);
                    if (/oauth_token/i.test(response)) {
                        var tSplit = response.split('=');
                        var token = tSplit[1].split('&')[0];
                        var secret = tSplit[2].split('&')[0];
                        main.log("oauth_token,oauth_secret : " + token + " , " +secret);
                    }

                }
                else {
                    response = doc.responseText;
                    var response_header = doc.statusText;
                    main.log("responce status " + status);
                    main.log("responce " + response);

                    main.log("XMLHttpRequest.DONE CAR2GO API returned " + status + " " + doc.statusText);

                    main.log("Unable to obtain car2go access token");
                }
            }
        }

             var url = ACCESS_TOKEN_URL;
             var params = {
                 "url": url,
                 "token": token,
                 "verifier": verifier,
                 "method": 'POST'
             };
             var oauthHeader = this.signHeader(params);
             main.log("oauthHeader :" + oauthHeader);

             doc.open("POST", url);
             doc.setRequestHeader('Authorization', oauthHeader);
             doc.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
             doc.setRequestHeader('Content-Encoding', 'charset=UTF-8');
 //            doc.send();
    }


    this.signHeader = function (params){
             if(params==undefined)
                 params='';
             // define request method
             var method = 'POST';
             if(params.method)
                 method = params.method;

             if(params.callback)
                 var parameter  = ("oauth_callback=" + params.callback);

             if(params.verifier)
                 parameter  = ("oauth_verifier=" + params.verifier);

             if(params.token_secret)
                 var tokenSecret = params.token_secret;


             var timestamp = OAuth.timestamp();
             var nonce = OAuth.nonce(11);


             var accessor = {consumerSecret: CONSUMER_SECRET, tokenSecret : tokenSecret};
             var message = {method: method, action: params.url, parameters: OAuth.decodeForm(parameter)};

             message.parameters.push(['oauth_consumer_key', CONSUMER_KEY]);
             message.parameters.push(['oauth_nonce',nonce]);
             message.parameters.push(['oauth_signature_method','HMAC-SHA1']);
             message.parameters.push(['oauth_timestamp',timestamp]);
             if(params.token)
                 message.parameters.push(['oauth_token', params.token ]);
             message.parameters.push(['oauth_version','1.0']);
             message.parameters.sort();
             OAuth.SignatureMethod.sign(message, accessor);
             var authHeader = OAuth.getAuthorizationHeader("", message.parameters);
             return authHeader;
         }
}
