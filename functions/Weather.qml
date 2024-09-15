pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    property string icon
    property string temp
    property string weather
    property string city
    property string currentTime

    property bool isRaining: false
    property bool isSnowing: false
    property bool isFoggy: false
    property bool isSleet: false

    signal init()

    onCityChanged: {
        cycleTime.running = true
    }

    SystemClock {
        id: clock

        property string hour: hours
        property string minute: minutes

        onMinutesChanged: {
            weath.running = true
        }
    }

    Process {
        id: location
        command: ["curl", "ipinfo.io"]
        running: true

        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                var jsonObject = JSON.parse(data)
                city = jsonObject.city
            }
        }
    }

    Process { //Weather
        id: weath
        command: ["curl", `wttr.in/${city}?format=%C|%t`]
        running: false

        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                var wh = data.split("|")

                weather = wh[0]
                temp = wh[1].replace("+", "")

                var name = ""

                if(currentTime === "day" || currentTime === "evening") {
                    name = "sunny"
                }

                else {
                    name = "night"
                }

                switch(weather) { //https://github.com/chubin/wttr.in/blob/235581925fa2e09a42e9631e2c23294a1972ee0e/share/translations/mk.txt 386
                    case "Clear":
                    case "Sunny":
                        if(currentTime == "night") { weather = "Night" }
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
        command: ["curl", `wttr.in/${city}?format=%S|%s|%d`]
        running: false

        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                var times = data.split("|")
                var sunrise = times[0].split(":")
                var evening = times[1].split(":")
                var night = times[2].split(":")

                if(clock.hour == Number(sunrise[0])) {
                    if(clock.minute >= Number(sunrise[1])) {
                        currentTime = "day"
                    }
                }

                else if(clock.hour > Number(sunrise[0]) && 
                (clock.hour <= Number(evening[0]) - 1 && currentTime !== "evening")) {
                    currentTime = "day"
                }

                if(clock.hour == Number(evening[0]) - 1) {
                    if(clock.minute >= Number(evening[1])) {
                        currentTime = "evening"
                    }
                }

                else if(clock.hour > Number(evening[0]) - 1 && 
                (clock.hour <= Number(night[0]) && currentTime !== "night")) {
                    currentTime = "evening"
                }

                if(clock.hour == Number(night[0])) {
                    if(clock.minute >= Number(night[1])) {
                        currentTime = "night"
                    }
                }

                else if((clock.hour > Number(night[0])) || 
                (clock.hour >= 0 && clock.hour <= Number(sunrise[0]) && currentTime !== "day")) {
                    currentTime = "night"
                }

                weath.running = true
            }
        }
    }

    Timer {
        interval: 1800000
        running: true
        repeat: true
        onTriggered: {
            location.running = true
        }
    }
}
