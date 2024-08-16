import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.DBusMenu

import "../../"

Rectangle {
    id: root
    width: row.width
    height: row.height
    radius: 10
    color: "transparent"
    anchors.fill: parent

    required property var entry
    property bool showChildren: false

    Timer {
        id: closeTray
        interval: 100
        running: false
        repeat: false

        onTriggered: {
            showChildren = false
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true

        visible: !entry.isSeparator

        onEntered: {
            parent.color = "gray"

            if(entry.hasChildren) {
                root.showChildren = true
            }
        }

        onExited: {
            parent.color = "transparent"

            if(entry.hasChildren) {
                closeTray.running = true
            }
        }

        onClicked: {
            entry.triggered()

            if(entry.buttonType == QsMenuButtonType.None) {
                iconMenu.isOpen = false
            }
        }
    }

    RowLayout {
        id: row

        Item {
            implicitWidth: 22
            implicitHeight: 22

            Rectangle {
                width: 22
                height: 22
                visible: entry.hasChildren
            }

            Rectangle { //Checkbox
                width: 18
                height: 18
                anchors.centerIn: parent
                visible: entry.buttonType == QsMenuButtonType.CheckBox
                radius: 3
                border.color: "black"
                border.width: 1.5
                color: "transparent"

                Rectangle {
                    radius: 1
                    visible: entry.checkState === Qt.Checked
                    color: "white"
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        left: parent.left
                        right: parent.right

                        topMargin: 3.5
                        bottomMargin: 3.5
                        leftMargin: 3.5
                        rightMargin: 3.5
                    }
                }
            }

            Rectangle {
                width: 18
                height: 18
                anchors.centerIn: parent
                visible: entry.buttonType == QsMenuButtonType.RadioButton
                radius: 10
                border.color: "black"
                border.width: 1.5
                color: "transparent"

                Rectangle {
                    radius: 10
                    visible: entry.checkState == Qt.Checked
                    color: "white"
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        left: parent.left
                        right: parent.right

                        topMargin: 2.5
                        bottomMargin: 2.5
                        leftMargin: 2.5
                        rightMargin: 2.5
                    }
                    
                }
            }
        }

        Text {
            text: entry.text
            color: entry.enabled ? "white" : "#bbbbbb"
            font.family: Cfg.font
            font.pixelSize: 18
        }

        QsMenuOpener {
            id: openChildren

            Component.onCompleted: {
                if(entry.hasChildren) {
                    openChildren.menu = entry
                }
            }
        }

        MenuList {
            id: children
            items: openChildren.children
            visible: showChildren || children.hovered
            xCor: root.width + 30
            yCor: trayIcons.height + 5 + (3 * 22)
        }
    }
}
