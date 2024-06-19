import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    property alias playProgressSlider: _playProgressSlider
    property alias volumeSlider: _volumeSlider
    property alias textOrigin: _textOrigin
    property alias textTerminus: _textTerminus
    property alias voiceIcon: _voiceIcon
    property alias playlist: _playlist
    property alias fullscreen:_fullscreen
    RowLayout {
        id: layout
        anchors.bottom: parent.bottom
        spacing: 6

        RoundButton {
            id: backward_button
            icon.name: "media-seek-backward"
        }

        RoundButton {
            id: _play_button
            icon.name: "media-playback-start-symbolic"
            // anchors.left: backward_button.right
        }

        RoundButton {
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
            icon.name: "player-volume"
        }

        Slider {
            id: _volumeSlider
            width: 50
        }

        RoundButton {
            id:_playlist
            icon.name: "amarok_playlist-symbolic"
        }

        RoundButton {
            id:_fullscreen
            icon.name: "gnumeric-row-hide-symbolic"
        }
    }
}
