pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Services.Mpris

Singleton {
    id: root

    property string mediaTitle: trackedPlayer?.metadata["xesam:title"] ?? ""
    property string artist: String(trackedPlayer?.metadata["xesam:artist"] ?? "")
    property string albumImage: trackedPlayer?.metadata["mpris:artUrl"] ?? ""
    property string mediaLength
    property string mediaPosition
    property string mediaStatus: playing ? "" : ""
    property bool playing: false 
    property MprisPlayer trackedPlayer: null

    Component.onCompleted: {
        for(const player of Mpris.players.values) {
            if(player.playbackState === MprisPlaybackState.Playing) {
                playing = true
                
                if(root.trackedPlayer != player) {
                    root.trackedPlayer = player
                } 
            }
        }
    }

    Connections {
        target: Mpris.players

        function onObjectInsertedPost(player: MprisPlayer) {
            if(player.playbackState === MprisPlaybackState.Playing) {
                playing = true
                
                if(root.trackedPlayer != player) {
                    root.trackedPlayer = player
                } 
            }

            player.playbackStateChanged.connect(() => {
                if(root.trackedPlayer != player) {
                  root.trackedPlayer = player
                }
            })
        }

        function onObjectRemovedPre() {
            if(root.trackedPlayer == null) {
                for(const player of Mpris.players.values) {
                    if(player != null) {
                        root.trackedPlayer = player
                        break
                    }
                }
            }
        }
    }

    Connections {
        target: root.trackedPlayer

        function onPlaybackStateChanged() {
             if(root.trackedPlayer.playbackState !== MprisPlaybackState.Playing) {
                playing = false
            }

            else {
                playing = true
            }
        }
    }

    Timer {
        id: playDelay
        interval: 100
        running: false
        repeat: false

        onTriggered: {
            root.trackedPlayer.playbackState = MprisPlaybackState.Playing
        }
    }

    FrameAnimation {
        running: root.playing

        onTriggered: {
            const mLength = Math.floor((root.trackedPlayer.length) / 60)
            const sLength = Math.floor((root.trackedPlayer.length) % 60)
            const mPosition = Math.floor((root.trackedPlayer.position) / 60)
            const sPosition = Math.floor((root.trackedPlayer.position) % 60)

            mediaLength = mLength.toString() + ":" + sLength.toString().padStart(2, '0');
            mediaPosition = mPosition.toString() + ":" + sPosition.toString().padStart(2, '0');

            root.trackedPlayer.positionChanged()
        }
    }

    function playClick() {
        root.trackedPlayer.playbackState = MprisPlaybackState.Playing
    }

    function pauseClick() {
        root.trackedPlayer.playbackState = MprisPlaybackState.Paused
    }

    function nextClick() {
        root.trackedPlayer.next()
    }

    function backClick() {
        root.trackedPlayer.previous()
    }
}
