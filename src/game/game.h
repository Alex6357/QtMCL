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
 * 游戏类，存储游戏名称以及游戏配置类指针，同时定义游戏列表，应该考虑与 game_config 合并
 */

#ifndef GAME_H
#define GAME_H

#include <QObject>
#include <QString>
#include <QStringList>
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
    Game();
    Game(const QString& name);

    const QString getName() const {return this->name;};
    void setName(const QString& name);

    const QuickMCL::utils::Java* getJava() const {return this->java;};
    void setJava(const QuickMCL::utils::Java* java);
    const QString getJavaPath() const;

    const bool isSeperate() const {return this->seperate;};
    void setSeperate(bool isSeperate);

    const int getMinimumMemory() const {return this->minimumMemory;};
    void setMinimumMemory(int minimumMemory);

    const int getMaximumMemory() const {return this->maximumMemory;};
    void setMaximumMemory(int maximumMemory);

    const QStringList getJvmParameters() const {return this->jvmParameters;};
    void setJvmParameters(const QStringList& parameters);
    void addJvmParameter(const QString& parameter);

    const QStringList getFeatures() const {return this->features;};
    void setFeatures(const QStringList& features);
    void addFeature(const QString& feature);

    const int getResolutionWidth() const {return this->resolutionWidth;};
    void setResolutionWidth(int width);

    const int getResolutionHeight() const {return this->resolutionHeight;};
    void setResolutionHeight(int height);

    const QString getServer() const {return this->server;};
    void setServer(const QString& server);

    const int getPort() const {return this->port;};
    void setPort(int port);

    const QString getQuickPlaySinglePlayer() const {return this->quickPlaySinglePlayer;};
    void setQuickPlaySinglePlayer(const QString& name);

    const QString getQuickPlayMultiPlayer() const {return this->quickPlayMultiPlayer;};
    void setQuickPlayMultiPlayer(const QString& name);

    const int getQuickPlayRealms() const {return this->quickPlayRealms;};
    void setQuickPlayRealms(int realms);


    void readConfigFromObject(const QJsonObject& object);
    const QString getConfigJsonFile() const;

    const QString getVersionName() const;
    const QString getGameDirectory() const;
    const QString getAssetsRoot() const;
    const QString getAssetsIndexName() const;
    const QString getNativesDirectory() const;
    const QString getLibrariesDirectory() const;
    const QString getGameJar() const;
    const int getJavaVersion() const;

    static void readGamesFromArray(const QJsonArray& array);
    static QMap<QString, Game*>* const getGameListPtr();
};
typedef QMap<QString, Game*> gameMap;
}

#endif // GAME_H
