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
    property alias player: _playmusic
    property alias dialogs: _dialogs
    property alias audio: _audio
    property alias playmusic: _playmusic
    property alias imageDialog: _imageDialog
    property alias playlistshow: _playlistshow
    property alias songRect: _songRect
    property alias faceImage: _faceImage
    property alias information: _information
    property alias rowlayout: _rowlayout
    property string textauthor: "author"
    property string textalubm: "album"

    property alias lyrics: _lyrics

    Lyrics {
        id: _lyrics
        // lyricsFile: "hello"
        // Component.onCompleted: {
        //     console.log(lyrics.lyricsFile)
        //     console.log(lyrics.test())
        // }
        // Connections {
        //     target: _lyrics
        //     function onLyricsFileChanged() {
        //         // 这里是信号的处理逻辑
        //         console.log("Signal received from C++!")
        //     }
        // }
    }

    signal changeIcon
    signal changeinformation

    Image {
        id: _backgrondImage

        z: -1111
        width: root.width - 20
        height: root.height - 20
        opacity: 0.9
        Layout.alignment: Qt.AlignCenter
        source: "qrc:/myimage1.png"
        onSourceChanged: {
            update()
        }
        Connections {
            target: _lyrics
            function onLyricsFileChanged() {
                // 这里是信号的处理逻辑
                console.log("Signal received from C++!")
            }
        }
    }

    Dialogs {
        id: _dialogs
        Dialog {
            id: _imageDialog
            title: "select background"
            width: 300
            height: 200
            GridView {
                anchors.fill: parent
                model: ["myimage1.png", "myimage2.png"]
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
                                faceImage.source = "qrc:/" + modelData
                            }
                        }
                    }
                }
            }
        }
    }
    MediaPlayer {
        id: _playmusic

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

    RowLayout {
        id: _rowlayout
        anchors.fill: parent
        Rectangle {
            id: _information
            width: 200
            height: 1000
            color: "transparent"
            clip: true
            Layout.fillHeight: true
            Layout.fillWidth: true
            Rectangle {
                id: a
                width: 100
                height: 100
                border.color: "black"
                border.width: 8
                anchors.centerIn: parent
                Image {
                    width: parent.width - 4
                    height: parent.height - 4
                    id: _faceImage
                    anchors.centerIn: parent
                    source: "qrc:/myimage1.png"
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
                    anchors.centerIn: parent
                }
            }
        }
        ScrollLyrics {
            color: "transparent"
            Rectangle {
                anchors.left: information.right
                id: _playlistshow
                width: 440
                height: 1000
                color: "transparent"
                Layout.fillWidth: true
                Layout.fillHeight: true

                Rectangle {
                    id: _songRect
                    opacity: 0.7
                    width: 200
                    height: 200
                    visible: false
                    // color: "blue"
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right

                    // visible: false
                    // z: -1
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
                                Layout.preferredWidth: 400
                                Layout.preferredHeight: 200
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                ListModel {
                                    id: _filesModel
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
                                height: 30
                                width: _multipath.width

                                RowLayout {
                                    Button {
                                        id: _addnext
                                        width: 20
                                        height: 20
                                        icon.name: "bqm-add"

                                        //添加一首歌曲为下一首播放
                                        onClicked: {
                                            var de = index
                                            var newIndex = _multipath.currentIndex + 1
                                            //判断选择的下一首歌曲是否为当前正在播放的歌曲
                                            if (_multipath.currentIndex === de) {
                                                return
                                            }
                                            //判断当前播放歌曲是否为列表的最后一首，是：变成第一首，选择的歌曲变成第二首
                                            if (_multipath.currentIndex === filesModel.count - 1) {
                                                content.filesModel.move(de, 0,
                                                                        1)
                                                content.filesModel.move(
                                                            _multipath.currentIndex,
                                                            0, 1)
                                                console.log(de)
                                                console.log(_multipath.currentIndex)
                                            } else
                                                //不是最后一首，将其变为第一首即可
                                                content.filesModel.move(
                                                            de, newIndex, 1)
                                            console.log(de)
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
                                }

                                TapHandler {
                                    parent: songRoot
                                    onTapped: {
                                        _multipath.currentIndex = index
                                        _playmusic.source = filePath
                                        _playmusic.play()
                                        changeinformation()
                                        changeIcon()
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
