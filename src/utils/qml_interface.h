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
    // 获取 gameList
    Q_INVOKABLE static const QStringList getGameList();
signals:
};
}
#endif // QML_INTERFACE_H
