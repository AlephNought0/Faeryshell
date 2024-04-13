import Quickshell
import QtQuick
import QtQuick.Layouts

Item {
    height: parent.height
    anchors.centerIn: parent

    RowLayout {
        anchors.centerIn: parent
        width: childrenRect.width

        Text {
            text: Singl.temp
            font.weight: 550
            font.pixelSize: 16
            color: "white"
        }

                
        Image {
            source: Singl.icon
            fillMode: Image.PreserveAspectFit
            Layout.preferredHeight: parent.height - 12
            Layout.preferredWidth: sourceSize.width * (this.height / sourceSize.height)
        }
        

        ColumnLayout {
            spacing: 0
            
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: Singl.currTime
                font.weight: 500
                font.pixelSize: 16
                color: "white"
            }

            Rectangle {
                height: 1
                width: dInfo.width
                color: "white"
            }

            Text {
                id: dInfo
                text: Singl.currDate
                font.weight: 500
                font.pixelSize: 16
                color: "white"
            }
        }
    }
}