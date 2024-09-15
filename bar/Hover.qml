import QtQuick

import ".."

MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true

    required property var item

    onEntered: {
        parent.color = Cfg.colors.thirdaryColor
    }

    onExited: {
        parent.color = Cfg.colors.primaryColor
    }

    Binding {
        target: item
        property: "color"
        value: Cfg.colors.primaryColor
        when: !mouseArea.containsMouse
    }
}

