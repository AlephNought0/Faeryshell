pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property string volume: Math.round(output * 100) + "%"
    property string level: ""
    property double output: 0
    property double prev: 0

    Process {
        id: current_audio
        running: true
        command: ["wpctl", "get-volume", "@DEFAULT_SINK@"]

        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                var meow = data.replace(/[^0-9.]/g, "")
                output = Number(meow)

                if(output > 0.6) {
                    level = "../icons/audio_full.svg"
                }

                else if(output < 0.6) {
                    level = "../icons/audio_medium.svg"
                }

                else if(output < 0.3) {
                    level = "../icons/audio_low.svg"
                }

                else if(output === 0) {
                    level = "../icons/audio_muted.svg"
                }
            }
        }
    }

    Process {
        id: set_audio
        running: false
        command: ["wpctl", "set-volume", "@DEFAULT_SINK@", output]
    }

    function volumeUp() {
        if(output < 1) {
            output += 0.01
        }

        if(prev !== output) {
            set_audio.running = true
            current_audio.running = true
        }

        volume = Math.round(output * 100) + "%"

        prev = output
    }

    function volumeDown() {
        if(output > 0) {
            output -= 0.01
        }  
        
        if(prev !== output) {
            set_audio.running = true
            current_audio.running = true
        }

        volume = Math.round(output * 100) + "%"

        prev = output
    }
}
