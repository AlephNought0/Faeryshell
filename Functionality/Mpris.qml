pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls

Singleton {
    id: root
    property string mediaTitle
    property string albumImage
    property string status
    property bool playing

    Process {
        id: title
        running: true
        command: ["playerctl", "metadata", "--format", "{{ title }}", "--follow"]

        stdout: SplitParser {
            onRead: data => {
                root.mediaTitle = data
            }
        }
    }

    Process {
        id: artUrl
        running: true
        command: ["playerctl", "metadata", "--format", "{{ mpris:artUrl }}", "--follow"]

        stdout: SplitParser {
            onRead: data => {
                root.albumImage = data
            }
        }
    }

    Process {
        id: playbackStatus
        running: true
        command: ["playerctl", "metadata", "--format", "{{ status }}", "--follow"]

        stdout: SplitParser {
            onRead: data => {
                if(data == "Playing") {
                    root.status = "../../icons/pause.svg"
                    root.playing = true
                }

                else {
                    root.status = "../../icons/play.svg"
                    root.playing = false
                }
            }
        }
    }

    Process {
        id: next
        running: false
        command: ["playerctl", "next"]
    }

    Process {
        id: back
        running: false
        command: ["playerctl", "previous"]
    }

    Process {
        id: play
        running: false
        command: ["playerctl", "play"]
    }

    Process {
        id: pause
        running: false
        command: ["playerctl", "pause"]
    }

    function nextClick() {
        next.running = true
    }

    function backClick() {
        back.running = true
    }

    function playClick() {
        play.running = true
    }

    function pauseClick() {
        pause.running = true
    }
} 