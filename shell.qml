import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ShellRoot {
    Variants {
        model: Quickshell.screens

        delegate: Component {
            
            PanelWindow {
                anchors {
                    top: true
                    left: true
                    right: true
                }
                
                property var modelData
                screen: modelData

                height: 35
                color: "transparent"

                Left{}

                Media{}

                Right{}
            }
        }
    }
}
