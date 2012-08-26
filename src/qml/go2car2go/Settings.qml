/**
 * go2car2go - car2go client for Qt-powered devices.
 *
 * Author: Temirlan Tentimishov (temirlan@ovi.com)
 *
 *  go2car2go is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  go2car2go is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with go2car2go.  If not, see <http://www.gnu.org/licenses/>.
 */
import Qt 4.7

Item{

    width: 480
    height: 854

    property color colorBlack: "black"
    property color colorWhite: "white"
    property color colorGray:  "lightGray"
    property color colorOrange: "#Fd6500"
    property color list_item_content_normal_color: "#E4E4E4"
    property color distanceBoxBackgroundColor: "#E8773E"
    property color defaultBackgroundColor: colorBlack

    property color headerBackgroundColor: colorOrange
    property color headerTextColor: colorWhite
    property int headerLandscapeHeight: 56
    property int headerPortraiHeight: 72

    property int navigationBarHeight: 60
    property int navigationBarWidth:90
    property int pageHeight: height - navigationBarHeight
    property int pageWidth: width

    property int gridCellHeight: 100
    property int gridCellWidth: 100

    property int scrollbarWidth: 8

    //Fonts
    property int tinyFontSize: 12
    property int smallFontSize: 14
    property int normalFontSize: 16
    property int mediumFontSize: 20
    property int bigFontSize: 24
    property int largeFontSize: 28
    property int megaLargeFontSize: 32
    property color fontColor: colorWhite
    property string defaultFontFamily: "Nokia Pure Text Light"

    // Margins
    property int smallMargin: 2
    property int mediumMargin: 5
    property int largeMargin: 14
    property int extraLargeMargin: 16
    property int hugeMargin: 20

    property color separatorColor: colorWhite
    property color textHeaderColor: "steelblue"

    function toPrecision(value,precision){
        var power = Math.pow(10, precision || 0);
        return new String(Math.round(value * power) / power);
    }

    function locateDistance( aDistanceInMeters, aMetric ) {
        if (!aDistanceInMeters || aDistanceInMeters.length == 0){
            return ""
        }

        var retval = ""
        if (aMetric){
            if (aDistanceInMeters >= 10000){
                retval = toPrecision(aDistanceInMeters/1000,0) + " km"
            }
            if (aDistanceInMeters >= 1000){
                retval = toPrecision(aDistanceInMeters/1000,2) + " km"
            }
            else{
                retval = aDistanceInMeters + " m"
            }
        }
        else{
            var inFeets = aDistanceInMeters*3.28
            var oneMileInFeets = 5280
            if (inFeets/oneMileInFeets >= 10){
                retval = toPrecision(inFeets/oneMileInFeets,0)+ " ml"
            }
            if (inFeets/oneMileInFeets >= 1){
                retval = toPrecision(inFeets/oneMileInFeets,2)+ " ml"
            }
            else{
                retval =  toPrecision(inFeets,0) + " ft"
            }
        }

        return retval
    }

}
