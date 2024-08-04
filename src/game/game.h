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
 * 游戏类，存储游戏相关设置
 */

#ifndef GAME_H
#define GAME_H

#include <QObject>
#include <QString>
#include <QStringList>
#include <QJsonObject>
#include <QMap>
#include <QGlobalStatic>
#include <QJsonArray>
#include <QDir>
#include "../utils/java.h"

namespace QuickMCL::game {
// java 库位置
static const char* libraryDir = "libraries/";
// 资源文件目录
static const char* assetsRoot = "assets/";
// 用户类型
static const char* userType = "msa";
// 版本类型
static const char* versionType = "QuickMCL";
// 最小内存大小，单位 MB
static const int minimumMemory = 256;
// log4j2 配置文件位置
static const char* log4j2Name = "log4j2.xml";
// 快速游戏日志文件路径
static const char* quickPlayPath = "quickplaylog.json";

class Game
{
private:
    // 游戏名称
    QString name = "DefaultConfig";
    // java 版本
    const QuickMCL::utils::Java* java = nullptr;
    // 游戏目录位置
    bool seperate = true;
    // 最小内存大小，单位 MB
    int minimumMemory = 256;
    // 最大内存大小，单位 MB
    int maximumMemory = 256;
    // JVM 参数
    QStringList jvmParameters = {
        "-Dlog4j2.formatMsgNoLookups=true",
        "-Dcom.sun.jndi.rmi.object.trustURLCodebase=false",
        "-Dcom.sun.jndi.cosnaming.object.trustURLCodebase=false",
        "-XX:-OmitStackTraceInFastThrow",
        "-XX:-UseAdaptiveSizePolicy",
        "-Dfml.ignoreInvalidMinecraftCertificates=true",
        "-Dfml.ignorePatchDiscrepancies=true",
        QDir::toNativeSeparators("-Dlog4j.configurationFile=${game_directory}/log4j2.xml"),
        "-XX:+UnlockExperimentalVMOptions",
        "-XX:+UseG1GC",
        "-XX:G1NewSizePercent=20",
        "-XX:G1ReservePercent=20",
        "-XX:MaxGCPauseMillis=50",
        "-XX:G1HeapRegionSize=32M"
    };
    // 所有 feature
    QStringList features;
    // 自定义窗口宽度
    int resolutionWidth = 873;
    // 自定义窗口高度
    int resolutionHeight = 486;
    // 自定义服务器 ip
    QString server = "";
    // 自定义服务器端口
    int port = 25565;
    // 快速游戏单人存档名称
    QString quickPlaySinglePlayer = "";
    // 快速游戏多人服务器
    QString quickPlayMultiPlayer = "";
    // 快速游戏 realms
    int quickPlayRealms = 0;
public:
    // 默认构造函数
    Game();
    // 根据游戏名称新建配置，并从 globalGameConfig 复制配置
    Game(const QString& name);

    // 获取游戏名称
    const QString getName() const {return this->name;};
    // 设置游戏名称
    void setName(const QString& name);

    // 获取游戏 java
    const QuickMCL::utils::Java* getJava() const {return this->java;};
    // 设置游戏 java
    void setJava(const QuickMCL::utils::Java* java);
    // 获取 java 路径
    const QString getJavaPath() const;

    // 是否版本隔离
    const bool isSeperate() const {return this->seperate;};
    // 设置是否版本隔离
    void setSeperate(bool isSeperate);

    // 获取最小内存
    const int getMinimumMemory() const {return this->minimumMemory;};
    // 设置最小内存
    void setMinimumMemory(int minimumMemory);

    // 获取最大内存
    const int getMaximumMemory() const {return this->maximumMemory;};
    // 设置最大内存
    void setMaximumMemory(int maximumMemory);

    // 获取 jvm 参数
    const QStringList getJvmParameters() const {return this->jvmParameters;};
    // 设置 jvm 参数
    void setJvmParameters(const QStringList& parameters);
    // 添加 jvm 参数
    void addJvmParameter(const QString& parameter);

    // 获取启动功能模式
    const QStringList getFeatures() const {return this->features;};
    // 设置启动功能模式
    void setFeatures(const QStringList& features);
    // 添加启动功能模式
    void addFeature(const QString& feature);

    // 获取分辨率宽度
    const int getResolutionWidth() const {return this->resolutionWidth;};
    // 设置分辨率宽度
    void setResolutionWidth(int width);

    // 获取分辨率高度
    const int getResolutionHeight() const {return this->resolutionHeight;};
    // 设置分辨率高度
    void setResolutionHeight(int height);

    // 获取自动登录服务器
    const QString getServer() const {return this->server;};
    // 设置自动登录服务器
    void setServer(const QString& server);

    // 获取自动登录端口
    const int getPort() const {return this->port;};
    // 设置自动登录端口
    void setPort(int port);

    // 获取快速游戏单人存档名称
    const QString getQuickPlaySinglePlayer() const {return this->quickPlaySinglePlayer;};
    // 设置快速游戏单人存档名称
    void setQuickPlaySinglePlayer(const QString& name);

    // 获取快速游戏多人模式服务器
    const QString getQuickPlayMultiPlayer() const {return this->quickPlayMultiPlayer;};
    // 设置快速游戏多人模式服务器
    void setQuickPlayMultiPlayer(const QString& name);

    // 获取快速游戏多人模式 realms
    const int getQuickPlayRealms() const {return this->quickPlayRealms;};
    // 设置快速游戏多人模式 realms
    void setQuickPlayRealms(int realms);


    // 从 jsonObject 读取游戏配置
    void readConfigFromObject(const QJsonObject& object);
    // 获取配置文件的 jsonObject
    const QJsonObject getConfigObject() const;

    // 获取配置 json 路径
    const QString getConfigJsonFile() const;

    // 获取版本名称
    const QString getVersionName() const;
    // 获取游戏目录
    const QString getGameDirectory() const;
    // 获取资源目录
    const QString getAssetsRoot() const;
    // 获取资源索引
    const QString getAssetsIndexName() const;
    // 获取 native 库目录
    const QString getNativesDirectory() const;
    // 获取 libraries 目录
    const QString getLibrariesDirectory() const;
    // 获取游戏的 jar 文件
    const QString getGameJar() const;
    // 获取建议的 java 版本
    const int getJavaVersion() const;

    // 从 jsonArray 读取已知游戏
    static void readGamesFromArray(const QJsonArray& array);
    // 获取 gameList 指针
    static QMap<QString, Game*>* const getGameListPtr();
    // 获取 globalConfig 指针
    static Game* const getGlobalGameConfigPtr();
};
typedef QMap<QString, Game*> gameMap;
}

#endif // GAME_H
