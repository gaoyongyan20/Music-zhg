

/* There are all actions's UIs in the musicplayer app.
 * Author: 何泳珊 高永艳 周扬康丽
*/
import QtQuick
import QtQuick.Controls

Item {
    property alias open: _open
    property alias loop: _loop
    property alias random: _random
    property alias timingoff: _timingoff
    property alias background: _background
    property alias about: _about
    property alias song1: _song1
    property alias song2: _song2
    property alias sequence: _sequence
    property alias close1: _close

    Action {
        id: _open
        text: qsTr("&OpenFiles..")
        icon.name: "document-open"
        shortcut: StandardKey.Open
    }

    Action {
        id: _loop
        text: qsTr("Loop")
        icon.name: "media-repeat-track-amarok-symbolic"
    }

    Action {
        id: _random
        text: qsTr("Random")
        icon.name: "media-playlist-shuffle"
        icon.color: "black"
    }

    Action {
        id: _sequence
        text: qsTr("Sequence")
        icon.name: "media-playlist-normal-symbolic"
        icon.color: "red"
    }

    Action {
        id: _background
        text: qsTr("Backgrond")
        icon.name: "games-config-theme-symbolic"
        icon.color: "black"
    }

    Action {
        id: _timingoff
        text: qsTr("Timingoff")
        icon.name: "accept_time_event-symbolic"
    }

    Action {
        id: _about
        text: qsTr("About")
        icon.name: "help-about"
    }

    Action {
        id: _backward
        text: qsTr("Backward")
        icon.name: "media-seek-backward-symbolic"
    }

    Action {
        id: _forward
        text: qsTr("Forward")
        icon.name: "media-seek-forward-symbolic"
    }

    Action {
        id: _exit
        icon.name: "application-exit"
    }
    Action {
        id: _song1
        text: qsTr("海阔天空")
        icon.name: "folder-music-symbolic"
    }
    Action {
        id: _song2
        text: qsTr("Valder Fields")
        icon.name: "folder-music-symbolic"
    }
    Action {
        id: _close
        text: qsTr("close")
    }
}
