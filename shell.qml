import Quickshell
import Quickshell.Wayland
import QtQuick

import "./bar/left"
import "./bar/mid"
import "./bar/right"


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
                exclusiveZone: 40
                color: "transparent"

                Item {
                    id: rect
                    width: screen.width
                    height: panel.exclusiveZone

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

                    LazyLoader {
                        id: mediaPopup
                        loading: true

                        MediaInterface{}
                    }
                }
            }
        }
    }
}
