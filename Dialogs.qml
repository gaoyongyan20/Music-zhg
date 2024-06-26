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
    property alias failToOpen: _failToOpen
    property alias buttonRoutine: _buttonRoutine
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
        detailedText: "Copyright©2024  (open-src@qq.com)"
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
                id: _text
                Layout.fillWidth: true
                placeholderText: "Please enter your timing(minutes)"
                validator: RegularExpressionValidator {
                    regularExpression: /^[1-9]\d{0,3}$/
                }
                onTextChanged: {
                    button.enabled = _text.text !== ""
                    _buttonRoutine.enabled = _text.text !== ""
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
        }
    }
}
