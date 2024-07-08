import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: footerroot
    width: parent.width
    height: 35
    opacity: 0.8
    property alias playProgressSlider: _playProgressSlider
    property alias volumeSlider: _volumeSlider
    property alias textOrigin: _textOrigin
    property alias textTerminus: _textTerminus
    property alias voiceIcon: _voiceIcon
    property alias playlist: _playlist
    property alias fullscreen: _fullscreen
    property alias play_button: _play_button
    property alias backward_button: _backward_button
    property alias forward_button: _forward_button

    // // 当按下暂停按钮时发出的信号
    // signal changePlay
    // // 当按下播放按钮时发出的信号
    // signal changePause
    RowLayout {
        id: layout
        anchors.bottom: parent.bottom
        width: footerroot.width
        spacing: 2

        RoundButton {
            id: _backward_button
            icon.name: "media-seek-backward"
            anchors.left: parent.left
            anchors.leftMargin: 10
            background: Rectangle {
                implicitHeight: 30
                implicitWidth: 30
                radius: 50
                border.color: "grey"
                color: "lightblue"
                opacity: 0.9
            }
        }

        RoundButton {
            id: _play_button
            icon.name: "media-playback-start-symbolic"
            anchors.left: _backward_button.right
            anchors.leftMargin: 15
            background: Rectangle {
                implicitHeight: 32
                implicitWidth: 32
                radius: 50
                opacity: 0.9
                border.color: "grey"
                color: "lightblue"
            }
        }

        RoundButton {
            id: _forward_button
            icon.name: "media-seek-forward"
            anchors.left: _play_button.right
            anchors.leftMargin: 15
            background: Rectangle {
                implicitHeight: 30
                implicitWidth: 30
                radius: 50
                border.color: "grey"
                color: "lightblue"
                opacity: 0.9
            }
        }

        Text {
            id: _textOrigin
            text: "00:00"
            anchors.left: _forward_button.right
            anchors.leftMargin: 20
        }

        Slider {
            id: _playProgressSlider
            implicitHeight: 5
            implicitWidth: 300
            anchors.left: _textOrigin.right
            anchors.leftMargin: 15
            background: Rectangle {
                implicitHeight: 2
                radius: 5
                border.color: "grey"
                color: "lightblue"
            }
        }

        Text {
            id: _textTerminus
            anchors.left: _playProgressSlider.right
            anchors.leftMargin: 20
        }

        RoundButton {
            id: _voiceIcon
            anchors.right: _volumeSlider.left
            anchors.rightMargin: 5
            background: Rectangle {
                implicitHeight: 30
                implicitWidth: 30
                radius: 50
                // border.color: "grey"
                color: "transparent"
                opacity: 0.9
            }
            state: "playVoice"
            states: [
                State {
                    name: "playVoice"
                    PropertyChanges {
                        target: _voiceIcon
                        icon.name: "player-volume"
                    }
                    PropertyChanges {
                        target: _volumeSlider
                        value: 0.5
                    }
                },
                State {
                    name: "Slience"
                    PropertyChanges {
                        target: _voiceIcon
                        icon.name: "player-volume-muted"
                    }
                    PropertyChanges {
                        target: _volumeSlider
                        value: 0
                    }
                }
            ]
        }

        Slider {
            id: _volumeSlider
            //implicitWidth: 70
            implicitHeight: 5
            implicitWidth: 100
            anchors.right: _playlist.left
            anchors.rightMargin: 15
            background: Rectangle {
                implicitHeight: 2
                radius: 5
                border.color: "grey"
                color: "lightblue"
            }
        }

        RoundButton {
            id: _playlist
            icon.name: "amarok_playlist-symbolic"
            anchors.right: _fullscreen.left
            anchors.rightMargin: 10
            background: Rectangle {
                implicitHeight: 30
                implicitWidth: 30
                radius: 50
                //border.color: "grey"
                color: "transparent"
            }
        }

        RoundButton {
            id: _fullscreen
            icon.name: "gnumeric-row-hide-symbolic"
            background: Rectangle {
                implicitHeight: 30
                implicitWidth: 30
                radius: 50
                //border.color: "grey"
                color: "transparent"
            }
        }
    }
}
