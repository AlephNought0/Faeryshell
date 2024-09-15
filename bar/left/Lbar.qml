import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.SystemTray

import ".."
import "../../"

RowLayout {
    spacing: 10

    Rectangle { //Tray icons
        id: trayIcons
        Layout.minimumWidth: 45
        Layout.preferredWidth: trayRow.width + 20
        color: Cfg.colors.primaryColor
        height: panel.height - 5
        radius: 10
        clip: true

        property var selectedMenu: null
        property int allItems: SystemTray.items.values.length

        RowLayout {
            id: trayRow
            height: 35
            layoutDirection: Qt.RightToLeft

            anchors {
                right: parent.right
                rightMargin: 10
                verticalCenter: parent.verticalCenter
            }

            Repeater {
                id: test
                model: SystemTray.items

                Item {
                    id: iconMenu
                    Layout.fillHeight: true
                    implicitWidth: 25

                    property bool isOpen: false

                    Timer {
                        id: openDelay
                        interval: 100
                        running: false
                        repeat: false

                        onTriggered: {
                            itemMenu.targetVisible = !itemMenu.targetVisible
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
                        offset: trayIcons.allItems - SystemTray.items.indexOf(modelData)
                        visible: itemMenu == trayIcons.selectedMenu && iconMenu.isOpen

                        Connections {
                            target: trayIcons

                            function onSelectedMenuChanged() {
                                if(trayIcons.selectedMenu != itemMenu) {
                                    itemMenu.targetVisible = false
                                }
                            }
                        }
                    }
                }
            }
        }

        Hover {
            item: parent
        }

        Behavior on Layout.preferredWidth {
            NumberAnimation {
                duration: 100
                easing.type: Easing.OutQuad
            }
        }
    }

    Rectangle { //Usage info
        Layout.preferredWidth: sysInfo.width + 30
        height: panel.height - 5
        radius: 10
        color: Cfg.colors.primaryColor

        Hover {
            item: parent
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
