/*
 * 负责与 Qml 交互
 */

#ifndef QML_INTERFACE_H
#define QML_INTERFACE_H

#include <QObject>

namespace QuickMCL::utils {
class QmlInterface : public QObject
{
    Q_OBJECT
public:
    // 默认构造函数
    explicit QmlInterface(QObject *parent = nullptr);

    // 启动游戏
    Q_INVOKABLE static const qint64 launchGame(const QString& name, const QString& playerName, const int type = 0);
    // 获取 userList
    Q_INVOKABLE static const QStringList getUserList();
    // 向 userList 中添加用户
    Q_INVOKABLE static void addUserToList(const QString& user);
    // 获取 gameList
    Q_INVOKABLE static const QStringList getGameList();
    // 获取 javaList
    Q_INVOKABLE static const QStringList getJavaList(const QString& game = "");
    // 用路径获取 java 的 index
    Q_INVOKABLE static const int getJavaIndex(const QString& name = "");
    // 设置 java
    Q_INVOKABLE static void setJava(const QString& text, const QString& game = "");
    // 获取版本隔离
    Q_INVOKABLE static const bool getSeperate(const QString& gameName = "");
    // 设置版本隔离
    Q_INVOKABLE static void setSeperate(const bool seperate, const QString& gameName = "");
    // 获取内存大小
    Q_INVOKABLE static const unsigned int getMemory(const QString& gameName = "");
    // 设置内存大小
    Q_INVOKABLE static void setMemory(const unsigned int memoryMiB, const QString& gameName = "");

    // 获取总内存大小
    Q_INVOKABLE static const unsigned int getTotalMemoryMiB();
signals:
};
}
#endif // QML_INTERFACE_H
