import Quickshell
import QtQuick
import QtQuick.Layouts
import QtCore
import "../Functionality"
import ".."

RowLayout {
    id: layout
    height: 30
    spacing: 10
    anchors.right: parent.right
    anchors.bottom: parent.bottom

    readonly property int layoutSpacing: layout.spacing

    Rectangle { //Audio
        id: audio
        width: 110
        height: parent.height
        radius: 10
        anchors.left: parent.left
        color: "purple"

        MouseArea {
            id: mouseArea
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
                if(audioPopup.item.targetVisible == false) {
                    audioPopup.item.targetVisible = true
                }

                else {
                    audioPopup.item.targetVisible = false
                }
            }
        }

        Connections { 
            target: mouseArea

            function onWheel(wheel) {
               if (wheel.angleDelta.y > 0) {
                    AudioControl.volumeUp();
                } 
                
                else {
                    AudioControl.volumeDown();
                }
            }
        }

        RowLayout {
            height: parent.height
            width: parent.width - 50
            anchors.centerIn: parent
            spacing: 5

            Rectangle {
                height: parent.height
                width: childrenRect.width
                color: "transparent"

                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    sourceSize.height: parent.height - 10
                    fillMode: Image.PreserveAspectFit
                    source: "../icons/audio_full.svg"
                }
            }

            Text {
                font.pixelSize: 14
                font.weight: 650
                font.family: Main.fontSource
                color: "white"
                text: AudioControl.volume
            }
        }
    }


    Rectangle { //System
        id: sys
        width: 130
        height: parent.height
        anchors.right: parent.right
        radius: 10
        color: "purple"

        readonly property int originalWidth: 130

        MouseArea {
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            hoverEnabled: true

            onEntered: {
                parent.color = "grey"
                lExpand.running = true;
                expand.running = true;
            }

            onExited: {
                parent.color = "purple"
                lRetract.running = true;
                retract.running = true;
            }
        }

        RowLayout {
            id: systemContent
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height
            width: parent.width - 25
            spacing: 10
            clip: true

            readonly property int sySpacing: systemContent.spacing

            Canvas {
                id: canvas
                height: parent.height - 3
                width: 25

                onPaint: {
                    var ctx = getContext("2d")

                    ctx.fillStyle = "white"
                    ctx.fillRect(5.5, 10, Battery.capacity, canvas.height - 20)

                    ctx.stroke()
                }

                Connections {
                    target: Battery

                    function onCapacityChanged() { 
                        canvas.requestPaint()
                    }
                }

                Image {
                    id: skibidi
                    parent: null
                    anchors.verticalCenter: parent.verticalCenter
                    width: canvas.width
                    height: canvas.height
                    fillMode: Image.PreserveAspectFit
                    source: "../icons/battery.svg"
                }
            }

            Rectangle {
                id: internet
                height: parent.height - 5
                width: childrenRect.width
                color: "transparent"

                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    sourceSize.height: parent.height - 5
                    fillMode: Image.PreserveAspectFit
                    source: Signal.icon
                }
            }

            Text {
                id: hours
                text: Singl.formattedHours
                color: "white"
                font.pixelSize: 15
                font.weight: 650
                font.family: Main.fontSource
            }

            Text {
                id: hiddenText
                text: Singl.formattedDate
                color: "white"
                font.pixelSize: 15
                font.weight: 650
                font.family: Main.fontSource
            }

            NumberAnimation {
                id: expand
                target: sys
                property: "width"
                to: sys.originalWidth + hiddenText.width + systemContent.sySpacing
                duration: 200
                easing.type: Easing.OutQuad
            }

            NumberAnimation {
                id: retract
                target: sys
                property: "width"
                to: sys.originalWidth
                duration: 200
                easing.type: Easing.OutQuad
            }

            NumberAnimation {
                id: lExpand
                target: layout
                property: "width"
                to: audio.width + sys.originalWidth + hiddenText.width + systemContent.sySpacing + layout.layoutSpacing
                duration: 200
                easing.type: Easing.OutQuad
            }

            NumberAnimation {
                id: lRetract
                target: layout
                property: "width"
                to: audio.width + sys.originalWidth + 10
                duration: 200
                easing.type: Easing.OutQuad
            }
        }
    }
}
