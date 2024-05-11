import Quickshell
import QtQuick
import QtQuick.Layouts
import "../Functionality"
import ".."

Rectangle {
    anchors.centerIn: parent
    width: 300
    height: 30
    radius: 10
    color: "purple"

    MouseArea {
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        hoverEnabled: true

        onEntered: {
            parent.color = "grey"
        }

        onExited: {
            parent.color = "purple"
        }

        onClicked: {
            if(mediaPopup.item.targetVisible == false) {
                mediaPopup.item.targetVisible = true
            }

            else {
                mediaPopup.item.targetVisible = false
            }
        }
    }

    RowLayout {
        height: parent.height
        width: parent.width - 20
        anchors.centerIn: parent
        clip: true

        Rectangle {
            id: icon
            height: parent.height
            width: childrenRect.width
            color: "transparent"

            Image {
                anchors.verticalCenter: parent.verticalCenter
                sourceSize.height: parent.height - 10
                fillMode: Image.PreserveAspectFit
                source: "../icons/chromium.svg"
            }
        }

        Item {
            id: titleContainer
            width: parent.width - icon.width
            height: parent.height
            property string text: Mpris.mediaTitle
            property string spacing: " " 
            property string combined: text + spacing
            property string display: combined.substring(step) + combined.substring(0, step)
            property int step: 0
            clip: true

            Timer {
                id: timer
                interval: 200
                running: false
                repeat: true
                onTriggered: {
                    parent.step = (parent.step + 1) % parent.combined.length
                } 
            }

            Timer {
                id: textCheck
                interval: 200
                running: false
                onTriggered: {
                    if(title.width > parent.width - icon.width + 10) {
                        title.anchors.horizontalCenter = undefined
                        timer.running = true
                    }

                    else {
                        parent.step = 0
                        title.anchors.horizontalCenter = parent.horizontalCenter
                        timer.running = false
                    }
                } 
            }

            Text {
                id: title
                text: parent.display
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 14
                font.weight: 650
                font.family: Main.fontSource
                color: "white"

                onWidthChanged: {
                    textCheck.running = true
                }
            }
        }
    }
}
