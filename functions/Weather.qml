pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    property string icon
    property string temp
    property string weather
    property bool isDay: false // I count afternoon as day because whatever
    property bool isEvening: false
    property bool isNight: false

    SystemClock {
        id: clock

        property string hour: hours
        property string minute: minutes

        onMinuteChanged: {
            cycleTime.running = true
        }
    }

    Process { //Weather
        id: weath
        command: ["curl", "wttr.in/?format=%C|%t"]
        running: true

        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                var wh = data.split("|")

                weather = wh[0]
                temp = wh[1].replace("+", "")

                var name = ""

                if(isDay || isEvening) {
                    name = "sunny"
                }

                else {
                    name = "night"
                }

                switch(weather) { //https://github.com/chubin/wttr.in/blob/235581925fa2e09a42e9631e2c23294a1972ee0e/share/translations/mk.txt 386
                    case "Clear":
                    case "Sunny":
                        if(isNight) weather = "Night"
                        icon = `../../icons/${name}.svg`
                        break

                    case "Partly Cloudy":
                        icon = `../../icons/${name}_cloudy.svg`
                        break

                    case "Thundery outbreaks in nearby":
                    case "Thundery outbreaks possible":
                        icon = `../../icons/thunder.svg`
                        break

                    case "Overcast":
                    case "Cloudy":
                        icon = "../../icons/cloudy.svg"
                        break

                    case "Mist":
                    case "Fog":
                    case "Freezing fog":
                        icon = "../../icons/mist.svg"
                        break

                    case "Blowing snow":
                    case "Blizzard":
                        icon = "../../icons/blowing_snow.svg"
                        break

                    case "Patchy light drizzle":
                    case "Light drizzle":
                    case "Patchy rain nearby":
                    case "Patchy rain possible":
                        icon = `../../icons/${name}_patchy_rain.svg`
                        break
                    
                    case "Freezing drizzle":
                    case "Heavy freezing drizzle":
                    case "Light freezing rain":
                    case "Moderate or heavy freezing rain":
                    case "Light sleet":
                    case "Moderate or heavy sleet":
                    case "Patchy sleet possible":
                    case "Patchy freezing drizzle possible":
                    case "Light sleet showers"
                    case "Moderate or heavy sleet showers":
                        icon = "../../icons/sleet.svg"
                        break

                    case "Patchy light rain":
                    case "Light rain":
                    case "Moderate rain at times":
                    case "Moderate rain":
                    case "Light rain shower":
                        icon = `../../icons/${name}_light_raining.svg`
                        break

                    case "Heavy rain at times":
                    case "Heavy rain":
                    case "Moderate or heavy rain shower":
                        icon = "../../icons/heavy_raining.svg"
                        break
        
                    case "Patchy light snow":
                    case "Light snow":
                    case "Patchy moderate snow":
                    case "Moderate snow":
                    case "Patchy snow possible":
                    case "Light snow showers":
                        icon = `../../icons/${name}_snowing.svg`
                        break

                    case "Patchy heavy snow":
                    case "Heavy snow":
                    case "Ice pellets": //Idk what to give u
                    case "Moderate or heavy snow showers":
                        icon = "../../icons/snowing.svg"
                        break

                    case "Torrential rain shower":
                        icon = "../../icons/extreme_rain.svg"
                        break
                }
            }
        }
    }

    Process { //Time
        id: cycleTime
        command: ["curl", "wttr.in/?format=%S|%s|%d"]
        running: true

        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                var times = data.split("|")
                var sunrise = times[0].split(":")
                var evening = times[1].split(":")
                var night = times[2].split(":")

                if(clock.hour >= Number(sunrise[0]) && clock.minute >= Number(sunrise[1])) {
                    isNight = false
                    isEvening = false
                    isDay = true
                }

                if(clock.hour >= Number(evening[0]) - 1 && clock.minute >= Number(evening[0])) {
                    isDay = false
                    isNight = false
                    isEvening = true
                }

                if((clock.hour >= Number(night[0]) && clock.minute >= Number(night[1])) || 
                (clock.hour >= 0 && clock.hour < Number(sunrise[0]))) {
                    isEvening = false
                    isDay = false
                    isNight = true
                }
            }
        }
    }
    
    Timer {
        interval: 30000
        running: true
        repeat: true
        onTriggered: {
            weath.running = true
        }
    }
}
