#include <lyrics.h>

Lyrics::Lyrics(QObject *parent)
    : QObject(parent)
{}

QString Lyrics::lyricsFile() const
{
    return m_lyricsFile;
}

void Lyrics::setLyricsFile(QString &file)
{
    if (file != m_lyricsFile) {
        m_lyricsFile = file;
        spiltLyrics(); // 成功设置歌词容器
        emit lyricsFileChanged();
    }
}

QVector<QString> Lyrics::getAllLyrice()
{
    return m_lyrics;
}

int Lyrics::getIndexByKey(QString key)
{
    return 1;
}

void Lyrics::spiltLyrics() {}

QString Lyrics::changeTimeShow(QString timestamp)
{
    return timestamp;
}
