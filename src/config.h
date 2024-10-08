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

// 取消定义 linux，防止跟枚举量中的 linux 冲突
#undef linux

// #include <QJsonDocument>
#include <QJsonArray>
#include <QDir>
#include <QString>
#include <QObject>

namespace QuickMCL::config{
// 游戏目录名称
extern const char* gameDir;
// 基本配置文件目录
extern const char* configDir;
// Windows 配置文件目录
extern const char* windowsConfigDir;
// 配置文件名称
extern const char* configFile;
// 游戏列表文件名称
extern const char* gameListFile;
// 临时目录名称
extern const char* tempDir;

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

class Config
{
private:
    // 配置文件位置类型
    enum configDirPlace configDirPlace = configDirPlace::localConfigDir;
    // 游戏目录位置类型
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
    // 上次启动游戏名称
    QString lastGame;
public:
    // 默认构造函数
    explicit Config(QObject *parent = nullptr);
    // 默认析构函数
    ~Config();

    // 获取 globalConfig 指针
    static Config* const getGlobalConfigPtr();
    // 获取用户列表的副本
    static const QStringList getUserListCopy();
    // 将用户添加到用户列表
    static void addToUserList(const QString user);
    // 获取用户列表指针
    static QStringList* const getUserListPtr();

    // 获取配置文件位置类型
    const enum configDirPlace getConfigDirPlace() const {return this->configDirPlace;};
    // 设置配置文件位置类型
    void setConfigDirPlace(const enum configDirPlace configDirPlace);

    // 获取游戏目录位置类型
    const enum gameDirPlace getGameDirPlace() const {return this->gameDirPlace;};
    // 设置游戏目录位置类型
    void setGameDirPlace(const enum gameDirPlace gameDirPlace);

    // 获取系统架构
    const enum arch getArch() const {return this->arch;};
    // 设置系统架构
    void setArch(const enum arch arch);

    // 获取系统类型
    const enum system getSystem() const {return this->system;};
    // 设置系统类型
    void setSystem(const enum system system);

    // 获取系统名称
    const QString getSystemName() const {return this->systemName;};
    // 设置系统名称
    void setSystemName(const QString systemName);

    // 获取系统版本号
    const QString getSystemVersion() const {return this->systemVersion;};
    // 设置系统版本号
    void setSystemVersion(const QString systemVersion);

    // 获取配置文件路径
    const QString getConfigDir() const {return this->configDir;};
    // 设置配置文件路径
    void setConfigDir(const QString configDir);

    // 获取游戏目录路径
    const QString getGameDir() const {return this->gameDir;};
    // 设置游戏目录路径
    void setGameDir(const QString gameDir);

    // 获取临时文件路径
    const QString getTempDir() const {return this->tempDir;};
    // 设置临时文件路径
    void setTempDir(const QString tempDir);

    // 获取上次游戏名称
    const QString getLastGame() const {return this->tempDir;};
    // 设置上次游戏名称
    void setLastGame(const QString lastGame);

    // 自动寻找并读取配置文件
    void readConfig();
    // 从配置文件读取配置
    void readConfigFromFile(const QString& file);
    // 向配置文件写入配置
    void writeConfigToFile();
    // 从 json array 读取用户列表
    void readUserListFromArray(const QJsonArray& array);

    // 获取配置目录名称
    const QString getConfigDirName() const;
    // 获取全局配置目录
    const QString getGlobalConfigDir() const;
    // 获取全局游戏目录
    const QString getGlobalGameDir() const;

    // 获取实际的配置文件目录
    const QString getActuralConfigDir() const;
    // 获取实际的游戏目录
    const QString getActuralGameDir() const;

    // 获取版本 json 文件中架构的写法
    const QString getArchInMinecraft() const;
    // 获取版本 json 文件中系统名称的写法
    const QString getSystemNameInMinecraft() const;
};
}

#endif // CONFIG_H
