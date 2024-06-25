// The interface of class songlist.
// author: 何泳珊 高永艳 周杨康丽

#pragma once

#include <QQmlEngine>
#include <QtQml/qqmlregistration.h>

class Songlist : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString songListNmae READ songListName WRITE setSongListName NOTIFY
                   songListNameChanged FINAL)
public:
    explicit Songlist(QObject *parent = nullptr);

    // 获取歌单的名字
    QString songListName() const;
    void setSongListName(QString &name);

    // 通过索引index找到对应的url资源，在qml中可以直接调用
    Q_INVOKABLE QUrl getUrlByIndex(int key);

    // 获取所有映射关系
    Q_INVOKABLE QMap<int, QUrl> getAllMap();
signals:
    void songListNameChanged();
    void failedToOpenSongList();

private:
    // 歌单的名字
    QString m_songListName;

    // 获取歌单中所有歌曲的索引与url文件的映射关系
    QMap<int, QUrl> m_keyUrlMap;

    // 设置歌单中的映射关系（在qml中，视图索引对应相应的url）
    void setSongList();

    // 获取所有本地歌词，并将它写入存取本地歌单的文件中
    void getLocalSong(QString listName);
};
