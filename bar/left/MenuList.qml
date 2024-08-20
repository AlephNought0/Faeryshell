import QtQuick
import QtQuick.Layouts
import Quickshell

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

    mask: Region { item: trayList }

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
            visible: true
            color: "purple"

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
        }
    }
}
