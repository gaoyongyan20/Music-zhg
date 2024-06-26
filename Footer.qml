
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: footerroot
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

    // 当按下暂停按钮时发出的信号
    signal changePlay
    // 当按下播放按钮时发出的信号
    signal changePause



    RowLayout {
        id: layout
        anchors.bottom: parent.bottom
        spacing: 6
        width: footerroot.width

        RoundButton {
            id: _backward_button
            icon.name: "media-seek-backward"

        }

        RoundButton {
            id: _play_button
            icon.name: "media-playback-start-symbolic"
            TapHandler {
                  onTapped: {
                    if (_play_button.icon.name === "media-playback-pause-symbolic") {
                        changePause()
                        _play_button.icon.name = "media-playback-start-symbolic"
                    } else {
                        changePlay()
                        _play_button.icon.name = "media-playback-pause-symbolic"
                    }
                }
            }

            // anchors.left: backward_button.right
        }

        RoundButton {
            id: _forward_button
            icon.name: "media-seek-forward"
        }

        Text {
            id: _textOrigin
            text: "00:00"
        }

        Slider {
            id: _playProgressSlider
        }

        Text {
            id: _textTerminus
            text: "3:45"
        }

        RoundButton {
            id: _voiceIcon
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
            width: 50
        }

        RoundButton {
            id: _playlist
            icon.name: "amarok_playlist-symbolic"
        }

        RoundButton {
            id: _fullscreen
            icon.name: "gnumeric-row-hide-symbolic"
        }
    }
}
