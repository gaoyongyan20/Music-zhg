import QtQuick
import QtQuick.Layouts

Rectangle {
    property alias lrcmodel: _lrcmodel
    property alias list: _list
    signal changep
    id: lyricView
    clip: true
    // visible: true
    ListView {
        id: _list
        anchors.fill: parent
        width: 600
        height: 20
        // model: ["当前歌词的上一句", "当前歌词", "当前歌词的下一句", "当前歌词的下2句", "当前歌词的下3句"]
        ListModel {
            id: _lrcmodel
        }

        delegate: ListDelegate {}
        highlight: Rectangle {
            // color: "#7fff00"
            color: "transparent"
        }
        //此属性保存突出显示是否由视图管理。如果此属性为 true (默认值) ，则将平滑地移动突出显示以跟随当前项。否则，突出显示不会被视图移动，任何移动都必须由突出显示实现
        highlightFollowsCurrentItem: true
        //移动速度和持续时间属性用于控制由于索引更改而导致的移动;
        highlightMoveDuration: 10000
        //指定了高亮区域大小变化的动画持续时间。当设置为 0 时，意味着高亮区域的大小变化将立即发生，
        //没有动画效果，即高亮区域的大小会瞬间跳变到新的大小，而不会有逐渐变化的过程。这通常用于需要立即反映状态变化的情况，避免因动画延迟而造成的用户体验问题。
        highlightResizeDuration: 30000
        currentIndex: 0
        //高亮显示的位置是整个歌词滚动的中间
        preferredHighlightBegin: parent.height / 2 - 50
        preferredHighlightEnd: parent.height / 2
        //高光永远不会超出范围。如果键盘或鼠标将导致突出显示移出范围，则当前项将发生更改。
        highlightRangeMode: ListView.StrictlyEnforceRange
    }
    component ListDelegate: Item {
        id: delegateItem
        width: list.width
        height: 50
        required property string ci
        required property int index

        Text {
            id: recText
            font.bold: true
            font.pixelSize: 13
            text: ci
            color: list.currentIndex === index ? "red" : "black"
            anchors.centerIn: parent
        }
        TapHandler {
            onTapped: {
                list.currentIndex = index
                changep()
            }
        }
        states: State {
            when: delegateItem.ListView.isCurrentItem
            name: "currentlyrics"
            PropertyChanges {
                target: delegateItem
                scale: 1.8
            }
        }
        FocusScope {
            TapHandler {
                onTapped: {
                    list.currentIndex = index
                }
            }
        }
    }
}
