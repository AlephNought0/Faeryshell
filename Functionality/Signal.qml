pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property string icon: "../icons/no_access.svg"
    property string wifiInt: ""
    property string ethernetInt: ""
    property int strength
    property bool wifiCon: false
    property bool ethernetCon: false

    Process {
        id: interfaces
        running: true
        command: ["nmcli", "--get-values", "GENERAL.DEVICE,GENERAL.TYPE", "device", "show"]

        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                var lines = data.split("\n")
                
                for(let i = 0; i < lines.length; i++) {
                    if(lines[i] === "wifi") {
                        root.wifiInt = lines[i - 1]
                    }

                    else if(lines[i] === "ethernet") {
                        root.ethernetInt = lines[i - 1]
                    }
                }
            }
        }
    }

    Process {
        id: ethernetState
        running: true
        command: ["cat", "/sys/class/net/" + root.ethernetInt + "/operstate"]

        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                var lines = data.split("\n")
                
                if(lines[0] == "up") {
                    root.ethernetCon = true
                }

                else {
                    root.ethernetCon = false
                }
            }
        }
    }

    Process {
        id: wifiState
        running: true
        command: ["cat", "/sys/class/net/" + root.wifiInt + "/operstate"]

        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                var lines = data.split("\n")
                
                if(lines[0] === "up") {
                    root.wifiCon = true
                }

                else {
                    root.wifiCon = false
                }
            }
        }
    }

    Process {
        id: wifiSignal
        running: true
        command: ["cat", "/proc/net/wireless"]

        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                var lines = data.split("\n")
                root.strength = parseInt(lines[2].substr(21, 2))
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            ethernetState.running = true;
            wifiState.running = true;
            wifiSignal.running = true;
            
            if(ethernetCon && !wifiCon) {
                root.icon = "../icons/ethernet.svg";
            }

            else if((!ethernetCon && wifiCon) || (wifiCon && ethernetCon)) {
                if(root.strength < 55) {
                    root.icon = "../icons/wifi_epic";
                }

                else if(root.strength < 70) {
                    root.icon = "../icons/wifi_medium";
                }

                else {
                    root.icon = "../icons/wifi_low";
                }
            }

            else {
                root.icon = "../icons/no_access.svg";
            }
        }
    }
}