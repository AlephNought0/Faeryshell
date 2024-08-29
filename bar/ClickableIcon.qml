import QtQuick

MouseArea {
    anchors.fill: parent
    hoverEnabled: true

    required property var icon

    onEntered: {
        icon.color = "cyan"
    }

    onExited: {
        icon.color = "white"
        timer.running = false
    }

    onClicked: {
        icon.color = "white"
        timer.running = true
    }

    Timer {
        id: timer
        interval: 150
        repeat: false
        running: false

        onTriggered: {
            icon.color = "cyan"
        }
    }
}
