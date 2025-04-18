import QtQuick
import QtQuick.Layouts

import ".."
import "../../"
import "../../functions"

Rectangle {
    id: root
    height: parent.height - 5
    width: 350
    radius: 10
    clip: true
    color: Cfg.colors.primaryColor

    property int spacing: 20

    Hover {
        item: parent

        onClicked: {
            mediaPopup.item.targetVisible = !mediaPopup.item.targetVisible
        }
    }

    Item {
        id: titleWrap
        height: parent.height
        width: parent.width - 10
        anchors.centerIn: parent
        clip: true

        Text {
            id: title
            x: (titleWrap.width / 2) - (width / 2)
            anchors.verticalCenter: parent.verticalCenter
            text: Mpris.mediaTitle.length == 0 ? " " : Mpris.mediaTitle 
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
                x: movingText.running ? title.width + root.spacing : titleWrap.width 
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
}
