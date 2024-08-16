import QtQuick
import QtQuick.Layouts
import Quickshell

import "../../"

PopupWindow {
    id: root
    anchor.rect.x: xCor
    anchor.rect.y: yCor
    anchor.window: panel
    width: menuColumn.width + 20
    height: menuColumn.height + 20
    color: "transparent"

    required property real xCor
    required property real yCor
    required property var items
    property real maxWidth: 0
    property bool hovered: false

    mask: Region { item: trayList }

    MouseArea {
        id: test
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
            width: menuColumn.width + 20
            height: menuColumn.height + 20
            radius: 10
            border.color: "black"
            border.width: 1.5
            visible: true
            color: "purple"

            ColumnLayout {
                id: menuColumn
                spacing: 5
                anchors.centerIn: parent

                Repeater {
                    model: items

                    Loader {
                        height: childrenRect.height
                        width: childrenRect.width
                        required property var modelData;

                        BoundComponent {
                            id: menuItem
                            source: "MenuItem.qml"
                            width: childrenRect.width
                            height: childrenRect.height

                            property var entry: modelData

                            Component.onCompleted: {
                                if(root.maxWidth < width) {
                                    root.maxWidth = width + 20
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
                                left: parent.left
                                right: parent.right
                                top: parent.top
                                bottom: parent.bottom

                                topMargin: 11
                                bottomMargin: 11
                            }
                        }
                    }
                }
            }
        }
    }
}
