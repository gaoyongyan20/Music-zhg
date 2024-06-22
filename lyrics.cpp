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

QString Lyrics::test()
{
    return "hello";
}
