import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.SystemTray

import "../../"

RowLayout {
    spacing: 10

    Rectangle { //Tray icons
        id: trayIcons
        width: 200
        height: panel.exclusiveZone - 5
        border.color: "black"
        border.width: 1.5
        radius: 10
        color: "purple"

        property var selectedMenu: null

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

                    onIsOpenChanged: {
                        if(!isOpen) {
                            trayMenu.menu = null
                        }
                    }

                    Timer {
                        id: openDelay
                        interval: 100
                        running: false
                        repeat: false

                        onTriggered: {
                            iconMenu.isOpen = !iconMenu.isOpen
                        }
                    }

                    QsMenuOpener {
                        id: trayMenu
                        menu: modelData.menu
                    }

                    Image {
                        id: tr
                        source: modelData.icon
                        height: width
						anchors {
							left: parent.left
							right: parent.right
							verticalCenter: parent.verticalCenter
                        }

                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton | Qt.RightButton

                            onClicked: event => {
                                if(event.button === Qt.LeftButton) {
                                    modelData.activate()
                                }

                                else if(event.button === Qt.RightButton) {
                                    trayMenu.menu = modelData.menu
                                    trayIcons.selectedMenu = itemMenu

                                    const window = QsWindow.window
                                    const widgetRect = window.contentItem.mapFromItem(tr, -10, tr.height + 10)

                                    itemMenu.anchor.rect = widgetRect

                                    openDelay.running = true
                                }
                            }
                        }
                    }

                    MenuList {
                        id: itemMenu
                        items: trayMenu == null ? [] : trayMenu.children
                        visible: itemMenu == trayIcons.selectedMenu && iconMenu.isOpen && trayMenu.menu !== null

                        Connections {
                            target: trayIcons

                            function onSelectedMenuChanged() {
                                if(trayIcons.selectedMenu != itemMenu) {
                                    iconMenu.isOpen = false
                                }
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
