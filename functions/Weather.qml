pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

import ".."

Singleton {
    property string icon
    property string temp
    property string weather: " "
    property string currentTime
    property string min: Cfg.time.minutes
    property bool isRaining: false
    property bool isSnowing: false
    property bool isFoggy: false
    property bool isSleet: false

    signal init()

    onMinChanged: {
        weath.running = true
    }

    Timer {
        id: delay
        running: false
        repeat: false
        interval: 200

        onTriggered: {
            weath.running = true
        }
    }

    Process { //Weather
        id: weath
        command: ["curl", `wttr.in/?format=j2`]
        running: false

        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                var json = JSON.parse(data)
                var name = ""

                temp = json.current_condition[0].temp_C + "°C"
                weather = json.current_condition[0].weatherDesc[0].value

                if(currentTime === "day" || currentTime === "evening") {
                    name = "sunny"
                }

                else {
                    name = "night"
                }

                switch(weather) { //https://github.com/chubin/wttr.in/blob/235581925fa2e09a42e9631e2c23294a1972ee0e/share/translations/mk.txt 386
                    case "Clear":
                    case "Sunny":
                        if(currentTime == "night") { name = "night" }
                        icon = `../../icons/${name}.svg`
                        break

                    case "Partly cloudy":
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
                        isSleet = false
                        isSnowing = false
                        isRaining = false
                        isFoggy = true
                        break

                    case "Blowing snow":
                    case "Blizzard":
                        icon = "../../icons/blowing_snow.svg"
                        isSleet = false
                        isRaining = false
                        isFoggy = false
                        isSnowing = true
                        break

                    case "Patchy light drizzle":
                    case "Light drizzle":
                    case "Patchy rain nearby":
                    case "Patchy rain possible":
                    case "Light drizzle and rain":
                        icon = `../../icons/${name}_patchy_rain.svg`
                        isSleet = false
                        isFoggy = false
                        isSnowing = false
                        isRaining = true
                        break
                    
                    case "Freezing drizzle":
                    case "Heavy freezing drizzle":
                    case "Light freezing rain":
                    case "Light freezing rain, mist":
                    case "Moderate or heavy freezing rain":
                    case "Light sleet":
                    case "Moderate or heavy sleet":
                    case "Patchy sleet possible":
                    case "Patchy freezing drizzle possible":
                    case "Light sleet showers":
                    case "Moderate or heavy sleet showers":
                        icon = "../../icons/sleet.svg"
                        isFoggy = false
                        isSnowing = false
                        isRaining = false
                        isSleet = true
                        break

                    case "Rain, light rain":
                        icon = `../../icons/${name}_light_raining.svg`
                        weather = "Rain"
                        isSleet = false
                        isFoggy = false
                        isSnowing = false
                        isRaining = true
                        break

                    case "Patchy light rain":
                    case "Light rain":
                    case "Moderate rain at times":
                    case "Moderate rain":
                    case "Light rain shower":
                        icon = `../../icons/${name}_light_raining.svg`
                        isSleet = false
                        isFoggy = false
                        isSnowing = false
                        isRaining = true
                        break

                    case "Heavy rain at times":
                    case "Heavy rain":
                    case "Moderate or heavy rain shower":
                        icon = "../../icons/heavy_raining.svg"
                        isSleet = false
                        isFoggy = false
                        isSnowing = false
                        isRaining = true
                        break
        
                    case "Patchy light snow":
                    case "Light snow":
                    case "Patchy moderate snow":
                    case "Moderate snow":
                    case "Patchy snow possible":
                    case "Light snow showers":
                        icon = `../../icons/${name}_snowing.svg`
                        isSleet = false
                        isFoggy = false
                        isRaining = false
                        isSnowing = true
                        break

                    case "Patchy heavy snow":
                    case "Heavy snow":
                    case "Ice pellets": //Idk what to give u
                    case "Moderate or heavy snow showers":
                        icon = "../../icons/snowing.svg"
                        isSleet = false
                        isFoggy = false
                        isRaining = false
                        isSnowing = true
                        break

                    case "Torrential rain shower":
                        icon = "../../icons/extreme_rain.svg"
                        isSleet = false
                        isFoggy = false
                        isSnowing = false
                        isRaining = true
                        break
                }

                init()
            }
        }
    }

    Process { //Time
        id: cycleTime
        command: ["curl", `wttr.in/?format=%S|%s|%d`]
        running: true

        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                var times = data.split("|")
                var a = times[0].split(":")
                var b = times[1].split(":")
                var c = times[2].split(":")
                var day = parseInt(a[0]) * 60 + parseInt(a[1])
                var evening = parseInt(b[0]) * 60 + parseInt(b[1])
                var night = parseInt(c[0]) * 60 + parseInt(c[1])
                var currTime = parseInt(Cfg.time.hours) * 60 + parseInt(Cfg.time.minutes)

                if(currTime >= day && currTime < evening) {
                    currentTime = "day"
                }

                else if(currTime >= evening && currTime < night) {
                    currentTime = "evening"
                }

                else {
                    currentTime = "night"
                }

                delay.running = true
            }
        }
    }
}
