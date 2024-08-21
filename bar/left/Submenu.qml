import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

import "../../"

PopupWindow {
    id: root
    anchor.rect.x: 0
    anchor.rect.y: 0
    anchor.window: panel
    width: menuColumn.width + 22
    height: menuColumn.height + 22
    color: "transparent"

    required property var items
    property real maxWidth: 0
    property bool hovered: false
    property bool targetVisible: false

    mask: Region { item: trayList }

    onHoveredChanged: {
        if(!targetVisible && !hovered){
            trayList.opacity = 0
        }
        
    }

    onTargetVisibleChanged: {
        if(targetVisible) {
            trayList.opacity = 1
            grab.active = true
            grab.windows.push(root)
            row.isOpen = true
        }

        else if(!targetVisible && !hovered){
            trayList.opacity = 0
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            hovered = true
        }

        onExited: {
            hovered = false
        }
    
        Rectangle {
            id: trayList
            width: menuColumn.width + 22
            height: menuColumn.height + 22
            radius: 10
            border.color: "black"
            border.width: 1.5
            opacity: 0
            color: "purple"

            onOpacityChanged: {
                if(trayList.opacity == 0) {
                    row.isOpen = false
                }
            }

            ColumnLayout {
                id: menuColumn
                spacing: 3
                anchors.centerIn: parent

                Repeater {
                    model: items

                    Loader {
                        height: modelData.isSeparator ? 14 : childrenRect.height
                        width: childrenRect.width

                        required property var modelData;

                        BoundComponent {
                            id: menuItem
                            source: "MenuItem.qml"
                            width: childrenRect.width
                            height: childrenRect.height
                            bindValues: false

                            property var entry: modelData

                            Component.onCompleted: {
                                if(root.maxWidth < width) {
                                    root.maxWidth = width
                                }

                                else {
                                    width = root.maxWidth
                                }
                            }

                            Connections {
                                target: root

                                function onMaxWidthChanged() {
                                    if(menuItem.width < root.maxWidth) {
                                        menuItem.width = root.maxWidth
                                    }
                                }
                            }
                        }

                        Rectangle {
                            visible: modelData.isSeparator
                            anchors {
                                fill: parent
                                topMargin: 6
                                bottomMargin: 6
                            }
                        }
                    }
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 150
                }
            }
        }
    }
}
