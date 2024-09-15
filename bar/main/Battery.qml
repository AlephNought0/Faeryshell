import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

import "../.."

Rectangle {
    id: main
    radius: 15
    width: parent.width
    height: parent.height
    color: Cfg.colors.primaryFixedDim

    Image {
        id: battery
        sourceSize.width: 300
        sourceSize.height: 200
        Layout.alignment: Qt.AlignHCenter
        source: "../../icons/battery.svg"
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            width: Cfg.bat != null ? ((parent.width - 108) * Cfg.bat.percentage) : null
            height: parent.height - 120
            color: "white"

            anchors {
                left: parent.left
                leftMargin: 48
                verticalCenter: parent.verticalCenter
            }
        }
    }

    ColumnLayout {
        spacing: 10
        anchors {
            top: battery.bottom
            left: parent.left
            topMargin: 10
            leftMargin: 10
        }

        Text {
            text: `Pecentage: ${Math.floor(Cfg.bat.percentage * 100)}%`
            font.family: Cfg.font
            font.pixelSize: 20
            color: "white" 
        }

        Text {
            text: if(Cfg.bat.state == 1) `${UPowerDeviceState.toString(Cfg.bat.state)}: ${Cfg.bat.timeToFull} seconds`
            else if(Cfg.bat.state == 2) `${UPowerDeviceState.toString(Cfg.bat.state)}: ${Cfg.bat.timeToEmpty} seconds`
            else `Status: ${UPowerDeviceState.toString(Cfg.bat.state)}`
            font.family: Cfg.font
            font.pixelSize: 20
            color: "white" 
        }

        Text {
            text: "fartus"
            font.family: Cfg.font
            font.pixelSize: 20
            color: "white" 
        }

        Text {
            text: "dildorium"
            font.family: Cfg.font
            font.pixelSize: 20
            color: "white" 
        }
    }
}
