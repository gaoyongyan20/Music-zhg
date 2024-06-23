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
    for (auto data : m_lyrics) {
        qDebug() << data;
    }
    return m_lyrics;
}

int Lyrics::getIndexByKey(int key)
{
    // 当找不到对应的键时，第二个参数表示返回的值为-1
    return m_keyIndexMap.value(key, -1);

    // for (const auto &data : m_keyIndexMap) {
    //     if (key < data.first() && data.first() < key + 52) {
    //         return data.value(); // 注意QMap使用value()而不是second
    //         break;
    //     } else
    //         return -1;
    // }
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
            // qDebug() << str_timestamp;

            QString str_lyrics = line.mid(pos + 1);

            // qDebug() << str_lyrics;
            if (!str_lyrics.isEmpty()) {
                // 将提取的歌词放进歌词容器
                m_lyrics.append(str_lyrics);
                // 调用改变时间戳表现形式的函数，得到最终的时间戳

                int timestamp = changeTimeShow(str_timestamp);
                qDebug() << timestamp;
                m_keyIndexMap.insert(timestamp, m_lyrics.size() - 1);
            }
        }
    }
    // for (auto data : m_lyrics) {
    //     qDebug() << data;
    // }
}

//00:00    00:00.00
int Lyrics::changeTimeShow(QString timestamp)
{
    QString leftString, midString, rightString;
    int leftInt, midInt, rightInt;
    bool o, k, n;
    int totalMillisecond;
    // QString totalTimestamp;

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
                // totalTimestamp = QString::number(totalMillisecond);
                return totalMillisecond;
            } else {
                return -1;
            }
        } else {
            return -1;
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
                    // totalTimestamp = QString::number(totalMillisecond);
                    return totalMillisecond;
                }
            } else {
                return -1;
            }
        } else {
            return -1;
        }
    }
    return -1;
}
