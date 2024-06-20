
/* MusicPlayer is a free music player.
 * The file defines the appwindow of musicplayer, and setts up all UI's logic, except the content's.
 * Author: 何泳珊 高永艳 周扬康丽
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "freemusic.js" as Controller

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

    footer: Footer {
        // id: footer
        //进度条
        playProgressSlider.to: content.playmusic.duration
        playProgressSlider.value: content.playmusic.position
        playProgressSlider.onMoved: {
            content.playmusic.position = playProgressSlider.value
        }

        //进度条起点-文本
        textOrigin.text: Controller.formatTime(content.playmusic.position)
        //进度条终点-文本
        textTerminus.text: Controller.formatTime(content.playmusic.duration)
        //播放列表显示
        playlist.onClicked: {
            if(content.songRect.width===0&&content.songRect.height===0)
            {
                content.songRect.width=200
                content.songRect.height=200
                content.songRect.visible=true
            }else{
                content.songRect.width=0
                content.songRect.height=0
            }
        }
        //
        fullscreen.onClicked: {
            if(content.information.width===0){
                content.information.width=200
            }else{
                content.information.width=0
                content.playlistshow.width=content.playlistshow.width+210
            }
        }

        /*更新时间戳，存疑
        Timer {
            id: timer
            interval: 1000 // 更新时间戳的频率
            running: true
            onTriggered: {
                // 每秒更新一次文本
                footer.textOrigin.text = Controller.formatTime(
                            content.playmusic.position)
                footer.textTerminus.text = Controller.formatTime(
                            content.playmusic.duration)
            }
        }*/

        //声音图标

        //音量
        volumeSlider.to: 1.0
        volumeSlider.value: content.audio.volume
        volumeSlider.onMoved: content.audio.volume = volumeSlider.value
    }

    Actions {
        id: actions
        open.onTriggered: Controller.setFilesModel()
        background.onTriggered: content.imageDialog.open()
    }

    Content {
        id: content
    }

}
