import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Canvas {
    id: canvas
    width: 100
    height: 100
    Layout.alignment: Qt.AlignHCenter

    required property real progress

    Rectangle {
        width: 74
        height: 74
        radius: 92
        anchors.centerIn: parent
        color: "transparent"

        Text {
            anchors.centerIn: parent
            text: "sex"
            font.family: Cfg.font
            font.pixelSize: 16
            color: "white"
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

