// The implementation of class songlist.
// author: 何泳珊 高永艳 周杨康丽

#include "songlist.h"
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QFileInfoList>
#include <QStringList>

Songlist::Songlist(QObject *parent)
    : QObject{parent}
{}

QString Songlist::songListName() const
{
    return m_songListName;
}

void Songlist::setSongListName(QString &name)
{
    if (name != m_songListName) {
        m_songListName = name;
        setSongList();
        emit songListNameChanged();
    }
}

QUrl Songlist::getUrlByIndex(int key)
{
    // 若没找到对应的键对应的值，返回-1
    return m_keyUrlMap.value(key, QUrl(""));
}

QMap<int, QUrl> Songlist::getAllMap()
{
    return m_keyUrlMap;
}

void Songlist::setSongList()
{
    if (!m_keyUrlMap.isEmpty()) {
        m_keyUrlMap.clear();
    }
    QString songListPath;
    // 单独处理默认存在的本地歌单，将所有本地歌单信息先写入本地歌单列表
    if (m_songListName == "local") {
        getLocalSong("local");
    }
    songListPath = "/root/tmp/" + m_songListName + ".txt";

    // 打开歌单文件，读取歌单中歌曲信息
    QFile file(songListPath);
    QTextStream in(&file);

    int lineNum = 0;
    // 一行行读歌单文件，将映射关系存入map中
    while (!in.atEnd()) {
        QString line = in.readLine();

        if (!line.isEmpty()) {
            QUrl url(line);
            m_keyUrlMap.insert(lineNum, url);
            lineNum++;
        }
    }
    file.close();
}

void Songlist::getLocalSong(QString listName)
{
    // 指定存储音频文件的目录
    QDir dir("/root/tmp");

    // 设置文件名过滤器（只筛选出以.mp3为后缀的）
    // 若后期要添加更多音频文件格式进行过滤，可以直接在filter中写入更多格式
    QStringList filter;
    filter << "*.mp3";
    dir.setNameFilters(filter);

    // 获取/root/tmp目录下的文件条目列表
    QFileInfoList list = dir.entryInfoList();

    // 字符串拼接，获取本地歌单的的文件路径名
    QFile file(dir.dirName() + "/" + listName + ".txt");
    QTextStream out(&file);

    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qDebug() << "failed to open songlist file";
        emit failedToOpenSongList();
    }

    // 循环遍历该列表，获取每个条目的文件名字
    for (int i = 0; i != list.size(); i++) {
        QFileInfo fileInfo = list.at(i);

        // fileName()函数返回的文件名包含后缀名，而baseName()函数只包含文件名
        QString fileName = fileInfo.fileName();

        // 获取表示每一个url文件路径的字符串
        QString urlPath = "file://" + dir.dirName() + "/" + fileName;
        qDebug() << urlPath;

        // 将获取的每一行字符串和换行符写入歌单文件
        out << urlPath << '\n';
    }

    // 关闭文件
    file.close();
}
