import QtQuick
import QtQuick.Layouts
import Quickshell

import "../../"

Rectangle {
    id: root
    width: menuColumn.width + 20
    height: menuColumn.height + 20
    radius: 10
    border.color: "black"
    border.width: 1.5

    required property var items

    color: "purple"

    MouseArea {
        anchors.fill: parent

        onClicked: {
            console.log("meow")
        }
    }

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
                }
            }
        }
    }
}
