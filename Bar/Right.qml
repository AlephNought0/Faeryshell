import Quickshell
import QtQuick
import QtQuick.Layouts
import QtCore
import "../Functionality"

RowLayout {
    id: layout
    height: parent.height
    spacing: 10
    anchors.right: parent.right

    readonly property int layoutSpacing: layout.spacing

    Rectangle { //Audio
        id: audio
        width: 110
        height: parent.height - 5
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
        }

        Text {
            anchors.centerIn: parent
            text: "Audio"
            color: "white"
            font.pixelSize: 16  
            font.weight: 550
        }
    }


    Rectangle { //System
        id: sys
        width: 125
        height: parent.height - 5
        radius: 10
        color: "purple"

        readonly property int originalWidth: 125

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
            width: parent.width - 20
            spacing: 10
            clip: true

            readonly property int sySpacing: systemContent.spacing

            Canvas {
                id: battery
                height: parent.height - 3
                width: 25

                onPaint: {
                    var ctx = getContext("2d");
        
                    ctx.beginPath();
                    ctx.stroke();

                    ctx.fillStyle = "white";
                    ctx.fillRect(5.5, 10, Battery.capacity, battery.height - 20);
                }

                Image {
                    id: skibidi
                    parent: null
                    width: battery.width
                    height: battery.height
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
                    id: test
                    anchors.verticalCenter: parent.verticalCenter
                    height: parent.height - 5
                    width: sourceSize.width * (height / sourceSize.height)
                    fillMode: Image.PreserveAspectFit
                    source: Signal.icon
                }
            }

            Text {
                id: hours
                text: Singl.formattedHours
                color: "white"
                font.pixelSize: 16  
                font.weight: 550
            }

            Text {
                id: hiddenText
                text: Singl.formattedDate
                color: "white"
                font.pixelSize: 16  
                font.weight: 550
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
