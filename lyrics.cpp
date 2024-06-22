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

QString Lyrics::changeTimeShow(QString time) {}
