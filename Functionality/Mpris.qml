pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Services.Mpris

Singleton {
    property string mediaTitle: Mpris.players[currentPlayer].metadata["xesam:title"]
    property string artist: Mpris.players[currentPlayer].metadata["xesam:artist"]
    property string albumImage: Mpris.players[currentPlayer].metadata["mpris:artUrl"]
    property string mediaLength
    property string mediaPosition
    property string mediaStatus
    property bool playing
    property int currentPlayer
    property var allPlayers: []
    

    Timer {
        interval: 500
        running: true
        repeat: true

        onTriggered: {
            let pos = 0;
            let arr = new Array(0)

            for(const player of Mpris.players) {
                arr.push(MprisPlaybackState.toString(player.playbackState))

                if(MprisPlaybackState.toString(player.playbackState) !== allPlayers[pos]) {
                    allPlayers = arr
                    currentPlayer = pos
                }

                pos++
            }
        }
    }

    FrameAnimation {
        running: Mpris.players[currentPlayer].playbackStateChanged
        onTriggered: {
            if(Mpris.players[currentPlayer].playbackState !== MprisPlaybackState.Playing) {
                mediaStatus = "../../icons/play.svg"
                playing = false
            }

            else {
                mediaStatus = "../../icons/pause.svg"
                playing = true
            }
        }
    }

    FrameAnimation {
        running: Mpris.players[currentPlayer].playbackState == MprisPlaybackState.Playing
        onTriggered: {
            const mLength = Math.floor((Mpris.players[currentPlayer].length) / 60)
            const sLength = Math.floor((Mpris.players[currentPlayer].length) % 60)
            const mPosition = Math.floor((Mpris.players[currentPlayer].position) / 60)
            const sPosition = Math.floor((Mpris.players[currentPlayer].position) % 60)

            mediaLength = mLength.toString() + ":" + sLength.toString().padStart(2, '0');
            mediaPosition = mPosition.toString() + ":" + sPosition.toString().padStart(2, '0');
        }
    }

    function playClick() {
        Mpris.players[currentPlayer].playbackState = MprisPlaybackState.Playing
    }

    function pauseClick() {
        Mpris.players[currentPlayer].playbackState = MprisPlaybackState.Paused
    }
}