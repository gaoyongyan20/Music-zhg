#include <QFile>
#include <QString>
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
        setLyrics();
        emit lyricsFileChanged();
    }
}

QVector<QString> Lyrics::getAllLyrice()
{
    return m_lyrics;
}

int Lyrics::getIndexByKey(QString key)
{
    // 当找不到对应的键时，第二个参数表示返回的值为-1
    return m_keyIndexMap.value(key, -1);
}

void Lyrics::setLyrics()
{
    // 打开歌词文件
    QFile file(m_lyricsFile);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "failed to open lrc file.";
    }

    // 创建流对象
    QTextStream in(&file);

    while (!in.atEnd()) {
        QString line = in.readLine();

        // 判断特殊情况：当一行中有多个时间戳[]字符串，则不做处理
        if (line.count("]") == 1) {
            // 分割时间戳部分和歌词部分的字符串
            auto pos = line.indexOf(']');
            // mid类似于substring,从指定位置提取n个字符串
            QString str_timestamp = line.mid(1, pos - 1);

            QString str_lyrics = line.mid(pos + 1);
            if (!str_lyrics.isEmpty()) {
                // 将提取的歌词放进歌词容器
                m_lyrics.append(str_lyrics);
                // 调用改变时间戳表现形式的函数，得到最终的时间戳

                QString timestamp = changeTimeShow(str_timestamp);
                m_keyIndexMap.insert(timestamp, m_lyrics.size() - 1);
            }
        }
    }
}

QString Lyrics::changeTimeShow(QString timestamp)
{
    return timestamp;
}
