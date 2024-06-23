// The interface of class lyrics.
// author：何泳珊 周杨康丽 高永艳

#pragma once
#include <QQmlEngine>
#include <QtQml/qqmlregistration.h>

class Lyrics : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString lyricsFile READ lyricsFile WRITE setLyricsFile NOTIFY lyricsFileChanged)

public:
    explicit Lyrics(QObject *parent = NULL);

    //获取lrc歌词文件的路径
    QString lyricsFile() const;
    void setLyricsFile(QString &file);

    //得到存储歌词的容器，可以在qml中使用这个函数获取所有歌词
    Q_INVOKABLE QVector<QString> getAllLyrics();

    //通过键（时间戳）查找索引（歌词所在视图的索引）
    Q_INVOKABLE int getIndexByKey(QString key);

signals:
    void lyricsFileChanged();

private:
    // 当前歌词文件
    QString m_lyricsFile;

    //歌词（值）
    QVector<QString> m_lyrics;

    //到索引的映射
    QMap<QString, int> m_keyIndexMap;

    //改变时间戳的格式（00：00->毫秒）
    QString changeTimeShow(QString timestamp);

    // 设置歌词
    void setLyrics();
};
