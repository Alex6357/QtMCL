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
    explicit QmlInterface(QObject *parent = nullptr);

    Q_INVOKABLE static const qint64 launchGame(const QString& name, const QString& playerName, const int type = 0);
    Q_INVOKABLE static const QStringList getUserList();
    Q_INVOKABLE static const QStringList getGameList();
signals:
};
}
#endif // QML_INTERFACE_H
