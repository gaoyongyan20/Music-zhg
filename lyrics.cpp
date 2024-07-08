
// The implementation of class lyrics.
// author：何泳珊 周杨康丽 高永艳

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
    emit failedToOpenLrcFile();
}

QVector<QString> Lyrics::getAllLyrics()
{
    // for (auto data : m_lyrics) {
    //     qDebug() << data;
    // }
    return m_lyrics;
}

int Lyrics::getIndexByKey(QString key)
{
    // 第二个参数表示，当找不到key对应的值value时，返回-1
    return m_keyIndexMap.value(key, -1);
}

int Lyrics::getTimeByIndex(int key)
{
    //查找到相应的索引时就返回相应的时间
    return m_reverseTimeMap.value(key, -1);
}

void Lyrics::setLyrics()
{
    // 清除上一首歌曲所占用的容器空间
    m_lyrics.clear();
    m_keyIndexMap.clear();

    // 打开歌词文件
    QFile file(m_lyricsFile);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "failed to open lrc file.";
        emit failedToOpenLrcFile();
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

            // 由于时间戳中有毫秒时不好处理，在qml端计算positon值时不能获取到很精确的计算
            // 所以将有毫秒表示的时间戳进行处理，让其只处理分钟和秒数

            if (str_timestamp.count(".") == 1) {
                auto pos_dot = str_timestamp.indexOf('.');
                str_timestamp = str_timestamp.mid(0, pos_dot);
            }

            // qDebug() << str_timestamp;

            QString str_lyrics = line.mid(pos + 1);

            // qDebug() << str_lyrics;

            if (!str_lyrics.isEmpty()) {
                // 将提取的歌词放进歌词容器
                m_lyrics.append(str_lyrics);
                // qDebug() << "lyrics count:" << m_lyrics.size();

                // // int timestamp = changeTimeShow(str_timestamp);
                // QString timestamp = changeTimeShow(str_timestamp);
                // qDebug() << timestamp;

                // 存取时间戳对应索引的映射

                int timestamp = changeTimeShow(str_timestamp);
                m_keyIndexMap.insert(str_timestamp, m_lyrics.size() - 1);
                m_reverseTimeMap.insert(m_lyrics.size() - 1, timestamp);

                // qDebug() << m_reverseTimeMap.value(4, -1);
            }
        }
    }
    // for (auto data : m_lyrics) {
    //     qDebug() << data;
    // }
}

//时间戳的两种表示方法： 00:00    00:00.00
//00:00    00:00.00
int Lyrics::changeTimeShow(QString timestamp)
{
    QString leftString, midString, rightString;
    int leftInt, midInt, rightInt;
    bool o, k, n;
    int totalMillisecond;

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
