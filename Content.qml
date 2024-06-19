import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtMultimedia

Frame {
    id:root
    property alias backgrondImage: _backgrondImage
    anchors.fill: parent
    property alias filesModel: _filesModel
    property alias listview: _multipath
    property alias player: _playmusic

    property alias dialogs: _dialogs
    property alias audio: _audio
    property alias playmusic: _playmusic

    Dialogs {

        id: _dialogs

        // fileOpen.onAccepted:
        //     setFilesModel(fileOpen.selectedFiles)
    }

    MediaPlayer {
        id: _playmusic
        audioOutput: AudioOutput {
            id: _audio
        }
    }

        //从指定的媒体文件路径（fp）中提取标题和作者信息，利用元对象
        function getTitle(fp,i){
            var metaDataReader=Qt.createQmlObject(
                        'import QtMultimedia;MediaPlayer{audioOutput:AudioOutput{}}',
                        root,"")
            metaDataReader.source=fp;

            function f(){
                //媒体的状态加载完成时
                if(metaDataReader.mediaStatus===MediaPlayer.LoadedMedia){
                    // console.log("title:",metaDataReader.metaData.stringValue(MediaMetaData.Title))
                    // console.log("author:",metaDataReader.metaData.keys())
                filesModel.setProperty(i,"title",
                                       metaDataReader.metaData.stringValue(MediaMetaData.Title))
                filesModel.setProperty(i,"author",
                                       metaDataReader.metaData.stringValue(MediaMetaData.ContributingArtist))
                                      metaDataReader.destroy()
                }
            }
            metaDataReader.mediaStatusChanged.connect(f);
        }


    RowLayout {
        anchors.fill: parent

        ColumnLayout {
            id: _leftLayout
            width: 300
            height: 350
            Layout.fillWidth: true
            Layout.fillHeight: true

            // -----放置图片(换成Image)
            Image {
                id: _backgrondImage
                width: 200
                height: 150
            }

            Rectangle {
                width: 200
                height: 30
                color: "transparent"
                Text {
                    // text: "author"
                    anchors.centerIn: parent
                }
            }
            Rectangle {
                width: 200
                height: 30
                color: "transparent"
                Text {
                    //  text: "album"
                    anchors.centerIn: parent
                }
            }
        }

        ColumnLayout {
            Rectangle {
                width: 300
                height: 350
                color: "transparent"
                Layout.fillWidth: true
                Layout.fillHeight: true

                Rectangle {
                    id: _songRect
                    width: 200
                    height: 200
                    color: "transparent"
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right

                    // visible: false
                    // z: -1
                    ScrollView {
                        id: _scorllView
                        anchors.fill: parent
                        ScrollBar.horizontal.policy: ScrollBar.AsNeeded
                        ScrollBar.vertical.policy: ScrollBar.AsNeeded

                        ColumnLayout{
                                // 存放音频文件的视图
                             ListView{
                                    // anchors.fill: parent
                                    interactive:true
                                    id: _multipath
                                    Layout.preferredWidth: 400
                                    Layout.preferredHeight: 200
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true

                                    ListModel{
                                        id:_filesModel
                                    }
                                    delegate:MyDelegate{}
                            }

                                component MyDelegate : Rectangle{
                                    id:songRoot
                                    required property string title
                                    required property string author
                                    required property url filePath
                                    required property int index
                                    // color: "red"

                                    height:30
                                    width: parent.width

                                RowLayout {
                                     Text{
                                         text: title
                                         font.bold: true
                                         color:songRoot.ListView.isCurrentItem?"red":"black"
                                       }
                                     Text{
                                         text:author
                                         font.bold: true
                                         color:songRoot.ListView.isCurrentItem?"red":"black"
                                     }
                                }
                                     TapHandler{
                                         parent: songRoot
                                          onTapped :{
                                              _multipath.currentIndex = index
                                              _playmusic.source = filePath
                                              _playmusic.play()
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
