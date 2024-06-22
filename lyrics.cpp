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

//00:00    00:00.00
QString Lyrics::changeTimeShow(QString  timestamp) {
    QString leftString, midString, rightString;
    int leftInt, midInt, rightInt;
    bool o, k, n;
    int totalMillisecond;
    QString totalTimestamp;

    //find the last one to appear index of'.'
    int index = timestamp.QString::lastIndexOf('.');
    //no '.'appear in the timestamp
    if (index == -1) {
        //"11"of"11:22"
        leftString = timestamp.left(2);
        //"22"of"11:22"
        rightString = timestamp.right(2);
        //If ok is not nullptr,
        //failure is reported by setting *ok to false,
        //and success by setting *ok to true.
        leftInt = leftString.toInt(&o, 10);
        if (o) {
            rightInt = rightString.toInt(&k, 10);
            if (k) {
                totalMillisecond = (leftInt * 60 + rightInt) * 1000;
                totalTimestamp = QString::number(totalMillisecond);
                return totalTimestamp;
            } else {
                return "k false";
            }
        } else {
            return "o false";
        }
    } else {
        //"."apperear in the timestamp
        //"11"of"11:22.33"
        leftString = timestamp.left(2);
        //"22"of"11:22.33"
        midString = timestamp.mid(4, 2);
        //"33"of"11:22.33"
        rightString = timestamp.right(2);

        leftInt = leftString.toInt(&o, 10);
        if (o) {
            rightInt = rightString.toInt(&k, 10);
            if (k) {
                midInt = midString.toInt(&n, 10);
                if (n) {
                    totalMillisecond = (leftInt * 60 + midInt) * 1000 + rightInt;
                    totalTimestamp = QString::number(totalMillisecond);
                    return totalTimestamp;
                }
            } else {
                return "k false";
            }
        } else {
            return "o false";
        }
    }
}

