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

    //获取lrc文件的路径
    QString lyricsFile() const;
    void setLyricsFile(QString &file);

    //得到存储歌词的容器，可以在qml中使用这个函数
    Q_INVOKABLE QVector<QString> getAllLyrice();

    //通过键（时间戳）查找索引（歌词所在视图的索引）
    Q_INVOKABLE int getIndexByKey(QString key);

signals:
    Q_SIGNAL void lyricsFileChanged();
    Q_SIGNAL void lyricsChanged();

private:
    // 当前歌词文件
    QString m_lyricsFile;

    //歌词（值）
    QVector<QString> m_lyrics;

    //到索引的映射
    QMap<QString, int> m_keyIndexMap;

    //分割字符串（时间戳和歌词）
    void spiltLyrics();

    //改变时间戳的格式（00：00->毫秒）
    QString changeTimeShow(QString timestamp);
};
