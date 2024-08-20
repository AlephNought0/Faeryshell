import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.DBusMenu

import "../../"

Rectangle {
    id: root
    width: row.width + 22
    height: row.height
    radius: 5
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
                const window = QsWindow.window
                const widgetRect = window.contentItem.mapFromItem(tr, trayList.width - 5, trayList.height * 0.55)

                children.anchor.rect = widgetRect

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
                itemMenu.targetVisible = false
            }
        }
    }

    RowLayout {
        id: row

        Item {
            id: buttonItem
            implicitWidth: 22
            implicitHeight: 22

            Text {
                text: "󰚈"
                visible: entry.hasChildren
                anchors.centerIn: parent
                color: "white"
                font.family: Cfg.font
                font.pixelSize: 26
            }

            Text {
                text: entry.checkState === Qt.Checked ? "󰡖" : ""
                visible: entry.buttonType == QsMenuButtonType.CheckBox
                anchors.centerIn: parent
                color: "white"
                font.family: Cfg.font
                font.pixelSize: entry.checkState === Qt.Checked ? 28 : 24 
            }

            Text {
                text: entry.checkState === Qt.Checked ? "󰪥" : ""
                visible: entry.buttonType == QsMenuButtonType.RadioButton
                anchors.centerIn: parent
                color: "white"
                font.family: Cfg.font
                font.pixelSize: entry.checkState === Qt.Checked ? 28 : 22
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
        }
    }
}
