import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../../"
import ".."

Item {
    id: root
    width: 380
    height: 500

    function daysInMonth(year, month) {
        return new Date(year, month, 0).getDate()
    }

    function generateMonthGrid(year, month) {
        const jsMonth = month - 1;
        const firstDay = new Date(year, jsMonth, 1).getDay(); 
        const daysInCurrent = new Date(year, month, 0).getDate();
        const daysInPrevious = new Date(year, jsMonth, 0).getDate();

        let grid = [];

        ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"].forEach(name => {
            grid.push({ name, isDayName: true });
        })

        const prevDaysToShow = firstDay;

        for (let i = prevDaysToShow; i > 0; i--) {
            grid.push({ day: daysInPrevious - i + 1, isMain: false, isCurrentMonth: false });
        }

        for (let i = 1; i <= daysInCurrent; i++) {
            if(month === parseInt(Cfg.time.month)) {
                grid.push({ day: i, isMain: true, isCurrentMonth: true });
            }

            else {
                grid.push({ day: i, isMain: true, isCurrentMonth: false });
            }
        }

        const remainingCells = 42 - (grid.length - 7);

        for (let i = 1; i <= remainingCells; i++) {
            grid.push({ day: i, isMain: false, isCurrentMonth: false });
        }

        return grid;
    }

    property int year: Cfg.time.year
    property int month: Cfg.time.month 
    property int currDay: Cfg.time.day
    property string seconds: Cfg.time.seconds.padStart(2, '0')
    property string minutes: Cfg.time.minutes.padStart(2, '0')
    property string hours: Cfg.time.hours.padStart(2, '0')
    property var monthNames: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

    Item {
        id: timeWidget
        height: 25
        width: parent.width
        anchors {
            bottom: stack.top
            bottomMargin: 30
        }

        property string currentItem: "calendar"

        MouseArea {
            width: parent.width
            height: parent.height + 20
            hoverEnabled: true
            anchors.centerIn: parent
            propagateComposedEvents: true

            onEntered: {
                layout.x = 20
                timeText.x = 100
            }

            onExited: {
                layout.x = -layout.width
                timeText.x = parent.width / 2 - timeText.width / 2
            }

            RowLayout {
                id: layout
                spacing: 10
                x: -width
                anchors.verticalCenter: parent.verticalCenter
                visible: x === -width ? false : true

                Behavior on x {
                    NumberAnimation {
                        duration: 190
                        easing.type: Easing.OutQuad
                    }
                }

                Text {
                    text: "󰸗"
                    font.pixelSize: 24
                    font.family: Cfg.font
                    font.bold: true
                    color: "white"

                    ClickableIcon {
                        propagateComposedEvents: true
                        icon: parent

                        onClicked: {
                            if(timeWidget.currentItem !== "calendar") {
                                stack.replaceCurrentItem(calendar)
                                timeWidget.currentItem = "calendar"
                            }
                        }
                    }
                }

                Text {
                    text: ""
                    font.pixelSize: 24

                    font.family: Cfg.font
                    font.bold: true
                    color: "white"

                    ClickableIcon {
                        propagateComposedEvents: true
                        icon: parent

                        onClicked: {
                            if(timeWidget.currentItem !== "reminder") {
                                stack.replaceCurrentItem(reminder)
                                timeWidget.currentItem = "reminder"
                            }
                        }
                    }
                }
            }
        } 

        Text {
            id: timeText
            text: `${hours} : ${minutes} : ${seconds}`
            x: parent.width / 2 - width / 2
            y: parent.height / 2 - height / 2
            font.pixelSize: 38
            font.family: Cfg.font
            font.bold: true
            color: "white"

            Behavior on x {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutQuad
                }
            }
        }
    }

    StackView {
        id: stack
        initialItem: calendar
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter 
        y: (root.height / 2 - 370 / 2) + 20

        replaceEnter: Transition {
            PropertyAnimation {
                property: "x"
                from: -stack.width * 1.5
                to: 0
                duration: 300
                easing.type: Easing.OutQuad
            }
        }

        replaceExit: Transition {
            PropertyAnimation {
                property: "x"
                from: 0
                to: stack.width * 1.5
                duration: 300
                easing.type: Easing.OutQuad
            }
        }
        
        Component {
            id: calendar

            CalendarWidget {}
        }

        Component {
            id: reminder

            Reminders {}
        }
    }
}
