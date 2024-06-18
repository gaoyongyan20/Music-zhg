import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {

    RowLayout {
        id: layout
        anchors.bottom: parent.bottom
        spacing: 6

        RoundButton {
            id: backward_button
            icon.name: "media-seek-backward"
        }

        RoundButton {
            id: play_button
            icon.name: "media-playback-start-symbolic"
            // anchors.left: backward_button.right
        }

        RoundButton {
            icon.name: "media-seek-forward"
        }

        Text {
            text: "00:00"
        }

        Slider {
            id: playProgressSlider
        }

        Text {
            text: "3:45"
        }

        RoundButton {
            icon.name: "player-volume"
        }

        Slider {
            id: volumeSlider
            width: 50
        }

        RoundButton {
            icon.name: "amarok_playlist-symbolic"
        }

        RoundButton {
            icon.name: "gnumeric-row-hide-symbolic"
        }
    }
}
