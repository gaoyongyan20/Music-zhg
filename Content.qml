import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtMultimedia

Frame {
    id: root

    property alias backgrondImage: _backgrondImage
    anchors.fill: parent
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
    property string textauthor: "author"
    property string textalubm: "album"

    Image {
        id: _backgrondImage
        z: -1111
        width: root.width - 20
        height: root.height - 20
        opacity: 0.9
        Layout.alignment: Qt.AlignCenter
        source: "qrc:/root/Music-zhg/images/myimage1.png"
        onSourceChanged: {
            update()
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
                        source: "qrc:/root/Music-zhg/images/" + modelData
                        TapHandler {
                            onTapped: {

                                // 将点击的图片设置为程序的背景
                                backgrondImage.source = "qrc:/root/Music-zhg/images/" + modelData
                                faceImage.source = "qrc:/root/Music-zhg/images/" + modelData
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
        anchors.fill: parent

        ColumnLayout {
            id: _leftLayout

            Rectangle {
                width: 100
                height: 100
                border.color: "black"
                border.width: 8
                Layout.alignment: Qt.AlignHCenter
                Image {
                    width: parent.width - 4
                    height: parent.height - 4
                    id: _faceImage
                    anchors.centerIn: parent
                    source: "qrc:/root/Music-zhg/images/myimage1.png"
                }
            }
            Rectangle {
                width: 150
                height: 30
                color: "transparent"
                Text {
                    text: textalubm
                    anchors.centerIn: parent
                }
            }
            Rectangle {
                width: 150
                height: 30
                color: "transparent"
                Text {
                    text: textauthor
                    anchors.centerIn: parent
                }
            }
        }

        ColumnLayout {

            Rectangle {
                // width: 300
                // height: 350
                // opacity: 0.8
                color: "transparent"
                id: _playlistshow
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
                                width: parent.width

                                RowLayout {
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
                                        textauthor = author
                                        textalubm = title
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
