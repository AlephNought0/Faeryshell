import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtCore

import "../../"
import "../../functions"

Item {
    id: root
    width: 380
    height: 500

    Component.onCompleted: {
        tempInput.text = Display.tempNightVal;
        autoNight.checked = Display.autoNightMode;
    }

    ColumnLayout {
        spacing: 25
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: 50
            margins: 10
        }

        Slider {
            id: brightness
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: 50
            value: Display.brightness
            clip: true
            from: 0.1
            to: 1
            stepSize: 0.01
            Layout.alignment: Qt.AlignHCenter

            onValueChanged: {
                Display.brightness = value
            }

            Text {
                text: `${Math.floor(Display.brightness * 100)}%`
                font.family: Cfg.font
                font.pixelSize: 20
                font.bold: true
                color: "white"
                anchors.centerIn: parent
            }

            background: Rectangle {
                width: brightness.availableWidth
                height: parent.height
                radius: 16
                clip: true
                color: Cfg.colors.secondaryColor

                Rectangle {
                    width: brightness.visualPosition * parent.width
                    height: parent.height
                    clip: true
                    radius: 16
                    color: Cfg.colors.errorContainer

                    Behavior on width {
                        NumberAnimation {
                            duration: 100
                            easing.type: Easing.OutQuad
                        }
                    }
                }
            }

            handle: Rectangle {
                color: "transparent"
            }
        }

        Text {
            text: `Current temperature: ${Display.temperature}K`
            font.family: Cfg.font
            font.pixelSize: 20
            color: "white"
        }

        RowLayout {
            spacing: 10
            Text {
                text: "Night mode temperature:"
                font.family: Cfg.font
                font.pixelSize: 20
                color: "white"
                Layout.alignment: Qt.AlignHCenter
            }

            TextField {
                id: tempInput
                implicitWidth: 65
                selectByMouse: true
                focus: false

                validator: RegularExpressionValidator {
                    regularExpression: /^(0|00|[1-9][0-9]{0,3}|10000)$/
                }

                background: Rectangle {
                    color: Cfg.colors.primaryColor
                    radius: 6
                    border.color: "black"
                }

                Keys.onReturnPressed: {
                    Display.tempNightVal = parseInt(text)
                    Display.nightTemperature = parseInt(text)
                }
            }
        }

        RowLayout {
            spacing: - 3

            CheckBox {
                id: autoNight
                checked: false
                implicitWidth: 26
                implicitHeight: 26

                indicator: Rectangle {
                    implicitWidth: parent.width
                    implicitHeight: parent.height
                    border.color: "black"
                    radius: 5
                    color: "white"

                    Text {
                        width: 20
                        height: 20
                        text: ""
                        x: 6
                        y: 4
                        visible: autoNight.checked
                    }
                }
            }

            Text {
                text: " Automatic night mode"
                font.family: Cfg.font
                font.pixelSize: 20
                color: "white"
                Layout.alignment: Qt.AlignVCenter

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        autoNight.checked = !autoNight.checked
                        Display.autoNightMode = autoNight.checked ? true : false
                    }
                }
            }
        }
        
        Rectangle {
            width: 250
            height: 50
            radius: 10
            color: Display.setNight ? "grey" : "white"
            Layout.alignment: Qt.AlignHCenter

            Text {
                text: Display.setNight ? "" : ""
                font.family: Cfg.font
                font.pixelSize: 20
                color: Display.setNight ? "white" : "black"
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 20
                }
            }

            Text {
                text: Display.setNight ? "Night mode" : "Day mode"
                font.family: Cfg.font
                font.pixelSize: 20
                color: Display.setNight ? "white" : "black"
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    parent.color = Cfg.colors.errorContainer
                }

                onExited: {
                    parent.color = Display.setNight ? "grey" : "white"
                }

                onClicked: {
                    Display.setNight = !Display.setNight
                }
            }
        }
    }
}
