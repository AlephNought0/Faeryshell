import Quickshell
import Quickshell.Io
import QtQuick
import Qt.labs.folderlistmodel

import ".."

Item {
    id: root

    property string image: ""
    property string file: ""
    property string currentTime: Weather.currentTime

    Component.onCompleted: {
        Weather.init.connect(getWallpaper)
    }

    onImageChanged: {
        file = image //For whatever reason the process simply doesn't recognize image property at startup
        matugen.running = true
    }

    FolderListModel {
        id: folderModel
        showDirs: false

        onFolderChanged: {
            if(folderModel.count > 0) {
                var randomIndex = Math.floor(Math.random() * folderModel.count)
                var item = folderModel.get(randomIndex, "filePath")
                
                root.image = item
                wallpaper.running = true
                folderModel.folder = "file:///meow"
            }
        }
    }

    SystemClock {
        id: clock

        onMinutesChanged: {
            if(minutes % 4 == 0) {
                getWallpaper()
            }
        }
    }

    Process {
        id: matugen
        command: ["matugen", "--json", "hex", "image", file]
        running: false

        stderr: SplitParser {
            splitMarker: ""
            onRead: data => {
                console.log(data)
            }
        }

        stdout: SplitParser {
            splitMarker: ""
            onRead: data => {
                try {
                    var jsonObject = JSON.parse(data)
                    Cfg.colors.primaryColor = Qt.alpha(jsonObject.colors.light.primary, 0.7)
                    Cfg.colors.secondaryColor = Qt.alpha(jsonObject.colors.light.secondary, 0.7)
                    Cfg.colors.thirdaryColor = Qt.alpha(jsonObject.colors.light.tertiary, 0.7)
                    Cfg.colors.errorContainer = Qt.alpha(jsonObject.colors.light.error_container, 0.7)
                    Cfg.colors.primaryFixedDim = Qt.alpha(jsonObject.colors.light.primary_fixed_dim, 0.7)
                } catch (err) {
                    matugen.running = true
                }
            }
        }
    }

    Process {
        id: wallpaper
        command: ["swww", "img", image]
        running: false
        environment: ({
            SWWW_TRANSITION_FPS: 165,
            SWWW_TRANSITION_STEP: 90,
            SWWW_TRANSITION_ANGLE: 30,
            SWWW_TRANSITION: "wipe"
        })
    }

    function getWallpaper() {
        if(Weather.isSnowing) {
            folderModel.folder = Qt.resolvedUrl(`../wallpapers/snow/${currentTime}`)
        }

        else if(Weather.isRaining) {
            folderModel.folder = Qt.resolvedUrl(`../wallpapers/rain/${currentTime}`)
        }

        else if(Weather.isSleet) {
            folderModel.folder = Qt.resolvedUrl(`../wallpapers/sleet/${currentTime}`)
        }

        else if(Weather.isFoggy) {
            folderModel.folder = Qt.resolvedUrl(`../wallpapers/fog/${currentTime}`)
        }

        else {
            folderModel.folder = Qt.resolvedUrl(`../wallpapers/${currentTime}`)
        }

        Weather.init.disconnect(getWallpaper) 
    }
}
