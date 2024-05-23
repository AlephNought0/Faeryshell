pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import Quickshell.Services.Mpris

Singleton {
    property string mediaTitle
    property string artist
    property string albumImage
    property string mediaLength
    property string mediaPosition
    property string mediaStatus
    property bool playing
    property int currentPlayer
    property var allPlayers: []
    

    Timer {
        interval: 150
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

            if(Mpris.players[currentPlayer].playbackState !== MprisPlaybackState.Playing) {
                mediaStatus = "../../icons/play.svg"
                playing = false
            }

            else {
                mediaStatus = "../../icons/pause.svg"
                playing = true
            }

            const mLength = Math.floor((Mpris.players[currentPlayer].length) / 60)
            const sLength = Math.floor((Mpris.players[currentPlayer].length) % 60)
            const mPosition = Math.floor((Mpris.players[currentPlayer].position) / 60)
            const sPosition = Math.floor((Mpris.players[currentPlayer].position) % 60)

            mediaTitle = Mpris.players[currentPlayer].metadata["xesam:title"]
            artist = Mpris.players[currentPlayer].metadata["xesam:artist"]
            albumImage = Mpris.players[currentPlayer].metadata["mpris:artUrl"]
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