

// The interface of class imagelist.
// author: 何泳珊 高永艳 周杨康丽

#pragma once

#include <QQmlEngine>
#include <QtQml/qqmlregistration.h>

class Imagelist : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    // Q_PROPERTY(QString iamgeListName READ imageListName WRITE setImageListName NOTIFY
    //                imageListNameChanged FINAL)

public:
    explicit Imagelist(QObject *parent = nullptr);
    //打开指定的存储文件txt
    Q_INVOKABLE void openfile();

    void addimage();

    // 获取所有映射关系
    Q_INVOKABLE QMap<int, QUrl> getAllMap();
    Q_INVOKABLE int getMapCount();
    // 找文件的对应路径进行加载
    Q_INVOKABLE QUrl getUrlByIndex(int key);
    //获取图片的路径
    Q_INVOKABLE void writeimagepath(QUrl path);

private:
    //将设置的本地文件里面的东西读取，然后以行号加路径做成键值对。
    QMap<int, QUrl> m_keyUrlMap;
};
