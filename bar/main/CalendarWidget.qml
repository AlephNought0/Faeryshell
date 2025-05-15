import QtQuick
import QtQuick.Layouts
import ".."
import "../../"

ColumnLayout {
    id: calendar
    spacing: 15

    RowLayout {
        spacing: 100
        Layout.alignment: Qt.AlignHCenter

        RowLayout {
            spacing: 20

            Text {
                text: ""
                font.pixelSize: 16
                font.family: Cfg.font
                font.bold: true
                color: "white"

                ClickableIcon {
                    icon: parent

                    onClicked: {
                        if(month === 1) {
                            month = 12
                        }

                        else {
                            month--
                        }
                    }
                }
            }

            Item {
                width: 80
                height: 10

                Text {
                    text: monthNames[month - 1]
                    anchors.centerIn: parent
                    font.pixelSize: 16
                    font.family: Cfg.font
                    font.bold: true
                    color: "white"
                }
            }

            Text {
                text: ""
                font.pixelSize: 16
                font.family: Cfg.font
                font.bold: true
                color: "white"

                ClickableIcon {
                    icon: parent

                    onClicked: {
                        if(month === 12) {
                            month = 1
                        }

                        else {
                            month++
                        }
                    }
                }
            }
        }

        RowLayout {
            spacing: 20

            Text {
                text: ""
                font.pixelSize: 16
                font.family: Cfg.font
                font.bold: true
                color: "white"

                ClickableIcon {
                    icon: parent

                    onClicked: {
                        year--
                    }
                }
            }

            Item {
                width: 50
                height: 10

                Text {
                    text: year
                    anchors.centerIn: parent
                    font.pixelSize: 16
                    font.family: Cfg.font
                    font.bold: true
                    color: "white"
                }
            }

            Text {
                text: ""
                font.pixelSize: 16
                font.family: Cfg.font
                font.bold: true
                color: "white"

                ClickableIcon {
                    icon: parent

                    onClicked: {
                        year++
                    }
                }
            }
        }
    }

    GridView {
        id: monthGrid
        Layout.alignment: Qt.AlignCenter
        interactive: false
        width: parent.width - 10
        height: childrenRect.height + 10
        cellWidth: width / 7
        cellHeight: width / 7
        model: generateMonthGrid(year, month)
        delegate: Rectangle {
            width: monthGrid.cellWidth - 7
            height: monthGrid.cellHeight - 7
            color: currDay === modelData.day && modelData.isCurrentMonth && year === parseInt(Cfg.time.year) ? Cfg.colors.thirdaryColor : "transparent"
            radius: 30

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                enabled: modelData.isDayName ? false : true

                onEntered: {
                    parent.color = Qt.alpha(Cfg.colors.thirdaryColor, 0.4)
                }

                onExited: {
                    parent.color = currDay === modelData.day && modelData.isCurrentMonth && year === parseInt(Cfg.time.year) ? Cfg.colors.thirdaryColor : "transparent"
                }
            }

            Text {
                anchors.centerIn: parent
                text: modelData.isDayName ? modelData.name : modelData.day
                font.pixelSize: 16
                font.family: Cfg.font
                font.bold: true
                color: modelData.isMain || modelData.isDayName ? "white" : "#575757"
            }
        }
    } 
}

