import QtQuick
import QtCore
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts

Item {
    id: dialogroot
    property alias fileOpen: _fileOpen
    property alias about: _about
    property alias timingoffDialog: _timingoffDialog
    property alias timingofftext: _timingofftext
    property alias buttonMusic: _buttonMusic
    property alias failToOpen: _failToOpen
    property alias buttonRoutine: _buttonRoutine
    property alias rateChangeDialog: _rateChangeDialog
    property alias rateSlider: _rateSlider
    property alias pomodoroTimerDialog: _pomodoroTimerDialog
    property alias pomodoroTimerButton: _pomodoroTimerButton
    property alias pomodoroTimertext: _pomodoroTimertext
    property alias playlistIsEmptyDialog: _playlistIsEmptyDialog
    property alias pomodorotimerrepeat: _pomodorotimerrepeat
    property alias yesPomodorotimerRepeat: _yesPomodorotimerRepeat
    property alias noPomodorotimerRepeat: _noPomodorotimerRepeat
    FileDialog {
        id: _fileOpen
        title: "Select some song files"
        currentFolder: StandardPaths.standardLocations(
                           StandardPaths.DocumentsLocation)[0]
        fileMode: FileDialog.OpenFiles
        nameFilters: ["audio files (*.mp3)"]
    }
    MessageDialog {
        id: _about
        modality: Qt.WindowModal
        buttons: MessageDialog.Ok
        text: "This is a music player."
        informativeText: qsTr("Freemusic is a free software, and you can download its source code from www.open-src.com")
        detailedText: "Copyright©2024  (2026614567@qq.com,3247859095@qq.com,2327014830@qq.com)"
    }
    MessageDialog {
        id: _failToOpen
        modality: Qt.WindowModal
        buttons: MessageDialog.Ok
        text: "Fail to open the file (.lrc)!"
    }
    Dialog {
        id: _timingoffDialog
        title: "select timingoff"
        width: 300
        height: 200
        ColumnLayout {
            anchors.fill: parent
            TextField {
                id: _timingofftext
                Layout.fillWidth: true
                placeholderText: qsTr("Please enter your timing(minutes)")
                placeholderTextColor: "black"
                validator: RegularExpressionValidator {
                    regularExpression: /^[1-9]\d{0,3}$/
                }
                onTextChanged: {
                    _buttonMusic.enabled = _timingofftext.text !== ""
                    _buttonRoutine.enabled = _timingofftext.text !== ""
                    _pomodoroTimer.enabled = _timingofftext.text !== ""
                }
            }
            Button {
                id: _buttonMusic
                Layout.fillWidth: true
                text: "ColseMusic"
                enabled: false
            }
            Button {
                id: _buttonRoutine
                Layout.fillWidth: true
                text: "ColseRoutine"
                enabled: false
            }
        }
    }

    Dialog {
        id: _pomodoroTimerDialog
        title: "select timingoff"
        width: 300
        height: 200
        ColumnLayout {
            anchors.fill: parent
            TextField {
                id: _pomodoroTimertext
                Layout.fillWidth: true
                placeholderText: qsTr("Please enter your focus time(minutes)")
                placeholderTextColor: "black"
                validator: RegularExpressionValidator {
                    regularExpression: /^[1-9]\d{0,3}$/
                }
                onTextChanged: {
                    _pomodoroTimerButton.enabled = _pomodoroTimertext.text !== ""
                }
            }
            Button {
                id: _pomodoroTimerButton
                Layout.fillWidth: true
                text: "PomodoroTimer"
                enabled: false
            }
        }
    }
    Dialog {
        id: _playlistIsEmptyDialog
        width: 300
        height: 100
        Text {
            anchors.centerIn: parent
            text: "Your playlist is empty."
        }
    }

    Dialog {
        id: _pomodorotimerrepeat
        title: "Does the Pomodoro timer repeat?"
        width: 300
        height: 100
        RowLayout {
            anchors.centerIn: parent
            Button {
                id: _yesPomodorotimerRepeat
                text: "Yes"
            }
            Button {
                id: _noPomodorotimerRepeat
                text: "No"
            }
        }
    }

    Dialog {
        id: _rateChangeDialog
        title: "select rate"
        width: 300
        height: 100
        ColumnLayout {
            anchors.centerIn: parent
            Slider {
                id: _rateSlider
                implicitHeight: 5
                implicitWidth: 250
                background: Rectangle {
                    implicitHeight: 2
                    radius: 5
                    border.color: "grey"
                    color: "lightblue"
                }
            }
            RowLayout {
                spacing: 55
                Text {
                    text: "0.5"
                }
                Text {
                    text: "1.0"
                }
                Text {
                    text: "1.5"
                }
                Text {
                    text: "2.0"
                }
            }
        }
    }
}
