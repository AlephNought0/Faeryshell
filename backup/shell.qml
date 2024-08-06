import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Wayland
import "Bar"
import "Bar/Media"
import "Bar/Audio"
import "Functionality"

ShellRoot {
    Variants {
        model: Quickshell.screens

        delegate: Component {
            
            PanelWindow {
                id: panel

                mask: Region { item: rect }

                anchors {
                    top: true
                    left: true
                    right: true
                }

                property var modelData
                screen: modelData

                height: screen.height
                width: screen.width
                exclusiveZone: Main.barHeight
                color: "transparent"

                Item {
                    id: rect
                    width: screen.width
                    height: Main.barHeight

                    Left{}

                    Media{}

                    Right{}

                    LazyLoader {
                        id: mediaPopup
                        loading: true

                        Interface{}
                    }

                    LazyLoader {
                        id: audioPopup
                        loading: true

                        Audio{}
                    }
                }
            }
        }
    }
}
