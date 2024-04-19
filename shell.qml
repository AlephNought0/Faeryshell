import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Wayland
import "Bar"
import "Bar/Media"
import "Functionality"

ShellRoot {
    Variants {
        model: Quickshell.screens

        delegate: Component {
            
            PanelWindow {
                id: panel

                anchors {
                    top: true
                    left: true
                    right: true
                }

                property var modelData
                screen: modelData

                height: 35
                color: "transparent"

                Left{}

                Media{}

                Right{}

                LazyLoader {
                    id: mediaPopup
                    loading: true

                    Interface{}
                }
            }
        }
    }
}
