import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import ".."
import "../.."

Canvas {
    id: root
    width: 100
    height: 100
    Layout.alignment: Qt.AlignHCenter

    required property real progress
    required property string icon

    Rectangle {
        id: button
        width: 74
        height: 74
        radius: 92
        anchors.centerIn: parent
        color: "transparent"

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                parent.color = "cyan"
            }

            onExited: {
                parent.color = "transparent"
                timer.running = false
            }

            onClicked: {
                parent.color = "transparent"
                timer.running = true
            }

            Timer {
                id: timer
                interval: 75
                repeat: false
                running: false

                onTriggered: {
                    button.color = "cyan"
                }
            }
        }

        Text {
            anchors.centerIn: parent
            text: root.icon
            font.family: Cfg.font
            font.pixelSize: 32
            color: "white"
        }

        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }
    }

    onPaint: {
        var ctx = getContext("2d");
        ctx.clearRect(0, 0, width, height);

        var radius = Math.min(width, height) / 2;
        var centerX = width / 2;
        var centerY = height / 2;

        ctx.beginPath();
        ctx.arc(centerX, centerY, radius - 10, 0, 2 * Math.PI);
        ctx.lineWidth = 8;
        ctx.strokeStyle = "grey";
        ctx.stroke();

        var maxAngle = Math.PI * progress;

        ctx.beginPath();
        ctx.arc(centerX, centerY, radius - 10, Math.PI / 2, Math.PI / 2 - maxAngle, true);
        ctx.lineWidth = 8;
        ctx.strokeStyle = "white";
        ctx.stroke();

        ctx.beginPath();
        ctx.arc(centerX, centerY, radius - 10, Math.PI / 2, Math.PI / 2 + maxAngle, false);
        ctx.lineWidth = 8;
        ctx.strokeStyle = "white";
        ctx.stroke();
    } 
}

