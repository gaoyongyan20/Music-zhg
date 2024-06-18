
/* MusicPlayer is a free music player.
 * The file defines the appwindow of musicplayer, and setts up all UI's logic, except the content's.
 * Author: 何泳珊 高永艳 周扬康丽
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    width: 640
    height: 480
    visible: true
    title: qsTr("Music Player")
    // color: "red"

    // -------设置菜单栏------
    menuBar: MenuBar {
        Menu {
            title: qsTr("Open")
            MenuItem {
                action: actions.open
            }
        }

        Menu {
            title: qsTr("Mode")
            MenuItem {
                action: actions.loop
            }
            MenuItem {
                action: actions.random
            }
        }

        Menu {
            title: qsTr("Setting")
            MenuItem {
                action: actions.background
            }
            MenuItem {
                action: actions.timingoff
            }
        }

        Menu {
            title: qsTr("About")
            MenuItem {
                action: actions.about
            }
        }
    }

    // -------设置工具栏------
    header: ToolBar {
        RowLayout {
            ToolButton {
                action: actions.open
            }

            ToolSeparator {}

            ToolButton {
                action: actions.loop
            }
            ToolButton {
                action: actions.random
            }

            ToolSeparator {}

            ToolButton {
                action: actions.background
            }
            ToolButton {
                action: actions.timingoff
            }

            ToolSeparator {}

            ToolButton {
                action: actions.about
            }
        }
    }

    footer: Footer {}

    Actions {
        id: actions
    }

    Content {
        id: content
    }
}
