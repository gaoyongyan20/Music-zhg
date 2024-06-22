
/* MusicPlayer is a free music player.
 * The file defines the appwindow of musicplayer, and setts up all UI's logic, except the content's.
 * Author: 何泳珊 高永艳 周扬康丽
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQml
import "freemusic.js" as Controller
import Lyrics

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
            MenuItem {
                action: actions.sequence
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

        Menu {
            title: qsTr("local_music")
            MenuItem {
                action: actions.song1
            }
            MenuItem {
                action: actions.song2
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
            ToolButton {
                action: actions.sequence
            }

            ToolSeparator {}

            ToolButton {
                action: actions.background
            }
            ToolButton {
                action: actions.timingoff
            }
        }
    }

    footer: Footer {
        //上一首歌
        backward_button.onClicked: {
            Controller.setBackwardMusic(content.dialogs.fileOpen.selectedFiles,
                                        actions.isLoop, actions.isRandom)
        }

        //下一首歌
        forward_button.onClicked: {
            Controller.setForwardMusic(content.dialogs.fileOpen.selectedFiles,
                                       actions.isLoop, actions.isRandom)
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

        //全屏显示歌词板块
        fullscreen.onClicked: {
            if (content.information.width === 0) {
                content.information.width = 200
                content.playlistshow.width -= 210
                fullscreen.icon.name = "gnumeric-row-unhide-symbolic"
            } else {
                content.information.width = 0
                content.playlistshow.width = content.playlistshow.width + 210
                fullscreen.icon.name = "gnumeric-row-hide-symbolic"
            }
        }

        // 当按下播放/暂停按钮时
        onChangePause: {
            content.player.pause()
        }
        onChangePlay: {
            content.player.play()
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
        property bool isLoop: false
        property bool isRandom: false

        song1.onTriggered: {
            content.playmusic.source = "qrc:/mysongs1.mp3"
            content.playmusic.play()
            content.textalubm = "海阔天空"
            content.textauthor = "beyond"
        }
        song2.onTriggered: {
            content.playmusic.source = "qrc:/mysongs2.mp3"
            content.playmusic.play()
            content.textalubm = "Valder Fields"
            content.textauthor = "Tamas Wells"
        }

        open.onTriggered: Controller.setFilesModel()
        background.onTriggered: content.imageDialog.open()
        about.onTriggered: content.dialogs.about.open()
        timingoff.onTriggered: {
            content.dialogs.timingoffDialog.open()
        }
        Timer {
            id: _timingoffTimer
            onTriggered: {
                content.playmusic.pause()
            }
        }
        loop.onTriggered: {
            console.log("loop play now")
            if (isRandom) {
                isRandom = false
            } // 若最终没有按下顺序播放，顺序/循环只能有一个状态
            isLoop = true
        }
        sequence.onTriggered: {
            console.log("sequence play now")
            // 在播放途中如果先按了循环/随机，再按下顺序播放，最终状态为顺序播放状态
            if (isLoop) {
                isLoop = false
            }
            if (isRandom) {
                isRandom = false
            }
        }
        random.onTriggered: {
            console.log("random play now")
            if (isLoop) {
                isLoop = false
            }
            isRandom = true
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
        playmusic.onPlaybackStateChanged: {
            // 歌曲播放完毕的标志：
            if (playmusic.position >= playmusic.duration) {
                Controller.setForwardMusic(dialogs.fileOpen.selectedFiles,
                                           actions.isLoop, actions.isRandom)
            }
        }

        // onLyricsFileChanged: {
        //     console.log(lyrics.test())
        // }
    }
}
