import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtMultimedia

Frame {
    property alias backgrondImage: _backgrondImage
    anchors.fill: parent

    property alias dialogs: _dialogs
    property alias audio: _audio
    property alias playmusic: _playmusic
    property alias text: _text
    Text {
        id: _text
        font.pointSize: 24
        width: 150
        height: 50
    }
    TapHandler {
        onTapped: {
            playmusic.play()
        }
    }
    Dialogs {
        id: _dialogs
    }
    MediaPlayer {
        id: _playmusic
        audioOutput: AudioOutput {
            id: _audio
        }
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

                        ListView {
                            id: _songlist
                            anchors.fill: parent
                            clip: true

                            model: 100
                            ListModel {
                                id: filesModel
                            }
                        }

                        component MyDelegate: Rectangle {
                            id: songRoot

                            property url filePath: filePath
                            width: parent.width
                            height: 30
                        }
                    }
                }
            }
        }
    }
}
