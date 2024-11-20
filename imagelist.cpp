

// The implementation of class imagelist.
// author: 何泳珊 高永艳 周杨康丽

#include "imagelist.h"
#include <QFile>
#include <QFileInfo>
#include <QFileInfoList>
#include <QStringList>

Imagelist::Imagelist(QObject *parent)
    : QObject{parent}
{}

QMap<int, QUrl> Imagelist::getAllMap()
{
    return m_keyUrlMap;
}

int Imagelist::getMapCount()
{
    return m_keyUrlMap.size();
}

QUrl Imagelist::getUrlByIndex(int key)
{
    return m_keyUrlMap.value(key, QUrl(""));
}

void Imagelist::writeimagepath(QUrl path)
{
    QFile file("/root/background_image.txt");
    if (!file.open(QIODevice::Append | QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "fail to open imagelist file";
    }
    QString pathname = path.toString();

    QTextStream out(&file);

    qDebug() << pathname << '\n';

    if (file.size() == 0) {
        out << pathname << '\n';
    }
    out.seek(0);
    int i = 0, j = 0;
    QString line;
    while (!out.atEnd()) {
        line = out.readLine();
        i++;
        if (!line.isEmpty() && line == pathname) {
            break;
        } else {
            j++;
            continue;
        }
    }
    if (i == j) {
        out << pathname << '\n';
        qDebug() << line << '\n';
    }
}
//打开指定的存储文件txt
void Imagelist::openfile()
{
    QFile file("/root/background_image.txt");
    // if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
    //     qDebug() << "fail to open imagelist file";
    // }

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        // 文件不存在，尝试以读写模式创建文件
        file.open(QIODevice::ReadWrite | QIODevice::Text);
    }

    QTextStream in(&file);
    int lineNum = 0;

    while (!in.atEnd()) {
        QString line = in.readLine();

        if (!line.isEmpty()) {
            QUrl url(line);
            m_keyUrlMap.insert(lineNum, url);
            lineNum++;
        }
    }
}
