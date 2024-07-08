import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtMultimedia
import Lyrics

// import Songlist
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

    property alias musicInterface: musicInterface
    property alias songListInterface: songListInterface

    property string textauthor: "author"
    property string textalubm: "album"

    signal changeIcon
    signal changeinformation
    signal exchangepath
    signal changePlayIcons
    signal addToPlayList

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

    //播放列表界面
    Rectangle {
        id: musicInterface
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
            Rectangle {
                id: _information
                width: 200
                height: parent.height
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
                        anchors.centerIn: parent
                    }
                }
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
                        anchors.centerIn: parent
                    }
                }
            }
            ScrollLyrics {
                anchors.left: information.right
                id: _playlistshow
                width: 440
                height: parent.height
                color: "transparent"
                Layout.fillWidth: true
                Layout.fillHeight: true
                Rectangle {
                    id: _songRect
                    opacity: 0.7
                    width: 200
                    height: 200
                    visible: false
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right

                    ScrollView {
                        id: _scorllView
                        anchors.fill: parent
                        ScrollBar.horizontal.policy: ScrollBar.AsNeeded
                        ScrollBar.vertical.policy: ScrollBar.AsNeeded

                        ColumnLayout {
                            // 存放音频文件的视图
                            ListView {
                                // anchors.fill: parent
                                interactive: true
                                id: _multipath
                                width: 800
                                // Layout.preferredWidth: 400
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
                                            if(_filesModel.count===0) {
                                                playmusic.stop();
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

                                // color: "red"
                                height: 40

                                width: _multipath.width

                                RowLayout {
                                    RoundButton {
                                        id: addnext
                                        width: 20
                                        height: 20
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
                                            if (_multipath.currentIndex === filesModel.count - 1) {
                                                filesModel.move(de, 0, 1)
                                                filesModel.move(
                                                            _multipath.currentIndex,
                                                            0, 1)
                                                console.log(de)
                                                console.log(_multipath.currentIndex)
                                            } else
                                                //不是最后一首，将其变为第一首即可
                                                filesModel.move(de, newIndex, 1)
                                            console.log(de)
                                        }
                                    }
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
                                                rotationAnimation.pause()
                                                changePlayIcons()
                                            } else if (filesModel.count - 1 === index
                                                       && filesModel.count !== 1) {
                                                //前两行顺序修改，会导致当前播放歌索引混乱
                                                _multipath.currentIndex = 0
                                                filesModel.remove(index, 1)
                                                playmusic.source = filesModel.get(
                                                            _multipath.currentIndex).filePath
                                                changeinformation()
                                                exchangepath()
                                                console.log("fewukyfgbcj,sdnckjwenfiuwbgoflnkdjnmeifgoudhiuhqi")
                                                playmusic.play()
                                            } else {
                                                filesModel.remove(index, 1)
                                                playmusic.source = filesModel.get(
                                                            _multipath.currentIndex).filePath
                                                changeinformation()
                                                exchangepath()
                                                playmusic.play()
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
            }
        }
    }
    //歌单列表
    Rectangle {
        id: songListInterface
        // color: "brown"
        // color: "transparent"
        opacity: 0.5
        width: 800
        height: 600
        visible: false
        z: -1

        RowLayout {
            id: _row
            anchors.fill: parent
            spacing: 10
            Rectangle {
                id: leftsong
                width: 250
                height: 600
                color: "transparent"

                Text {
                    id: songListTitle
                    text: "歌单列表"
                    font.pointSize: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    TapHandler {
                        onTapped: {
                            console.log("tapped")
                        }
                    }
                }

                ListView {
                    id: mySongList
                    anchors.top: songListTitle.bottom

                    width: parent.width
                    height: parent.height
                    model: _mySongListModel
                    ListModel {
                        id: _mySongListModel
                        ListElement {
                            songListName: "local"
                        }
                    }
                    delegate: MySongList {}
                }
                component MySongList: Rectangle {
                    required property string songListName
                    required property int index
                    id: delegateMySongList
                    width: mySongList.width

                    height: 40
                    Text {
                        id: local
                        font.pointSize: 15
                        text: songListName
                        anchors.centerIn: parent
                        color: mySongList.currentIndex === index ? "black" : "red"
                    }
                    TapHandler {
                        onTapped: {
                            _songlist.songListName = local.text
                            console.log(mySongList.visible)
                        }
                    }
                }
            }
            Rectangle {
                width: 550
                height: 600
                anchors.left: leftsong.right
                color: "transparent"
                ListView {
                    id: _mySongData
                    anchors.fill: parent
                    width: parent.width
                    height: parent.height
                    ListModel {
                        id: _mySongDataModel
                    }

                    delegate: MySongData {}
                }
                component MySongData: Rectangle {
                    required property string title
                    required property string author
                    required property string duration
                    required property string genre
                    required property url playlistPath
                    required property int index
                    id: delegateMyDataList
                    width: mySongData.width
                    height: 40
                    RowLayout {
                        RoundButton {
                            id: _addToScorllView
                            width: 20
                            height: 20
                            icon.name: "media-playlist-append-symbolic"
                            TapHandler {
                                onTapped: {
                                    _mySongData.currentIndex = index
                                    addToPlayList()
                                }
                            }
                        }
                        RoundButton {
                            id: deletSongList
                            icon.name: "edit-delete-remove-symbolic"
                        }
                        Text {
                            id: songTitle
                            font.pixelSize: 13
                            text: title
                            color: _mySongData.currentIndex === index ? "red" : "black"
                        }
                        Text {
                            id: songAuthor
                            font.pixelSize: 13
                            text: author
                            color: _mySongData.currentIndex === index ? "red" : "black"
                        }
                        Text {
                            id: songDuration
                            font.pixelSize: 13
                            text: duration
                            color: _mySongData.currentIndex === index ? "red" : "black"
                        }
                        Text {
                            id: songGenre
                            font.pixelSize: 13
                            text: genre
                            color: _mySongData.currentIndex === index ? "red" : "black"
                        }
                    }
                }
            }
        }
    }
}
