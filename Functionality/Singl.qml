pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    property string icon
    property string temp
    property string formattedHours: "12:00"
    property string formattedDate

    Process { //Weather
        id: icons
        command: ["sh", "-c", "curl wttr.in/?format=%C"]
        running: true

        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                icon = data

                switch(icon) {
                    case "Light snow":
                        icon = "icons/sunny_snowing.svg"
                        break;

                    case "Light rain":
                        case "Light rain shower":
                            icon = "icons/sunny_light_raining.svg"
                            break;

                    case "Partly cloudy":
                        icon = "icons/sunny_cloudy.svg"
                        break;
                    
                    case "Overcast":
                        case "Cloudy":
                            icon = "icons/cloudy.svg"
                            break;
                    
                    case "Clear":
                        case "Sunny":
                            icon = "icons/sunny.svg"
                            break;
                }
            }
        }
    }

    Process { //Temperature
        id: temperature
        command: ["sh", "-c", "curl wttr.in/?format=%t"]
        running: true

        stdout: SplitParser {
            splitMarker: ""
            onRead: data => temp = data.replace("+", "")
        }
    }
    

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            icons.running = true
            temperature.running = true

            var now = new Date();
            var day = now.getDay(); // Get day of the week (0-6)
            var days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
            var month = now.getMonth(); // Get month (0-11)
            var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

            // Format the date string
            formattedHours = (now.getHours() < 10 ? '0' : '') + now.getHours() + ':' + (now.getMinutes() < 10 ? '0' : '') + now.getMinutes()
            formattedDate = days[day] + ', ' + (now.getDate() < 10 ? '0' : '') + now.getDate() + ' ' + months[month] + ' ' + now.getFullYear();
        } 
    }
}