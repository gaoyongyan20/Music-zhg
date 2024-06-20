
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
        //上一首歌
        backward_button.onClicked: {
            Controller.setBackwardMusic()
        }

        //下一首歌
        forward_button.onClicked: {
            Controller.setForwardMusic()
        }

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
            if (content.songRect.width === 0 && content.songRect.height === 0) {
                content.songRect.width = 200
                content.songRect.height = 200
                content.songRect.visible = true
            } else {
                content.songRect.width = 0
                content.songRect.height = 0
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
        voiceIcon.onClicked: {
            voiceIcon.state === "playVoice" ? voiceIcon.state
                                              = "Slience" : voiceIcon.state = "playVoice"
            content.audio.volume = volumeSlider.value
        }

        //音量
        volumeSlider.to: 1.0
        volumeSlider.value: content.audio.volume
        volumeSlider.onMoved: content.audio.volume = volumeSlider.value
    }

    Actions {
        id: actions
        property alias timingoffTimer: _timingoffTimer

        open.onTriggered: Controller.setFilesModel()
        background.onTriggered: content.imageDialog.open()
        timingoff.onTriggered: {
            content.dialogs.timingoffDialog.open()
        }
        Timer {
            id: _timingoffTimer
            onTriggered: {
                content.playmusic.pause()
            }
        }
    }

    Content {
        id: content
        //自定义定时后，点击确认按钮
        dialogs.button.onClicked: {
            var number = parseInt(dialogs.text.text)
            if (isNaN(number)) {
                console.log("Invalid input")
            } else {
                console.log("The number is:", number)
                actions.timingoffTimer.interval = number * 60000
                actions.timingoffTimer.running = true
            }
        }
    }
}
