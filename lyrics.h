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

    Q_INVOKABLE QString test();

signals:
    Q_SIGNAL void lyricsFileChanged();

private:
    // 当前歌词文件
    QString m_lyricsFile;
    //歌词（值）
    QVector<QString> m_lycric;
    //键（时间）到索引的映射
    QMap<QString, int> m_keyIndexMap;
};
