import Quickshell
import QtQuick
import QtQuick.Layouts

Item {
    height: parent.height
    width: childrenRect.width
    anchors.left: parent.left

    RowLayout {
        height: parent.height
        width: childrenRect.width
        spacing: 10

        Tray{}

        Usage{}
    }
}