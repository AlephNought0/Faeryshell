pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    property string icon
    property string temp
    property string workspace
    property string currDate
    property string currTime

    Socket {
        path: `/tmp/hypr/${Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE")}/.socket2.sock`
		connected: true

        parser: SplitParser {

            property var regex: new RegExp("workspace>>(.)");
            
            onRead: msg => {
                const match = regex.exec(msg);

                if(match != null) {
                    workspace = match[1];
                }
            }
        }
    }

    Process {
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

                    case "Mist":
                        icon = "icons/mist.svg"
                        break;

                    case "Patchy rain nearby":
                        icon = "icons/sunny_cloudy.svg"
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

    Process {
        id: temperature
        command: ["sh", "-c", "curl wttr.in/?format=%t"]
        running: true

        stdout: SplitParser {
            splitMarker: ""
            onRead: data => temp = data.replace("+", "")
        }
    }

    Process {
        id: time
        running: true

        Component.onCompleted: {
            var currentDate = new Date()
            var day = currentDate.getDate()
            var month = currentDate.getMonth() + 1
            var year = currentDate.getFullYear()

            currTime = currentDate.toLocaleTimeString("t")
            currDate = day + "." + month + "." + year

            console.log(currTime)
        }
    }
    

    Timer {
        interval: 600000
        running: true
        repeat: true
        onTriggered: {
            icons.running = true
            temperature.running = true
            time.running = true
        } 
    }
}