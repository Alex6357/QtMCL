/*
 * BSD 3-Clause License
 *
 * Copyright (c) 2024, Alex11
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its
 *    contributors may be used to endorse or promote products derived from
 *    this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
 * 配置类和文件夹路径等静态配置
 */

#ifndef CONFIG_H
#define CONFIG_H

// #include <QJsonDocument>
#include <QJsonArray>
#include <QDir>
#include <QString>
#include <QObject>

namespace QuickMCL::config{
// 游戏目录名称
static const char* gameDir = ".minecraft/";
// 基本配置文件目录
static const char* configDir = ".quickmcl/";
// Windows 配置文件目录
static const char* windowsConfigDir = "QuickMCL/";
// 配置文件名称
static const char* configFile = "config.json";
// 临时目录名称
static const char* tempDir = "quickmcl/";

// 游戏目录位置枚举，local 为启动器相同目录，global 为用户目录，custom 为自定义
enum gameDirPlace {
    localGameDir = 0,
    globalGameDir = 1,
    customGameDir = 2
};

// 配置文件位置枚举，local 为启动器相同目录，global 为用户目录
enum configDirPlace {
    localConfigDir = 0,
    globalConfigDir = 1,
};

// 操作系统类型枚举
enum system {
    windows = 0,
    linux = 1,
    macos = 2,
    freebsd = 3,
    unknown = 4
};

// 架构枚举
enum arch {
    amd64 = 0,
    x86 = 1,
    arm64 = 2,
    others = 3
};

class Config : public QObject
{
    Q_OBJECT
private:
    // 配置文件位置变量
    enum configDirPlace configDirPlace = configDirPlace::localConfigDir;
    // 游戏目录位置变量
    enum gameDirPlace gameDirPlace = gameDirPlace::localGameDir;
    // 系统架构
    enum arch arch;
    // 系统类型
    enum system system;
    // 系统名称
    QString systemName;
    // 系统版本号
    QString systemVersion;
    // 配置文件位置
    QString configDir;
    // 游戏目录位置
    QString gameDir;
    // 临时文件位置
    QString tempDir = QDir::tempPath() + "/" + (QuickMCL::config::tempDir);
public:
    explicit Config(QObject *parent = nullptr);
    ~Config();

    static Config* const getGlobalConfigPtr();
    static const QStringList getUserListCopy();
    static void addToUserList(const QString user);
    static QStringList* const getUserListPtr();

    const enum configDirPlace getConfigDirPlace() const {return this->configDirPlace;};
    void setConfigDirPlace(const enum configDirPlace configDirPlace);

    const enum gameDirPlace getGameDirPlace() const {return this->gameDirPlace;};
    void setGameDirPlace(const enum gameDirPlace gameDirPlace);

    const enum arch getArch() const {return this->arch;};
    void setArch(const enum arch arch);

    const enum system getSystem() const {return this->system;};
    void setSystem(const enum system system);

    const QString getSystemName() const {return this->systemName;};
    void setSystemName(const QString systemName);

    const QString getSystemVersion() const {return this->systemVersion;};
    void setSystemVersion(const QString systemVersion);

    const QString getConfigDir() const {return this->configDir;};
    void setConfigDir(const QString configDir);

    const QString getGameDir() const {return this->gameDir;};
    void setGameDir(const QString gameDir);

    const QString getTempDir() const {return this->tempDir;};
    void setTempDir(const QString tempDir);


    void readConfig();
    void readConfigFromFile(const QString& file);
    void readUserListFromArray(const QJsonArray& array);

    const QString getConfigDirName() const;
    const QString getGlobalConfigDir() const;
    const QString getGlobalGameDir() const;

    const QString getActuralConfigDir() const;
    const QString getActuralGameDir() const;

    const QString getArchInMinecraft() const;
    const QString getSystemNameInMinecraft() const;
};
}

#endif // CONFIG_H
