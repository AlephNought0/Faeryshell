pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

import ".."

Singleton {
    property string icon
    property string temp
    property string latitude
    property string longitude
    property int min: parseInt(Cfg.time.minutes)
    property string weather: " "
    property bool init: false
    property bool isRaining: false
    property bool isSnowing: false
    property bool isFoggy: false
    property bool isSleet: false

    onMinChanged: {
        if(min % 2) {
            location.running = true;
        }
    }

    Process {
        id: location
        command: ["curl", "ipinfo.io"]
        running: true
        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                var json = JSON.parse(data);
                var location = json.loc.split(",");
                latitude = location[0];
                longitude = location[1];
                weath.running = true;
            }
        }
    }

    Process {
        id: weath
        command: ["curl", `https://api.open-meteo.com/v1/forecast?latitude=${latitude}&longitude=${longitude}&daily=sunset,sunrise&current=temperature_2m,is_day,weather_code&timezone=auto`]
        running: false
        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                var json = JSON.parse(data);
                var weatherCode = json.current.weather_code;
                var sunrise = new Date(json.daily.sunrise[0]);
                var sunset = new Date(json.daily.sunset[0]);
                var night = new Date(sunset.getTime() + 1980000); //Sometimes it will be off by few minutes
                var currTime = new Date();
                var name = "";
                temp = json.current.temperature_2m;
                isSleet = false;
                isFoggy = false;
                isSnowing = false;
                isRaining = false;
    
                if(currTime >= sunrise && currTime <= sunset) {
                    Cfg.time.part = "day";
                    name = "sunny";
                }

                else if(currTime >= sunset && currTime <= night) {
                    Cfg.time.part = "evening";
                    name = "sunny";
                }

                else {
                    Cfg.time.part = "night";
                    Cfg.time.isNight = true;
                    name = "night";
                }

                switch(weatherCode) { //https://weather-sense.leftium.com/wmo-codes
                    case 0:
                    case 1:
                        icon = `../../icons/${name}.svg`;
                        weather = "Clear";
                        break;

                    case 2:
                        icon = `../../icons/${name}_cloudy.svg`;
                        weather = "Partly cloudy";
                        break;

                    case 3:
                        icon = `../../icons/cloudy.svg`;
                        weather = "Overcast";
                        break;

                    case 45:
                    case 48:
                        icon = `../../icons/misty.svg`;
                        weather = "Foggy";
                        isFoggy = true;
                        break;

                    case 51:
                        icon = `../../icons/${name}_light_raining.svg`;
                        weather = "Light drizzle";
                        isRaining = true;
                        break;

                    case 53:
                        icon = `../../icons/${name}_raining.svg`;
                        weather = "Drizzle";
                        isRaining = true;
                        break;

                    case 55:
                        icon = `../../icons/heavy_raining.svg`;
                        weather = "Heavy drizzle";
                        isRaining = true;
                        break;

                    case 56:
                        icon = `../../icons/sleet.svg`; //Will find something better for it
                        weather = "Light icy drizzle";
                        isSleet = true;
                        break;

                    case 57:
                        icon = `../../icons/sleet.svg`; //Will find something better for it
                        weather = "Icy drizzle";
                        isSleet = true;
                        break;

                    case 61:
                        icon = `../../icons/${name}_light_raining.svg`;
                        weather = "Light rain";
                        isRaining = true;
                        break;

                    case 63:
                        icon = `../../icons/${name}_raining.svg`;
                        weather = "Rain";
                        isRaining = true;
                        break;

                    case 65:
                        icon = `../../icons/heavy_raining.svg`;
                        weather = "Heavy rain";
                        isRaining = true;
                        break;

                    case 66:
                        icon = `../../icons/sleet.svg`; //Yeah something better too
                        weather = "Light icy rain";
                        isSleet = true;
                        break;

                    case 67:
                        icon = `../../icons/sleet.svg`; //You guessed it
                        weather = "Icy rain";
                        isSleet = true;
                        break;

                    case 71:
                        icon = `../../icons/${name}_snowing.svg`;
                        weather = "Light snow";
                        isSnowing = true;
                        break;

                    case 73:
                        icon = `../../icons/${name}_snowing.svg`;
                        weather = "Snow";
                        isSnowing = true;
                        break;

                    case 75:
                        icon = `../../icons/snowing.svg`;
                        weather = "Heavy snow";
                        isSnowing = true;
                        break;

                    case 77:
                        icon = `../../icons/snowing.svg`; //Yeah this one will also get a better icon
                        weather = "Snow grains";
                        isSnowing = true;
                        break;

                    case 80:
                        icon = `../../icons/${name}_light_raining.svg`;
                        weather = "Light showers";
                        isRaining = true;
                        break;

                    case 81:
                        icon = `../../icons/${name}_light_raining.svg`;
                        weather = "Showers";
                        isRaining = true;
                        break;

                    case 82:
                        icon = `../../icons/heavy_raining.svg`;
                        weather = "Heavy showers";
                        isRaining = true;
                        break;

                    case 85:
                        icon = `../../icons/${name}_light_snowing.svg`;
                        weather = "Light snow showers";
                        isSnowing = true;
                        break;

                    case 86:
                        icon = `../../icons/snowing.svg`;
                        weather = "Snow showers";
                        isSnowing = true;
                        break;

                    case 95:
                        icon = `../../icons/thunder.svg`;
                        weather = "Thunder storm";
                        isRaining = true;
                        break;

                    case 96:
                        icon = `../../icons/thunder.svg`; //Will get something better for it
                        weather = "Thunder storm + light hail";
                        isRaining = true;
                        break;

                    case 99:
                        icon = `../../icons/thunder.svg`; //Same
                        weather = "Thunder storm + heavy hail";
                        isRaining = true;
                        break;
                }

                if(!init) {
                    init = true
                    Display.autoNight();
                    Swww.getWallpaper();
                }
            }
        }
    }
}
