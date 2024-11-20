
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

    //获取歌词数组
    QVector<QString> lyrics() const;
    void setLyrics(QString &lyrics);

    //通过键（时间戳）查找索引（歌词所在视图的索引）
    Q_INVOKABLE int getIndexByKey(QString key);

    //通过键（索引）查找时间戳
    Q_INVOKABLE int getTimeByIndex(int key);

signals:
    Q_SIGNAL void lyricsFileChanged();
    Q_SIGNAL void failedToOpenLrcFile();

private:
    // 当前歌词文件
    QString m_lyricsFile;

    //歌词（值）
    QVector<QString> m_lyrics;

    //到索引的映射
    QMap<QString, int> m_keyIndexMap;

    //到时间戳的映射
    QMap<int, int> m_reverseTimeMap;

    //时间戳数组
    // QVector<int> m_times;

    //改变时间戳的格式（00：00->毫秒）
    int changeTimeShow(QString timestamp);

    // 设置歌词
    bool setLyrics();
};
