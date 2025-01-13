import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../../"
import ".."

Item {
    width: 380
    height: 500

    function daysInMonth(year, month) {
        return new Date(year, month, 0).getDate()
    }

    function generateMonthGrid(year, month) {
        let grid = []
        let firstDayOfMonth = new Date(year, month, 1).getDay()
        let daysPrevMonth = daysInMonth(year, month)
        let daysCurrentMonth = daysInMonth(year, month)
        let dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

        for(let i = 0; i < 7; i++) {
            grid.push({name: dayNames[i], isDayName: true})
        }

        for(let i = firstDayOfMonth - 1; i >= 0; i--) {
            grid.push({ day: daysPrevMonth - i, isCurrentMonth: false, isDayName: false})
        }

        for(let i = 1; i <= daysCurrentMonth; i++) {
            grid.push({ day: i, isCurrentMonth: true, isDayName: false});
        }

        let totalCells = (grid.length <= 35 ? 35 : 42)
        let remainingDays = totalCells - grid.length

        for(let i = 1; i <= remainingDays; i++) {
            grid.push({ day: i, isCurrentMonth: false, isDayName: false})
        }

        return grid
    }

    property int year: Cfg.time.year
    property int month: Cfg.time.month
    property int currDay: Cfg.time.day
    property string seconds: Cfg.time.seconds.padStart(2, '0')
    property string minutes: Cfg.time.minutes.padStart(2, '0')
    property string hours: Cfg.time.hours.padStart(2, '0')
    property var monthNames: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

    ColumnLayout {
        width: parent.width
        anchors.centerIn: parent
        spacing: 25

        Item {
            height: 25
            width: parent.width
            Layout.alignment: Qt.AlignTop

            Text {
                text: `${hours} : ${minutes} : ${seconds}`
                x: (parent.width / 2) - (width / 2)
                y: (parent.height / 2 - height / 2)
                font.pixelSize: 38
                font.family: Cfg.font
                font.bold: true
                color: "white"
            }
        }

        RowLayout {
            spacing: 100
            Layout.alignment: Qt.AlignHCenter

            RowLayout {
                spacing: 20

                Text {
                    id: leftMonth
                    text: ""
                    font.pixelSize: 16
                    font.family: Cfg.font
                    font.bold: true
                    color: "white"

                    ClickableIcon {
                        icon: leftMonth

                        onClicked: {
                            if(month === 0) {
                                month = 11
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
                        text: monthNames[month]
                        anchors.centerIn: parent
                        font.pixelSize: 16
                        font.family: Cfg.font
                        font.bold: true
                        color: "white"
                    }
                }

                Text {
                    id: rightMonth
                    text: ""
                    font.pixelSize: 16
                    font.family: Cfg.font
                    font.bold: true
                    color: "white"

                    ClickableIcon {
                        icon: rightMonth

                        onClicked: {
                            if(month === 11) {
                                month = 0
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
                    id: leftYear
                    text: ""
                    font.pixelSize: 16
                    font.family: Cfg.font
                    font.bold: true
                    color: "white"

                    ClickableIcon {
                        icon: leftYear

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
                    id: rightYear
                    text: ""
                    font.pixelSize: 16
                    font.family: Cfg.font
                    font.bold: true
                    color: "white"

                    ClickableIcon {
                        icon: rightYear

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
            height: childrenRect.height
            cellWidth: width / 7
            cellHeight: width / 7
            model: generateMonthGrid(year, month)
            delegate: Rectangle {
                width: monthGrid.cellWidth - 7
                height: monthGrid.cellHeight - 7
                color: currDay === modelData.day && month === parseInt(Cfg.time.month) && year === parseInt(Cfg.time.year) ? Cfg.colors.thirdaryColor : "transparent"
                radius: 30

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    enabled: modelData.isDayName ? false : true

                    onEntered: {
                        parent.color = Qt.alpha(Cfg.colors.thirdaryColor, 0.4)
                    }

                    onExited: {
                        parent.color = currDay === modelData.day && month === parseInt(Cfg.time.month) && year === parseInt(Cfg.time.year) ? Cfg.colors.thirdaryColor : "transparent"
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: modelData.isDayName ? modelData.name : modelData.day
                    font.pixelSize: 16
                    font.family: Cfg.font
                    font.bold: true
                    color: modelData.isCurrentMonth || modelData.isDayName ? "white" : "#575757"
                }
            }
        } 
    }
}
