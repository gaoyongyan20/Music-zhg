

/* MusicPlayer is a free music player.
 * The file defines the appwindow of musicplayer, and setts up all UI's logic, except the content's.
 * Author: 何泳珊 高永艳 周扬康丽
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "freemusic.js" as Controller
import Lyrics

ApplicationWindow {
    property int x
    // width: 640
    // height: 480
    visible: true
    title: qsTr("Music Player")

    minimumHeight: 600
    maximumHeight: 600
    minimumWidth: 800
    maximumWidth: 800

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
            // MenuItem{
            //     action: actions.close
            // }
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

        Menu {
            title: qsTr("About")
            MenuItem {
                action: actions.about
            }
            MenuItem {
                action: actions.close1
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
            // ToolButton {
            //     action: actions.timingoff
            // }
            ToolButton {
                action: actions.close1
            }
        }
    }

    footer: Footer {
        id: foot

        // 当按下暂停按钮时发出的信号
        signal changePlay
        // 当按下播放按钮时发出的信号
        signal changePause

        //上一首歌
        backward_button.onClicked: {
            // play_button.state = "pause"
            play_button.icon.name = "media-playback-pause-symbolic"
            content.playmusic.play()
            if (!content.rotationAnimation.running) {
                // 如果动画没有运行
                content.rotationAnimation.from = content.faceImage.currentRotation // 设置起始角度为保存的角度
            }
            content.rotationAnimation.resume()
            Controller.setBackwardMusic(actions.isLoop, actions.isRandom)
        }

        play_button.onClicked: {
            if (play_button.icon.name === "media-playback-pause-symbolic") {
                changePause()
                play_button.icon.name = "media-playback-start-symbolic"
            } else {
                changePlay()
                play_button.icon.name = "media-playback-pause-symbolic"
            }
        }

        //下一首歌
        forward_button.onClicked: {
            // play_button.state = "pause"
            play_button.icon.name = "media-playback-pause-symbolic"
            content.playmusic.play()
            if (!content.rotationAnimation.running) {
                // 如果动画没有运行
                content.rotationAnimation.from = content.faceImage.currentRotation // 设置起始角度为保存的角度
            }
            content.rotationAnimation.resume()
            Controller.setForwardMusic(actions.isLoop, actions.isRandom)
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
            content.playmusic.pause()

            content.faceImage.currentRotation = content.faceImage.rotation

            content.rotationAnimation.pause()
        }
        onChangePlay: {
            content.playmusic.play()
            if (!content.rotationAnimation.running) {
                // 如果动画没有运行
                content.rotationAnimation.from = content.faceImage.currentRotation // 设置起始角度为保存的角度
            }
            content.rotationAnimation.resume()
        }
        //声音图标
        voiceIcon.onClicked: {
            voiceIcon.state === "playVoice" ? voiceIcon.state
                                              = "Slience" : voiceIcon.state = "playVoice"
            content.audio.volume = volumeSlider.value
        }

        //音量
        volumeSlider.to: 1.0
        volumeSlider.value: content.audio.volume
        volumeSlider.onMoved: {
            voiceIcon.state = "playVoice"
            content.audio.volume = volumeSlider.value
        }
    }

    Actions {
        id: actions
        property alias timingoffTimer: _timingoffTimer
        property alias timingProgram: _timingProgram
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
                foot.play_button.icon.name = "media-playback-start-symbolic"
                // foot.play_button.state = "play"
            }
        }

        Timer {
            id: _timingProgram
            onTriggered: {
                Qt.quit()
            }
        }

        loop.onTriggered: {
            console.log("loop play now")
            if (isRandom) {
                isRandom = false
            } // 若最终没有按下顺序播放，顺序/循环只能有一个状态
            isLoop = true

            loop.icon.color = "red"
            random.icon.color = "black"
            sequence.icon.color = "black"
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

            loop.icon.color = "black"
            random.icon.color = "black"
            sequence.icon.color = "red"
        }
        random.onTriggered: {
            console.log("random play now")
            if (isLoop) {
                isLoop = false
            }
            isRandom = true
            loop.icon.color = "black"
            random.icon.color = "red"
            sequence.icon.color = "black"
        }
        close1.onTriggered: {
            console.log("tyfqgouwiefhuiqeoguygyexywqsging7")
            console.log("gt56", content.songListInterface.z)
            content.musicInterface.visible = true
            content.musicInterface.z = 3
            console.log(content.songListInterface.z)
            content.songListInterface.visible = false
            content.songListInterface.z = -1
            console.log(content.songListInterface.visible)
        }
    }

    Content {
        id: content
        property bool formatHasDot: false
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

        //定时关闭应用程序
        dialogs.buttonRoutine.onClicked: {
            var number = parseInt(dialogs.text.text)
            if (isNaN(number)) {
                console.log("Invalid input")
            } else {
                console.log("The number is:", number)
                playmusic.play()
                foot.play_button.icon.name = "media-playback-pause-symbolic"
                // foot.play_button.state = "play"
                actions.timingProgram.interval = number * 60000
                actions.timingProgram.running = true
            }
        }

        onChangeIcon: {
            foot.play_button.icon.name = "media-playback-pause-symbolic"
        }
        playmusic.onPlaybackStateChanged: {
            // 歌曲播放完毕的标志：
            if (playmusic.position >= playmusic.duration) {
                Controller.setForwardMusic(actions.isLoop, actions.isRandom)
            }
        }

        onChangeinformation: {
            textalubm = filesModel.get(listview.currentIndex).title
            textauthor = filesModel.get(listview.currentIndex).author
        }

        onExchangepath: {
            lyrics.lyricsFile = Controller.getlrcpath()
        }
        Connections {
            target: content.lyrics
            function onLyricsFileChanged() {
                Controller.setlrcmodel()
            }
        }
        playmusic.onPositionChanged: {
            // console.log(_playmusic.position)
            // console.log(playmusic.position)
            // console.log(lyric.getIndexByKey(Controller.formatTime(
            //                                     playmusic.position)))
            var currentIndex = content.playlistshow.currentIndex

            var index = content.lyrics.getIndexByKey(Controller.formatTime(
                                                         playmusic.position))

            if (index !== -1) {
                // 如果找到了对应的索引，更新列表的当前索引
                content.playlistshow.list.currentIndex = index
            }
        }

        playmusic.onPlayingChanged: {
            if (playmusic.PlayingState) {
                foot.play_button.icon.name === "media-playback-start-symbolic"
                // foot.play_button.state = "pause"
            } else {
                foot.play_button.icon.name = "media-playback-pause-symbolic"
                // foot.play_button.state = "play"
            }
        }
        playlistshow.onChangep: {
            if (lyrics.getTimeByIndex(
                        content.playlistshow.list.currentIndex) !== -1) {
                playmusic.position = lyrics.getTimeByIndex(
                            content.playlistshow.list.currentIndex)
            }
        }

        Connections {
            target: content.songlist
            function onSongListNameChanged() {
                console.log("enter..")
                Controller.setplaylistModel()
            }
        }
        onAddToPlayList: {
            Controller.appendsong(mySongData.currentIndex)
        }
        Connections {
            target: content.lyrics
            function onFailedToOpenLrcFile() {
                dialogs.failToOpen.open()
            }
        }
    }
}
