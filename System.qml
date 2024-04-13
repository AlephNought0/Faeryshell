import Quickshell
import QtQuick
import QtQuick.Layouts
import QtCore

Item {
    height: parent.height
    width: 120
    
    Rectangle {
        id: row
        anchors.centerIn: parent
        width: 120
        height: parent.height - 5
        x: -100
        radius: 10
        color: "purple"

        property int originalWidth: 120

        MouseArea {
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            hoverEnabled: true

            onEntered: {
                parent.color = "grey"
                expand.running = true;
                xexpand.running = true;
            }

            onExited: {
                parent.color = "purple"
                retract.running = true;
            }
        }

        RowLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height
            width: parent.width - 15
            spacing: 4

            Rectangle {
                height: parent.height
                width: childrenRect.width
                color: "transparent"

                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    width: sourceSize.width * (height / sourceSize.height)
                    height: parent.height - 5
                    fillMode: Image.PreserveAspectFit
                    source: "icons/battery.svg"
                }
            }

            Rectangle {
                height: parent.height
                width: childrenRect.width
                color: "transparent"

                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    width: sourceSize.width * (height / sourceSize.height)
                    height: parent.height - 8
                    fillMode: Image.PreserveAspectFit
                    source: "icons/wifi_medium.svg"
                }
            }

            Text {
                text: "11:00"
                color: "white"
                font.pixelSize: 16  
                font.weight: 550
            }

            Text {
                text: "Mon, 07 April 2024"
                color: "white"
                font.pixelSize: 16  
                font.weight: 550
            }

            NumberAnimation {
                id: expand
                target: row
                property: "width"
                to: 120 + 100
                duration: 500
                easing.type: Easing.InOutQuad
            }

            NumberAnimation {
                id: xexpand
                target: row
                property: "x"
                by: -100
                duration: 500
                easing.type: Easing.InOutQuad
            }

            NumberAnimation {
                id: retract
                target: row
                property: "width"
                to: 120
                duration: 500
                easing.type: Easing.InOutQuad
            }
        }
    }
}