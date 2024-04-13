import Quickshell
import QtQuick
import QtQuick.Layouts
import QtCore

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
        anchors.left: parent.left

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
        width: 120
        height: parent.height - 5
        radius: 10
        color: "purple"
        anchors.right: parent.right

        readonly property int originalWidth: 120

        MouseArea {
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            hoverEnabled: true

            onEntered: {
                parent.color = "grey"
                test.running = true;
                expand.running = true;
            }

            onExited: {
                parent.color = "purple"
                untest.running = true;
                retract.running = true;
            }
        }

        RowLayout {
            id: systemContent
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height
            width: parent.width - 20
            spacing: 4
            clip: true

            readonly property int sySpacing: systemContent.spacing

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
                id: test
                target: layout
                property: "width"
                to: audio.width + sys.originalWidth + hiddenText.width + systemContent.sySpacing + layout.layoutSpacing
                duration: 200
                easing.type: Easing.OutQuad
            }

            NumberAnimation {
                id: untest
                target: layout
                property: "width"
                to: audio.width + sys.originalWidth + 10
                duration: 200
                easing.type: Easing.OutQuad
            }
        }
    }
}
