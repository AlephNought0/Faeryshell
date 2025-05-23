import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower

import ".."
import "../../"

RowLayout {
    id: root
    spacing: 10

    property string hour: Cfg.time.hours.padStart(2, '0')
    property string minute: Cfg.time.minutes.padStart(2, '0')
    property string year: Cfg.time.year
    property string month: (Cfg.time.month).padStart(2, '0')
    property string day: Cfg.time.day.padStart(2, '0')

    Rectangle { //Audio
        width: 200
        height: panel.height - 5
        radius: 10
        Layout.alignment: Qt.AlignLeft
        color: Cfg.colors.primaryColor

        Hover {
            item: parent
            z: 100

            onClicked: {
                audioPopup.item.targetVisible = !audioPopup.item.targetVisible
            }
        }

        RowLayout {
            anchors.centerIn: parent
            spacing: 20

            RowLayout {
                id: input
                spacing: Cfg.pipewire.source != null ? (Cfg.pipewire.source.audio.muted ? -1 : 5) : null

                Text {
                    text: Cfg.pipewire.source != null ? (Math.floor((Cfg.pipewire.source.audio.volume * 100)) == 0 || 
                    Cfg.pipewire.source.audio.muted ? "" : "") : " "
                    font.family: Cfg.font
                    font.pixelSize: 20
                    color: "white"
                    Layout.leftMargin: Cfg.pipewire.source != null ? (Cfg.pipewire.source.audio.muted ? -5 : 0) : null

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.RightButton

                        onClicked: {
                            Cfg.pipewire.source.audio.muted = !Cfg.pipewire.source.audio.muted
                        }
                    }
                }

                Text {
                    text: Cfg.pipewire.source != null ? 
                    `${Math.floor(Cfg.pipewire.source.audio.volume * 100)}%` : "100%" 
                    font.family: Cfg.font
                    font.pixelSize: 20
                    color: "white" 

                    MouseArea {
                        anchors.fill: parent

                        onWheel: event => {
                            if(event.angleDelta.y > 0) {
                                Cfg.pipewire.source.audio.volume += 0.01
                            }

                            else {
                                Cfg.pipewire.source.audio.volume -= 0.01
                            }
                        }
                    }
                }
            }

            RowLayout {
                id: output

                Text {
                    text: Cfg.pipewire.sink != null ? (Math.floor((Cfg.pipewire.sink.audio.volume * 100)) == 0 ||
                    Cfg.pipewire.sink.audio.muted ? "" : "") : " "
                    font.family: Cfg.font
                    font.pixelSize: 20
                    color: "white"

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.RightButton

                        onClicked: {
                            Cfg.pipewire.sink.audio.muted = !Cfg.pipewire.sink.audio.muted
                        }
                    }
                }

                Text {
                    text: Cfg.pipewire.sink != null ? 
                    `${Math.floor(Cfg.pipewire.sink.audio.volume * 100)}%` : "100%" 
                    font.family: Cfg.font
                    font.pixelSize: 20
                    color: "white"

                    MouseArea {
                        anchors.fill: parent

                        onWheel: event => {
                            if(event.angleDelta.y > 0) {
                                Cfg.pipewire.sink.audio.volume += 0.01
                            }

                            else {
                                Cfg.pipewire.sink.audio.volume -= 0.01
                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: sysWidget
        Layout.preferredWidth: isHovered ? battery.width + internet.width + timeDate.width + 10 * 4 : 160
        height: panel.height - 5
        radius: 10
        Layout.alignment: Qt.AlignRight
        color: Cfg.colors.primaryColor
        clip: true

        property bool isHovered: false

        RowLayout {
            spacing: 10
            anchors {
                left: parent.left
                leftMargin: 10
            }

            Image {
                id: battery
                sourceSize.width: 35
                sourceSize.height: 35
                source: "../../icons/battery.svg"

                Rectangle {
                    width: Cfg.bat != null ? ((parent.width - 13.5) * Cfg.bat.percentage) : null
                    height: parent.height - 22
                    color: "white"

                    anchors {
                        left: parent.left
                        leftMargin: 6
                        verticalCenter: parent.verticalCenter
                    }
                }
            }

            Image {
                id: internet
                sourceSize.width: 25
                sourceSize.height: 25
                source: "../../icons/ethernet.svg"
            }

            Text {
                id: timeDate
                text: `${hour}:${minute} ${day}.${month}.${year}`
                font.family: Cfg.font
                font.pixelSize: 20
                color: "white"
            }
        }

        Hover {
            id: mouse
            item: parent

            onEntered: {
                parent.isHovered = true
            }

            onExited: {
                parent.isHovered = false
            }

            onClicked: {
                sysPopup.item.targetVisible = !sysPopup.item.targetVisible
            }
        }

        Behavior on Layout.preferredWidth {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutQuad
            }
        }
    }
}
