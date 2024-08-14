import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

import "../../"

RowLayout {
    spacing: 10

    Rectangle { //Tray icons
        width: 200
        height: panel.exclusiveZone - 5
        border.color: "black"
        border.width: 1.5
        radius: 10
        color: "purple"

        RowLayout {
            anchors.centerIn: parent
            height: 35

            Repeater {
                model: SystemTray.items

                Item {
                    id: iconMenu
                    Layout.fillHeight: true
                    implicitWidth: 25

                    property bool isOpen: false

                    QsMenuOpener {
                        id: trayMenu
                        menu: modelData.menu
                    }

                    Image {
                        source: modelData.icon
                        height: width
						anchors {
							left: parent.left
							right: parent.right
							verticalCenter: parent.verticalCenter
						}                        
                    }

                    MenuList {
                        id: itemMenu
                        items: trayMenu == null ? [] : trayMenu.children
                        y: panel.exclusiveZone
                        visible: isOpen 
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true

                        acceptedButtons: Qt.LeftButton | Qt.RightButton

                        onClicked: event => {
                            if(event.button === Qt.LeftButton) {
                                modelData.activate()
                                console.log("eh")
                            }

                            else if(event.button === Qt.RightButton) {
                                iconMenu.isOpen = !iconMenu.isOpen

                                console.log("meow")
                            }
                        }
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                parent.color = "grey"
            }

            onExited: {
                parent.color = "purple"
            }
        }
    }

    Rectangle { //Usage info
        Layout.preferredWidth: sysInfo.width + 30
        height: panel.exclusiveZone - 5
        border.color: "black"
        border.width: 1.5
        radius: 10
        color: "purple"

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                parent.color = "grey"
            }

            onExited: {
                parent.color = "purple"
            }
        }

        RowLayout {
            id: sysInfo
            spacing: 30
            anchors.centerIn: parent


            RowLayout {
                Text {
                    text: ""
                    font.pixelSize: 20
                    font.family: Cfg.font
                    color: "white"
                }

                Text {
                    text: "0.1%"
                    font.pixelSize: 20
                    font.family: Cfg.font
                    color: "white"
                }
            }

            RowLayout {
                Text {
                    text: ""
                    font.pixelSize: 20
                    font.family: Cfg.font
                    color: "white"
                }

                Text {
                    text: "1.3G"
                    font.pixelSize: 20
                    font.family: Cfg.font
                    color: "white"
                }
            }
        }
    }
}
