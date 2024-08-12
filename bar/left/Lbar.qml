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
                    Layout.fillHeight: true
                    implicitWidth: 30

                    QsMenuOpener {
                        id: trayMenu
                        menu: modelData.menu
                    }

                    SystemTrayMenuWatcher {
						id: menuWatcher;
						trayItem: modelData;
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

                    MouseArea {
                        anchors.fill: parent

                        onClicked: event => {
                            if(event.button === Qt.LeftButton) {
                                modelData.activate()
                            }

                            else if(event.button === Qt.RightButton) {
                                //trayMenu.close()
                            }
                        }
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            propagateComposedEvents: true

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
