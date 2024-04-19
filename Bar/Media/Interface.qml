import Quickshell
import QtQuick
import QtQuick.Effects
import Quickshell.Io
import QtQuick.Layouts

import ".."
import "../.."
import "../../Functionality"


PopupWindow {
    id: mediaParent
    parentWindow: panel
    relativeX: parentWindow.width / 2 - width / 2
    relativeY: parentWindow.height + 15
    width: 500
    height: 220
    color: "transparent"

    property bool targetVisible: false

    onTargetVisibleChanged: {
        if(targetVisible == true) {
            mediaInterface.opacity = 1
            showMedia.running = true
            visible = true
        }

        else {
            hideMedia.running = true
        }
    }

    NumberAnimation {
        id: showMedia
        target: mediaInterface
        property: "y"
        from: panel.height - 200
        to: 0
        duration: 400
        easing.type: Easing.OutBack
    }

    NumberAnimation {
        id: hideMedia
        target: mediaInterface
        property: "opacity"
        from: 1
        to: 0
        duration: 150
    }

    Rectangle {
        id: mediaInterface
        width: parent.width
        height: 200
        radius: 10
        color: "purple"

        onOpacityChanged: {
            if(opacity == 0) {
                mediaParent.visible = false
            }
        }

        Rectangle {
            width: 200
            height: parent.height
            color: "purple"
            radius: 10
            z: 1

            Image {
                id: sourceItem
                source: Mpris.albumImage
                anchors.left: parent.left
                width: parent.width
                height: parent.height
                visible: false
                z: 1
            }

            MultiEffect {
                source: sourceItem
                anchors.fill: sourceItem
                maskEnabled: true
                maskSource: mask
                z: 1
            }

            Item {
                id: mask
                width: sourceItem.width
                height: sourceItem.height
                layer.enabled: true
                visible: false
                z: 1

                Rectangle {
                    width: sourceItem.width
                    height: sourceItem.height
                    radius: 10
                    color: "black"
                    z: 1
                }
            }
        }

        Rectangle {
            width: 70
            height: parent.height
            radius: 10
            x: sourceItem.width - 15
            z: 0
            color: "pink"

            ColumnLayout {
                height: parent.height - 40
                width: parent.width - 30
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right

                Rectangle {
                    width: 25
                    height: 25
                    radius: 5
                    color: "transparent"

                    MouseArea {
                        anchors.centerIn: parent
                        width: parent.width
                        height: parent.height
                        hoverEnabled: true

                        onEntered: {
                            parent.color = "grey"
                        }

                        onExited: {
                            parent.color = "transparent"
                        }

                        onClicked: {
                            Mpris.backClick()
                        }
                    }

                    Image {
                        width: parent.width - 10
                        height: parent.height - 10
                        anchors.centerIn: parent
                        source: "../../icons/backwards.svg"
                    }
                }

                Rectangle {
                    width: 25
                    height: 25
                    radius: 5
                    color: "transparent"

                    MouseArea {
                        anchors.centerIn: parent
                        width: parent.width
                        height: parent.height
                        hoverEnabled: true

                        onEntered: {
                            parent.color = "grey"
                        }

                        onExited: {
                            parent.color = "transparent"
                        }

                        onClicked: {
                            if(Mpris.playing == false) {
                                Mpris.playClick()
                            }

                            else {
                                Mpris.pauseClick()
                            }
                        }
                    }

                    Image {
                        width: parent.width - 10
                        height: parent.height - 10
                        anchors.centerIn: parent
                        source: Mpris.status
                    }
                }

                Rectangle {
                    width: 25
                    height: 25
                    radius: 5
                    color: "transparent"

                    MouseArea {
                        anchors.centerIn: parent
                        width: parent.width
                        height: parent.height
                        hoverEnabled: true

                        onEntered: {
                            parent.color = "grey"
                        }

                        onExited: {
                            parent.color = "transparent"
                        }

                        onClicked: {
                            Mpris.nextClick()
                        }
                    }

                    Image {
                        width: parent.width - 10
                        height: parent.height - 10
                        anchors.centerIn: parent
                        source: "../../icons/forward.svg"
                    }
                }
            }
        }
    }
}
