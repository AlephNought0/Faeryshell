pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property string volume: ""
    property string level: ""
    property double output

    Process {
        id: current_audio
        running: true
        command: ["wpctl", "get-volume", "@DEFAULT_SINK@"]

        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                var meow = data.replace(/[^0-9.]/g, "")
                output = Number(meow)
                volume = Math.round(meow * 100) + "%"

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

    Timer { //Change that once native function comes
        interval: 50
        running: true
        repeat: true

        onTriggered: {
            current_audio.running = true
        }
    }

    function volumeUp() {
        output += 0.01; 
        
        if (output >= 1) {
            output = 1
        }
        
        set_audio.running = true;
    }

    function volumeDown() {
        output -= 0.01; 
        
        if (output <= 0) {
            output = 0
        }
        
        set_audio.running = true;
    }
}
