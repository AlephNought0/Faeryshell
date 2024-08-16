import QtQuick
import QtQuick.Layouts

import "../../"
import "../left/Lbar.qml"
import "../../functions"

Rectangle {
    id: root
    height: parent.height - 5
    width: 350
    radius: 10
    border.color: "black"
    border.width: 1.5
    clip: true
    color: "purple"

    property int spacing: 20

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            parent.color = "grey"
        }

        onExited: {
            parent.color = "purple"
        }

        onClicked: {
            mediaPopup.item.targetVisible = !mediaPopup.item.targetVisible
        }
    }

    Text {
        id: title
        x: (root.width / 2) - (width / 2)
        anchors.verticalCenter: parent.verticalCenter
        text: Mpris.mediaTitle
        font.pixelSize: 16
        font.family: Cfg.font
        color: "white"

        NumberAnimation {
            id: movingText
            running: false
            property: "x"
            target: title
            from: 0
            to: -title.width - root.spacing
            duration: title.width * 9
            loops: Animation.Infinite
        }
        

        Text {
            x: movingText.running ? title.width + root.spacing : root.width 
            text: title.text
            font.pixelSize: parent.font.pixelSize
            font.family: parent.font.family
            color: parent.color
        }

        onWidthChanged: {
            if(width > parent.width) {
                movingText.running = true
            }

            else {
                movingText.running = false
            }
        }
    }
}
