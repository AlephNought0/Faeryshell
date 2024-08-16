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
                height: screen.height
                width: screen.width
                exclusiveZone: 40
                screen: modelData
                focusable: true
                color: "transparent"
                anchors {
                    top: true
                    left: true
                    right: true
                }

                property var modelData

                mask: Region { item: rect }

                Item {
                    id: rect
                    width: screen.width
                    height: panel.exclusiveZone

                    Lbar {
                        id: meow
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

                /*Item {
                    height: screen.height - panel.exclusiveZone
                    width: screen.height
                    anchors {
                        top: rect.bottom
                        left: panel.left
                        right: panel.right
                        bottom: panel.bottom
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            console.log("meow")
                        }
                    }
                }*/
            }
        }
    }
}
