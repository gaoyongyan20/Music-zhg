import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtMultimedia
import Lyrics

Frame {

    id: root

    anchors.fill: parent
    property alias backgrondImage: _backgrondImage
    property alias filesModel: _filesModel
    property alias listview: _multipath
    property alias dialogs: _dialogs
    property alias audio: _audio
    property alias playmusic: _playmusic
    property alias imageDialog: _imageDialog
    property alias playlistshow: _playlistshow
    property alias songRect: _songRect
    property alias faceImage: _faceImage
    property alias information: _information
    property alias rowlayout: _rowlayout

    property alias rotationAnimation: _rotationAnimation

    property alias lyrics: _lyrics
    property alias songlist: _songlist

    property alias mySongDataModel: _mySongDataModel
    property alias mySongData: _mySongData

    property alias musicInterface: _musicInterface
    property alias songListInterface: _songListInterface

    property alias flushButton: _flushButton // 新加
    property alias mySongList: _mySongList // 新加
    property alias closeButton: _closeButton // 新加

    property string textauthor: "author"
    property string textalubm: "album"

    signal changeIcon
    signal changeinformation
    signal exchangepath
    signal changePlayIcons
    signal addToPlayList
    signal tapInSongListName
    signal deleteSongInSongList
    // 新加
    signal addListSongToPlay

    // 新加
    function rotate() {
        if (!rotationAnimation.running) {
            // 如果动画未运行，开始动画
            rotationAnimation.start()
        } else if (rotationAnimation.paused) {
            // 如果动画已暂停，则恢复运行状态
            rotationAnimation.resume()
        }
    }

    Lyrics {
        id: _lyrics
    }
    Songlist {
        id: _songlist
    }
    Image {
        id: _backgrondImage
        z: -1111
        width: root.width - 20
        height: root.height - 20
        opacity: 0.7
        Layout.alignment: Qt.AlignCenter
        source: "qrc:/myimage4.png"
        onSourceChanged: {
            update()
        }
    }

    Dialogs {
        id: _dialogs

        Dialog {
            id: _imageDialog
            title: "select background"
            width: 315
            height: 200
            clip: true

            GridView {
                anchors.fill: parent
                model: ["myimage1.png", "myimage2.png", "myimage3.png", "myimage4.png", "myimage5.png", "myimage6.png", "myimage7.png", "myimage8.png", "myimage9.png", "myimage10.png"]

                delegate: Rectangle {
                    width: 50
                    height: 50
                    Image {
                        width: parent.width
                        height: parent.height
                        source: "qrc:/" + modelData
                        TapHandler {
                            onTapped: {
                                // 将点击的图片设置为程序的背景
                                backgrondImage.source = "qrc:/" + modelData
                            }
                        }
                    }
                }
            }
        }

        rateSlider.from: 0.5
        rateSlider.to: 2.0
        rateSlider.value: playmusic.playbackRate
        rateSlider.stepSize: 0.5
        rateSlider.snapMode: Slider.SnapAlways
        rateSlider.onMoved: {
            playmusic.playbackRate = rateSlider.value
        }
    }

    MediaPlayer {
        id: _playmusic

        // seekable:true
        audioOutput: AudioOutput {
            id: _audio
        }
    }

    //从指定的媒体文件路径（fp）中提取标题和作者信息，利用元对象
    function getTitle(fp, i) {
        var metaDataReader = Qt.createQmlObject(
                    'import QtMultimedia;MediaPlayer{audioOutput:AudioOutput{}}',
                    root, "")
        metaDataReader.source = fp
        function f() {
            //媒体的状态加载完成时
            if (metaDataReader.mediaStatus === MediaPlayer.LoadedMedia) {
                // console.log("title:",metaDataReader.metaData.stringValue(MediaMetaData.Title))
                // console.log("author:",metaDataReader.metaData.keys())
                filesModel.setProperty(i, "title",
                                       metaDataReader.metaData.stringValue(
                                           MediaMetaData.Title))
                filesModel.setProperty(i, "author",
                                       metaDataReader.metaData.stringValue(
                                           MediaMetaData.ContributingArtist))
                metaDataReader.destroy()
            }
        }
        metaDataReader.mediaStatusChanged.connect(f)
    }

    function getAllData(fp, i) {
        var metaDataReader = Qt.createQmlObject(
                    'import QtMultimedia;MediaPlayer{audioOutput:AudioOutput{}}',
                    root, "")
        metaDataReader.source = fp
        function f() {
            //媒体的状态加载完成时
            if (metaDataReader.mediaStatus === MediaPlayer.LoadedMedia) {
                // console.log("title:",metaDataReader.metaData.stringValue(MediaMetaData.Title))
                // console.log("author:",metaDataReader.metaData.keys())
                mySongDataModel.setProperty(i, "title",
                                            metaDataReader.metaData.stringValue(
                                                MediaMetaData.Title))
                mySongDataModel.setProperty(
                            i, "author", metaDataReader.metaData.stringValue(
                                MediaMetaData.ContributingArtist))
                mySongDataModel.setProperty(i, "duration",
                                            metaDataReader.metaData.stringValue(
                                                MediaMetaData.Duration))
                mySongDataModel.setProperty(i, "genre",
                                            metaDataReader.metaData.stringValue(
                                                MediaMetaData.Genre))
                metaDataReader.destroy()
            }
        }
        metaDataReader.mediaStatusChanged.connect(f)
    }

    //播放歌曲界面，以显示歌词
    Rectangle {
        id: _musicInterface
        color: "transparent"
        width: root.width
        height: root.height
        Behavior on z {
            NumberAnimation {
                duration: 2000
                easing.type: Easing.OutBounce
            }
        }

        RowLayout {
            id: _rowlayout
            anchors.fill: parent
            //播放歌曲界面左部分，即圆盘，歌曲名字，歌曲作者
            Rectangle {
                id: _information
                width: 250
                height: parent.height
                anchors.left: parent.left // +
                color: "transparent"
                clip: true
                Layout.fillHeight: true
                Layout.fillWidth: true
                Rectangle {
                    id: a
                    width: 150
                    height: 150
                    border.color: "black"
                    border.width: 8
                    anchors.centerIn: parent
                    radius: 75
                    clip: true
                    scale: faceImageHover.hovered ? 1.2 : 1
                    HoverHandler {
                        id: faceImageHover
                    }
                    //圆盘
                    Image {
                        width: parent.width - 4
                        height: parent.height - 4
                        id: _faceImage
                        anchors.centerIn: parent
                        source: "qrc:/faceimage.png"
                        property real currentRotation: 0
                        TapHandler {
                            onTapped: {
                                console.log("tyfqgouwiefhuiqeoguygyexywqsging7")
                                console.log("gt56", songListInterface.z)
                                songListInterface.visible = true
                                songListInterface.z = 3
                                console.log(songListInterface.z)
                                console.log(songListInterface.visible)
                                musicInterface.visible = false
                                musicInterface.z = -1
                            }
                        }
                    }
                    RotationAnimation {
                        id: _rotationAnimation
                        target: _faceImage
                        property: "rotation"
                        from: 0
                        to: 360
                        duration: 5000 // 旋转一周所需的时间，单位毫秒
                        loops: Animation.Infinite // 无限循环
                    }
                }
                //歌曲名字
                Rectangle {
                    id: b
                    width: 150
                    height: 40
                    color: "transparent"
                    anchors.top: a.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    Text {
                        text: textalubm
                        font.bold: true
                        font.pointSize: 15

                        anchors.centerIn: parent
                    }
                }
                //歌曲作者
                Rectangle {
                    id: c
                    width: 150
                    height: 40
                    color: "transparent"
                    anchors.top: b.bottom
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        text: textauthor
                        font.bold: true
                        font.pointSize: 15
                        anchors.centerIn: parent
                    }
                }
            }
            //播放歌曲界面右部分，即歌词显示
            ScrollLyrics {
                anchors.right: rowlayout.right // 改

                // anchors.left: information.right
                id: _playlistshow
                width: 500
                height: parent.height
                color: "transparent"
                Layout.fillWidth: true
                Layout.fillHeight: true

                Popup {
                    id: _songRect
                    opacity: 0.7
                    width: 250

                    height: 230

                    modal: true
                    focus: true
                    x: 350
                    y: 300

                    contentItem: ScrollView {
                        id: _scorllView
                        // anchors.fill: _songRect
                        // anchors.fill: parent // 问题
                        ScrollBar.horizontal.policy: ScrollBar.AsNeeded
                        ScrollBar.vertical.policy: ScrollBar.AsNeeded

                        // 存放音频文件的视图
                        ListView {

                            interactive: true
                            id: _multipath

                            Layout.preferredHeight: 200

                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            model: _filesModel
                            ListModel {
                                id: _filesModel
                            }
                            Connections {
                                target: _filesModel
                                function onCountChanged(newCount) {
                                    if (_filesModel.count === 0) {
                                        playmusic.stop()
                                    }
                                }
                            }
                            delegate: MyDelegate {}
                        }

                        component MyDelegate: Rectangle {
                            id: songRoot
                            required property string title
                            required property string author
                            required property url filePath
                            required property int index

                            height: 30

                            width: _multipath.width

                            RowLayout {
                                RoundButton {
                                    width: 20
                                    height: 20
                                    icon.name: "application-menu"
                                    TapHandler {
                                        acceptedButtons: Qt.RightButton
                                        onTapped: popup.open()
                                    }
                                }
                                Popup {
                                    id: popup
                                    x: 20
                                    y: 30
                                    modal: true
                                    focus: true
                                    ColumnLayout {
                                        RowLayout {
                                            RoundButton {
                                                id: addSongToList
                                                icon.name: "media-playlist-append"
                                                icon.color: "black"
                                                background: Rectangle {
                                                    implicitHeight: 5
                                                    implicitWidth: 5
                                                    radius: 50
                                                    color: "lightblue"
                                                }
                                                TapHandler {
                                                    onTapped: {
                                                        console.log("add song to list..")
                                                        addListSongToPlay()
                                                    }
                                                }
                                            }
                                            Text {
                                                text: "addSongToList"
                                            }
                                        }
                                        RowLayout {
                                            RoundButton {
                                                id: addnext
                                                icon.name: "bqm-add"
                                                // 添加一首歌曲为下一首播放
                                                // 存疑 （有问题）
                                                onClicked: {
                                                    var de = index
                                                    var newIndex = _multipath.currentIndex + 1
                                                    //判断选择的下一首歌曲是否为当前正在播放的歌曲
                                                    if (_multipath.currentIndex === de) {
                                                        return
                                                    }
                                                    //判断当前播放歌曲是否为列表的最后一首，是：变成第一首，选择的歌曲变成第二首
                                                    if (_multipath.currentIndex
                                                            === filesModel.count - 1) {
                                                        filesModel.move(de, 0,
                                                                        1)
                                                        filesModel.move(
                                                                    _multipath.currentIndex,
                                                                    0, 1)
                                                        console.log(de)
                                                        console.log(_multipath.currentIndex)
                                                    } else if (_multipath.currentIndex < de) {
                                                        filesModel.move(
                                                                    de,
                                                                    newIndex, 1)
                                                    } else
                                                        //不是最后一首，将其变为当前播放音乐的下一首即可
                                                        filesModel.move(
                                                                    de,
                                                                    _multipath.currentIndex,
                                                                    1)
                                                    console.log(de)
                                                }
                                            }
                                            Text {
                                                text: "addSongs"
                                                TapHandler {
                                                    onTapped: {
                                                        addnext.clicked()
                                                    }
                                                }
                                            }
                                        }
                                        RowLayout {
                                            RoundButton {
                                                id: _deletesongs
                                                icon.name: "delete"
                                                icon.color: "black"
                                                onClicked: {
                                                    if (filesModel.count === 1) {
                                                        filesModel.clear()
                                                        _playlistshow.lrcmodel.clear()
                                                        textauthor = "author"
                                                        textalubm = "album"
                                                        // 存疑
                                                        playmusic.source = ""
                                                        playmusic.position = 0
                                                        faceImage.currentRotation
                                                                = content.faceImage.rotation
                                                        rotationAnimation.pause(
                                                                    )
                                                        changePlayIcons()
                                                    } else if (filesModel.count - 1 === index
                                                               && filesModel.count !== 1) {
                                                        //前两行顺序修改，会导致当前播放歌索引混乱
                                                        _multipath.currentIndex = 0
                                                        filesModel.remove(
                                                                    index, 1)
                                                        playmusic.source = filesModel.get(
                                                                    _multipath.currentIndex).filePath
                                                        changeinformation()
                                                        exchangepath()
                                                        console.log("fewukyfgbcj,sdnckjwenfiuwbgoflnkdjnmeifgoudhiuhqi")
                                                        playmusic.play()
                                                    } else {
                                                        filesModel.remove(
                                                                    index, 1)
                                                        playmusic.source = filesModel.get(
                                                                    _multipath.currentIndex).filePath
                                                        changeinformation()
                                                        exchangepath()
                                                        playmusic.play()
                                                    }
                                                }
                                            }

                                            Text {
                                                text: "deleteSongs"
                                                TapHandler {
                                                    onTapped: {
                                                        _deletesongs.clicked()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }

                                Text {
                                    text: title
                                    font.bold: true
                                    color: songRoot.ListView.isCurrentItem ? "red" : "black"
                                }
                                Text {
                                    text: author
                                    font.bold: true
                                    color: songRoot.ListView.isCurrentItem ? "red" : "black"
                                }
                                TapHandler {
                                    parent: songRoot
                                    onTapped: {
                                        _multipath.currentIndex = index
                                        _playmusic.source = filePath
                                        _playmusic.play()
                                        changeinformation()
                                        changeIcon()
                                        exchangepath()
                                        rotate()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } // --- end of scroIILyrics
    }
    //歌单列表
    Rectangle {
        id: _songListInterface

        opacity: 0.8
        width: 900
        height: 600
        visible: false
        z: -1

        RowLayout {
            id: _row
            anchors.fill: parent
            spacing: 10
            Rectangle {
                id: leftsong
                width: 300
                height: 600
                color: "transparent"

                // 加了外层rectangle,方便加入按钮
                Rectangle {
                    id: titleLayout
                    width: 300
                    height: 40
                    color: "transparent"
                    Text {
                        id: songListTitle
                        text: "SongList"
                        font.pointSize: 18
                        font.bold: true
                        anchors.centerIn: titleLayout
                        TapHandler {
                            onTapped: {
                                console.log("tapped")
                            }
                        }
                    }
                }

                ListView {
                    id: _mySongList
                    anchors.top: titleLayout.bottom

                    width: parent.width
                    height: parent.height
                    model: _mySongListModel
                    ListModel {
                        id: _mySongListModel
                        // 设置默认歌单选项 1. 本地歌单 2. 我喜欢歌单
                        ListElement {
                            songListName: "local"
                        }

                        ListElement {
                            songListName: "mylike"
                        }
                    }
                    delegate: MySongList {}
                }
                component MySongList: Rectangle {
                    required property string songListName
                    required property int index
                    id: delegateMySongList
                    width: mySongList.width
                    color: hover1.hovered ? "lightblue" : "transparent"

                    height: 40

                    Text {
                        id: local
                        font.pointSize: 15
                        font.italic: true
                        text: songListName
                        anchors.centerIn: parent
                    }
                    TapHandler {
                        onTapped: {
                            mySongList.currentIndex = index
                            _songlist.songListName = local.text
                            console.log(mySongList.visible)
                            tapInSongListName()
                        }
                    }
                    HoverHandler {
                        id: hover1
                    }
                }
            }

            Rectangle {
                width: 600
                height: 600
                color: "transparent"
                id: _songListRight

                // 新加，在歌曲上面加了两个按钮，改变了布局
                ColumnLayout {
                    anchors.fill: parent
                    Rectangle {
                        width: parent.width
                        height: parent.height / 15
                        id: songListTop
                        color: "transparent"
                        RowLayout {
                            anchors.right: parent.right
                            anchors.rightMargin: 30
                            RoundButton {
                                id: _flushButton
                                icon.name: "amarok_playlist_refresh-symbolic"
                                background: Rectangle {
                                    implicitHeight: 15
                                    implicitWidth: 15
                                    radius: 50
                                    color: "lightblue"
                                    border.color: "grey"
                                    opacity: 0.9
                                }
                            }
                            RoundButton {
                                id: _closeButton
                                icon.name: "view-close"
                                background: Rectangle {
                                    implicitHeight: 15
                                    implicitWidth: 15
                                    color: "lightblue"
                                    border.color: "grey"
                                    opacity: 0.9
                                    radius: 50
                                }
                            }
                        }
                    }
                    ListView {
                        id: _mySongData
                        anchors.top: songListTop.bottom
                        width: parent.width
                        height: parent.height - songListTop.height
                        ListModel {
                            id: _mySongDataModel
                        }

                        delegate: MySongData {}
                    }
                }
                component MySongData: Rectangle {
                    required property string title
                    required property string author
                    required property string duration
                    required property string genre
                    required property url playlistPath
                    required property int index
                    required property bool canDelete
                    // +

                    // 该property控制deleteSong按钮的enabled属性
                    id: delegateMyDataList
                    width: mySongData.width
                    height: 40

                    HoverHandler {
                        id: hover2
                    }

                    color: hover2.hovered ? "lightblue" : "white"

                    RowLayout {
                        RoundButton {
                            width: 20
                            height: 20
                            icon.name: "application-menu"
                            TapHandler {
                                acceptedButtons: Qt.RightButton
                                onTapped: popup2.open()
                            }
                        }
                        Popup {
                            id: popup2
                            x: 20
                            y: 30
                            modal: true
                            focus: true
                            ColumnLayout {
                                RowLayout {
                                    RoundButton {
                                        id: _addToScorllView
                                        icon.name: "media-playlist-append-symbolic"
                                        onClicked: {
                                            _mySongData.currentIndex = index
                                            addToPlayList()
                                        }
                                    }
                                    Text {
                                        text: "addToScorllView"
                                        TapHandler {
                                            onTapped: {
                                                _addToScorllView.clicked()
                                            }
                                        }
                                    }
                                }
                                RowLayout {
                                    RoundButton {
                                        id: deletSongList
                                        icon.name: "edit-delete-remove-symbolic"
                                        visible: canDelete
                                    }
                                    Text {
                                        text: "deletSongList"
                                        visible: canDelete
                                    }
                                }
                            }
                        }

                        Text {
                            id: songTitle
                            font.pixelSize: 13
                            text: title
                            // color: _mySongData.currentIndex === index ? "red" : "black"
                            font.italic: hover2.hovered ? true : false
                            font.bold: hover2.hovered ? true : false
                        }
                        Text {
                            id: songAuthor
                            font.pixelSize: 13
                            text: author
                            //color: _mySongData.currentIndex === index ? "red" : "black"
                            font.italic: hover2.hovered ? true : false
                            font.bold: hover2.hovered ? true : false
                        }
                        Text {
                            id: songDuration
                            font.pixelSize: 13
                            text: duration
                            //color: _mySongData.currentIndex === index ? "red" : "black"
                            font.italic: hover2.hovered ? true : false
                            font.bold: hover2.hovered ? true : false
                        }
                        Text {
                            id: songGenre
                            font.pixelSize: 13
                            text: genre
                            font.italic: hover2.hovered ? true : false
                            font.bold: hover2.hovered ? true : false
                        }
                    }
                }
            }
        }
    }
}
