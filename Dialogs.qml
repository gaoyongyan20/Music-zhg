import QtQuick
import QtCore
import QtQuick.Controls
import QtQuick.Dialogs

Item {
    property alias fileOpen: _fileOpen
    property alias about: _about
    FileDialog {
        id: _fileOpen
        title: "Select some song files"
        currentFolder: StandardPaths.standardLocations(
                           StandardPaths.DocumentsLocation)[0]
        fileMode: FileDialog.OpenFiles
        nameFilters: ["audio files (*.mp3 *)"]
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
        text: "Fail to save the file!"
    }
}
