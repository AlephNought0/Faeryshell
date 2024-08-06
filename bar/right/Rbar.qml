import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire

import "../../"

RowLayout {
    id: root
    spacing: 10
    anchors.bottom: parent.bottom

    property string currDate

    SystemClock {
        id: clock

        property string hour: hours
        property string minute: minutes

        function getDate() {
            let today = new Date();
            let dd = String(today.getDate()).padStart(2, '0');
            let mm = String(today.getMonth() + 1).padStart(2, '0'); 
            let yyyy = today.getFullYear();

            let currHour = clock.hour.padStart(2, '0')
            let currMinute = clock.minute.padStart(2, '0')

            root.currDate = `${currHour}:${currMinute} ${dd}.${mm}.${yyyy}`
        }

        Component.onCompleted: {
            getDate()
        }

        onMinutesChanged: {
            getDate()
        }
    }

    Rectangle { //Audio
        width: 200
        height: panel.exclusiveZone - 5
        border.color: "black"
        border.width: 1.5
        radius: 10
        Layout.alignment: Qt.AlignLeft
        color: "purple"

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                parent.color = "grey"
            }

            onExited: {
                parent.color = "purple"
            }
        }

        PwObjectTracker {
            objects: [
                Pipewire.defaultAudioSink,
                Pipewire.defaultAudioSource
            ]
        }

        RowLayout {
            anchors.centerIn: parent
            spacing: 20

            RowLayout {
                id: input

                Text {
                    text: ""
                    font.family: Cfg.font
                    font.pixelSize: 20
                    color: "white"
                }

                Text {
                    text: Pipewire.defaultAudioSource != null ? 
                    `${Math.floor(Pipewire.defaultAudioSource.audio.volume * 100)}%` : "100%" 
                    font.family: Cfg.font
                    font.pixelSize: 20
                    color: "white"

                    MouseArea {
                        anchors.fill: parent

                        onWheel: event => {
                            if(event.angleDelta.y > 0) {
                                Pipewire.defaultAudioSource.audio.volume += 0.01
                            }

                            else {
                                Pipewire.defaultAudioSource.audio.volume -= 0.01
                            }
                        }
                    }
                }
            }

            RowLayout {
                id: output

                Text {
                    text: ""
                    font.family: Cfg.font
                    font.pixelSize: 20
                    color: "white"
                }

                Text {
                    text: Pipewire.defaultAudioSink != null ? 
                    `${Math.floor(Pipewire.defaultAudioSink.audio.volume * 100)}%` : "100%" 
                    font.family: Cfg.font
                    font.pixelSize: 20
                    color: "white"

                    MouseArea {
                        anchors.fill: parent

                        onWheel: event => {
                            if(event.angleDelta.y > 0) {
                                Pipewire.defaultAudioSink.audio.volume += 0.01
                            }

                            else {
                                Pipewire.defaultAudioSink.audio.volume -= 0.01
                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        Layout.preferredWidth: isHovered ? battery.width + internet.width + timeDate.width + 10 * 4 : 160
        height: panel.exclusiveZone - 5
        border.color: "black"
        border.width: 1.5
        radius: 10
        Layout.alignment: Qt.AlignRight
        color: "purple"
        clip: true

        property bool isHovered: false

        RowLayout {
            anchors {
                left: parent.left
                leftMargin: 10
            }
            spacing: 10

            Image {
                id: battery
                sourceSize.width: 35
                sourceSize.height: 35
                source: "../../icons/battery.svg"

                Rectangle {
                    width: parent.width - 15 //Not so nice but it works I guess
                    height: parent.height - 22
                    color: "white"

                    anchors {
                        left: parent.left
                        leftMargin: 7
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
                text: root.currDate
                font.family: Cfg.font
                font.pixelSize: 20
                color: "white"
            }
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                parent.color = "grey"
                parent.isHovered = true
            }

            onExited: {
                parent.color = "purple"
                parent.isHovered = false
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
