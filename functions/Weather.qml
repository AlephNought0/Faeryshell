pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    property string icon
    property string temp
    property string weather

    Process { //Weather
        id: icons
        command: ["curl", "wttr.in/?format=%C"]
        running: true

        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                weather = data

                switch(data) {
                    case "Light snow":
                        icon = "../../icons/sunny_snowing.svg"
                        break;

                    case "Light rain":
                        case "Light rain shower":
                            icon = "../../icons/sunny_light_raining.svg"
                            break;

                    case "Partly cloudy":
                        icon = "../../icons/sunny_cloudy.svg"
                        break;
                    
                    case "Overcast":
                        case "Cloudy":
                            icon = "../../icons/cloudy.svg"
                            break;
                    
                    case "Clear":
                        case "Sunny":
                            icon = "../../icons/sunny.svg"
                            break;
                }
            }
        }
    }

    Process { //Temperature
        id: temperature
        command: ["curl", "wttr.in/?format=%t"]
        running: true

        stdout: SplitParser {
            splitMarker: ""
            onRead: data => temp = data.replace("+", "")
        }
    }
    

    Timer {
        interval: 30000
        running: true
        repeat: true
        onTriggered: {
            icons.running = true
            temperature.running = true
        }
    }
}
