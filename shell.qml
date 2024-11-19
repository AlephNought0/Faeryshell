import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick

import "./bar/left"
import "./bar/mid"
import "./bar/right"
import "./bar/main"
import "./functions"

ShellRoot {
    Variants {
        model: Quickshell.screens

        delegate: Component {
            
            PanelWindow {
                id: panel
                height: 40
                width: screen.width
                screen: modelData
                WlrLayershell.namespace: "ohio"
                WlrLayershell.keyboardFocus: "OnDemand"
                color: "transparent"
                anchors {
                    top: true
                    left: true
                    right: true
                }

                property var modelData

                Lbar {
                    anchors {
                        bottom: parent.bottom
                        left: parent.left
                        leftMargin: 10
                    }
                }

                Mbar {
                    anchors {
                        bottom: parent.bottom
                        horizontalCenter: parent.horizontalCenter
                    }
                }

                Rbar {
                    anchors {
                        bottom: parent.bottom
                        right: parent.right
                        rightMargin: 10
                    }
                }

                Swww{}

                LazyLoader {
                    id: mediaPopup
                    loading: true

                    MediaInterface{}
                }

                LazyLoader {
                    id: audioPopup
                    loading: true

                    AudioInterface{}
                }

                LazyLoader {
                    id: sysPopup
                    loading: true

                    SystemInterface{}
                }
            }
        }
    }
}
