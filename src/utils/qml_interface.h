/*
 * 负责与 Qml 交互
 */

#ifndef QML_INTERFACE_H
#define QML_INTERFACE_H

#include <QObject>
#include <QtTypes>
#include <QString>
#include <QStringList>
#include <QVariantList>

namespace QuickMCL::utils {
class QmlInterface : public QObject
{
    Q_OBJECT
private:
    static QString currentGame;
public:
    // 默认构造函数
    explicit QmlInterface(QObject *parent = nullptr);

    // 启动游戏
    Q_INVOKABLE static const qint64 launchGame(const QString& name, const QString& playerName, const int type = 0);
    // 获取现在的游戏名称
    Q_INVOKABLE static const QString getCurrentGame();
    // 设置现在的游戏名称
    Q_INVOKABLE static void setCurrentGame(const QString& gameName);
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
    // 获取是否自定义窗口大小
    Q_INVOKABLE static const bool hasResolutionFeature(const QString& gameName = "");
    // 获取自定义窗口大小
    Q_INVOKABLE static const QVariantList getResolution(const QString& gameName = "");
    // 设置自定义窗口大小
    Q_INVOKABLE static void setResolution(const int width, const int height, const QString& gameName = "");
    // 获取 jvm 参数
    Q_INVOKABLE static const QString getJvmParameters(const QString& gameName = "");
    // 设置 jvm 参数
    Q_INVOKABLE static void setJvmParameters(const QString& parameters, const QString& gameName = "");
    // 获取是否是 demo 模式
    Q_INVOKABLE static const bool hasDemoFeature(const QString& gameName = "");
    // 设置 demo 模式
    Q_INVOKABLE static void setDemo(const bool demo, const QString& gameName = "");
    // 获取是否采用全局基础设置
    Q_INVOKABLE static const bool getUseGlobalBasic(const QString& gameName = "");
    // 设置是否采用全局基础设置
    Q_INVOKABLE static void setUseGlobalBasic(const bool useGlobalBasic, const QString& gameName = "");
    // 获取是否采用全局高级设置
    Q_INVOKABLE static const bool getUseGlobalAdvance(const QString& gameName = "");
    // 设置是否采用全局高级设置
    Q_INVOKABLE static void setUseGlobalAdvance(const bool useGlobalBasic, const QString& gameName = "");

    // 获取总内存大小
    Q_INVOKABLE static const unsigned int getTotalMemoryMiB();
signals:
};
}
#endif // QML_INTERFACE_H
