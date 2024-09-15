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

        onMinuteChanged: {
            getDate()
        }
    }

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

                Text {
                    text: Cfg.pipewire.source != null ? (Math.floor((Cfg.pipewire.source.audio.volume * 100)) == 0 || 
                    Cfg.pipewire.source.audio.muted ? "" : "") : null
                    font.family: Cfg.font
                    font.pixelSize: 20
                    color: "white"

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
                    Cfg.pipewire.sink.audio.muted ? "" : "") : null
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
                text: root.currDate
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
