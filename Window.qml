

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
    id: window
    property int x
    visible: true
    title: qsTr("Music Player")

    minimumHeight: 600
    maximumHeight: 600
    minimumWidth: 900
    maximumWidth: 900

    // -------设置菜单栏------
    menuBar: MenuBar {
        Menu {
            title: qsTr("Open")
            MenuItem {
                action: actions.open
            }
        }
        Menu {
            title: qsTr("Setting")
            MenuItem {
                action: actions.background
            }
            Menu {
                title: qsTr("Timer")
                icon.name: "accept_time_event-symbolic"
                MenuItem {
                    action: actions.timingoff
                }
                MenuItem {
                    action: actions.pomodoroTimer
                }
            }
            MenuItem {
                action: actions.rate
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

        Menu {
            title: qsTr("About")
            MenuItem {
                action: actions.about
            }
        }

        Menu {
            title: qsTr("Closelist")
            MenuItem {
                action: actions.close
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
            play_button.icon.name = "media-playback-pause-symbolic"
            // content.playmusic.play()这一行不用写，与下面的函数重复
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
            play_button.icon.name = "media-playback-pause-symbolic"
            //content.playmusic.play()这一行不用写，与下面的函数重复
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
            content.songRect.open()
        }

        //全屏显示歌词板块
        fullscreen.onClicked: {
            if (content.information.anchors.left == content.rowlayout.left) {
                content.information.visible = false // 将旋转唱片所在部分进行隐藏
                content.information.anchors.left = content.rowlayout.right // 利用锚线改变旋转唱片所在定位
                content.playlistshow.anchors.left = content.rowlayout.left // 同上
                content.songRect.x = 650
            } else {
                content.information.visible = true // 将旋转唱片显示
                content.information.anchors.left = content.rowlayout.left // 恢复旋转唱片原来的位置
                content.playlistshow.anchors.left = content.information.right
                content.playlistshow.anchors.right = content.rowlayout.right // 恢复滚动歌词界面的位置
                content.songRect.x = 350
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

        // button组件与action进行关联
        footerControl.onClicked: {
            actions.control.trigger()
        }
    }
    Actions {
        id: actions
        property alias timingoffTimer: _timingoffTimer
        property alias timingProgram: _timingProgram
        property alias pomodoroClock: _pomodoroClock
        property alias pomodoroClockstop: _pomodoroClockstop
        property bool isLoop: false
        property bool isRandom: false
        property bool isSequence: true

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
        background.onTriggered: content.imageDialog.open(
                                    ) & Controller.setImageListModel()
        about.onTriggered: content.dialogs.about.open()
        rate.onTriggered: {
            content.dialogs.rateChangeDialog.open()
        }
        timingoff.onTriggered: {
            content.dialogs.timingoffDialog.open()
        }
        pomodoroTimer.onTriggered: {
            content.dialogs.pomodoroTimerDialog.open()
        }

        Timer {
            id: _timingoffTimer
            onTriggered: {
                content.timingoffDialog.close()
                content.playmusic.pause()
                content.rotationAnimation.pause()
                foot.play_button.icon.name = "media-playback-start-symbolic"
            }
        }

        Timer {
            id: _timingProgram
            onTriggered: {
                Qt.quit()
            }
        }
        //番茄钟
        Timer {
            id: _pomodoroClock
            onTriggered: {
                Controller.pomdoroClock()
            }
        }
        //询问番茄钟是否继续
        Timer {
            id: _pomodoroClockstop
            onTriggered: {
                content.playmusic.pause()
                content.rotationAnimation.pause()
                foot.play_button.icon.name = "media-playback-start-symbolic"
                content.dialogs.pomodorotimerrepeat.open()
                content.dialogs.pomodorotimerrepeat.x = 270
                content.dialogs.pomodorotimerrepeat.y = 230
            }
        }

        control.onTriggered: {
            // 按照顺序-> 循环 ->随机 -> 顺序 这样的顺序进行变化
            if (isSequence) // 当前是顺序播放时
            {
                isLoop = true
                isSequence = false
                foot.footerControl.icon.name = "media-repeat-track-amarok-symbolic"
                console.log("loop play now...")
            } else if (isLoop) // 当前是循环播放时
            {
                isRandom = true
                isLoop = false
                foot.footerControl.icon.name = "media-playlist-shuffle"
                console.log("random play now...")
            } else // 当前是随机播放时
            {
                isSequence = true
                isRandom = false
                foot.footerControl.icon.name = "media-playlist-normal-symbolic"
                console.log("sequence play now...")
            }
        }

        close.onTriggered: {
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

        //songRect.anchors.bottom: foot.top
        //自定义定时后，点击确认按钮
        dialogs.buttonMusic.onClicked: {
            var number = parseInt(dialogs.timingofftext.text)
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
            var number = parseInt(dialogs.timingofftext.text)
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

        //番茄钟
        dialogs.pomodoroTimerButton.onClicked: {
            dialogs.pomodoroTimerDialog.close()
            var number = parseInt(dialogs.pomodoroTimertext.text)
            if (isNaN(number)) {
                console.log("Invalid input")
            } else {
                console.log("The number is:", number)
                actions.pomodoroClock.interval = number * 60000
                actions.pomodoroClock.running = true
                actions.pomodoroClockstop.interval = (number + 5) * 60000
                actions.pomodoroClockstop.running = true
            }
        }

        //重复番茄钟
        dialogs.yesPomodorotimerRepeat.onClicked: {
            dialogs.pomodorotimerrepeat.close()
            dialogs.pomodoroTimerButton.clicked()
        }

        //不重复番茄钟
        dialogs.noPomodorotimerRepeat.onClicked: {
            dialogs.pomodorotimerrepeat.close()
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

            var currentIndex = content.playlistshow.list.currentIndex

            var index = content.lyrics.getIndexByKey(Controller.formatTime(
                                                         playmusic.position))

            if (index !== -1) {
                // 如果找到了对应的索引，更新列表的当前索引
                content.playlistshow.list.currentIndex = index
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
                // content.dialogs.failToOpen.open() -- 改进
                Controller.setNoLyricsFileModel()
            }
        }

        // 刷新按钮的响应
        flushButton.onClicked: {
            console.log("clicked")
        }

        onTapInSongListName: {
            // 判断歌单列表的当前项是否指向的是第一项（即本地歌单),这样做的目的是确保本地音乐不会被删除
            if (mySongList.currentIndex === 0) {
                console.log("enterin list")
                Controller.disableDeleteButton()
            }
            Controller.deletesong(mySongData.currentIndex)
        }

        // 将歌曲列表的歌曲添加进播放列表
        onAddListSongToPlay: {
            Controller.appendToList(listview.songIndex)
        }

        // 关闭歌单界面的响应
        closeButton.onClicked: {
            actions.close.trigger()
        }
        //点击从本地相册选取图片的圆形按钮
        onChangeBackground: {
            console.log("点击点击")
            Controller.setbackground()
        }
        //以前自定义的图片被保存到软件中，右键点击图片将重新设置该图片为背景
        onRightchangeback: {
            console.log("改了改了")
            content.dialogs.wrightchangeback.open()
        }
    }
}
