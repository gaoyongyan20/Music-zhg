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
    property alias text: _text
    property alias button: _button
    // property alias failToOpen: _failToOpen
    property alias buttonRoutine: _buttonRoutine
    property alias rateChangeDialog: _rateChangeDialog
    property alias rateSlider: _rateSlider
    property alias pomodoroTimer: _pomodoroTimer
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
    // MessageDialog {
    //     id: _failToOpen
    //     modality: Qt.WindowModal
    //     buttons: MessageDialog.Ok
    //     text: "Fail to open the file (.lrc)!"
    // }
    Dialog {
        id: _timingoffDialog
        title: "select timingoff"
        width: 300
        height: 200
        ColumnLayout {
            anchors.fill: parent
            TextField {
                id: _text
                Layout.fillWidth: true
                placeholderText: qsTr("Please enter your timing(minutes)")
                placeholderTextColor: "black"
                validator: RegularExpressionValidator {
                    regularExpression: /^[1-9]\d{0,3}$/
                }
                onTextChanged: {
                    button.enabled = _text.text !== ""
                    _buttonRoutine.enabled = _text.text !== ""
                    _pomodoroTimer.enabled = _text.text !== ""
                }
            }
            Button {
                id: _button
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
            Button {
                id: _pomodoroTimer
                Layout.fillWidth: true
                text: "PomodoroTimer"
                enabled: false
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
