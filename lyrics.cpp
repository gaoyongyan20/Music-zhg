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

    //获取歌词数组
    QVector<QString> lyrics() const;
    void setLyrics(QString &lyrics);

    // Q_INVOKABLE QString test();
    Q_INVOKABLE QVector<QString> getAllLyrice();

signals:
    Q_SIGNAL void lyricsFileChanged();

private:
    // 当前歌词文件
    QString m_lyricsFile;
    //歌词（值）
    QVector<QString> m_lyrics;
    //到索引的映射
    QMap<QString, int> m_keyIndexMap;
};
