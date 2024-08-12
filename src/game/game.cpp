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

#include <QString>
#include <QStringList>
#include <QJsonArray>
#include <QJsonObject>
#include "game.h"
#include "../config.h"
#include "../utils/json_parser.h"

namespace QuickMCL::game {
Q_GLOBAL_STATIC(Game, globalGameConfig)
Q_GLOBAL_STATIC(gameMap, gameList)

// java 库位置
const char* libraryDir = "libraries/";
// 资源文件目录
const char* assetsRoot = "assets/";
// 用户类型
const char* userType = "msa";
// 版本类型
const char* versionType = "QuickMCL";
// 最小内存大小，单位 MB
const int minimumMemory = 256;
// log4j2 配置文件位置
const char* log4j2Name = "log4j2.xml";
// 快速游戏日志文件路径
const char* quickPlayPath = "quickplaylog.json";
}

// 默认构造函数
QuickMCL::game::Game::Game(){

}

// 根据游戏名称新建配置，并从 globalGameConfig 复制配置
QuickMCL::game::Game::Game(const QString& name){
    setName(name);
    setJavaPath(globalGameConfig->getJavaPath());
    setSeperate(globalGameConfig->isSeperate());
    setMinimumMemory(globalGameConfig->getMinimumMemory());
    setMaximumMemory(globalGameConfig->getMaximumMemory());
    setJvmParameters(globalGameConfig->getJvmParameters());
    setFeatures(globalGameConfig->getFeatures());
    setResolutionWidth(globalGameConfig->getResolutionWidth());
    setResolutionHeight(globalGameConfig->getResolutionHeight());
    setServer(globalGameConfig->getServer());
    setPort(globalGameConfig->getPort());
    setQuickPlaySinglePlayer(globalGameConfig->getQuickPlaySinglePlayer());
    setQuickPlayMultiPlayer(globalGameConfig->getQuickPlayMultiPlayer());
    setQuickPlayRealms(globalGameConfig->getQuickPlayRealms());
}

// 设置游戏名称
void QuickMCL::game::Game::setName(const QString& name){
    this->name = name;
}

// 获取游戏 java
const QuickMCL::utils::Java* QuickMCL::game::Game::getJava() const {
    return utils::Java::getJavaPtrByPath(getJavaPath());
}

// 设置游戏 java
void QuickMCL::game::Game::setJava(const QuickMCL::utils::Java* java){
    if (java == nullptr){
        this->javaPath = "";
    } else {
        this->javaPath = java->getPath();
    }
    if (!(this == globalGameConfig)){
        writeGameConfig();
    }
}

// 设置 java 路径
void QuickMCL::game::Game::setJavaPath(const QString& path){
    this->javaPath = path;
}

// 设置是否版本隔离
void QuickMCL::game::Game::setSeperate(bool isSeperate){
    this->seperate = isSeperate;
}

// 设置最小内存
void QuickMCL::game::Game::setMinimumMemory(int minimumMemory){
    this->minimumMemory = minimumMemory;
}

// 设置最大内存
void QuickMCL::game::Game::setMaximumMemory(int maximumMemory){
    this->maximumMemory = maximumMemory;
}

// 设置 jvm 参数
void QuickMCL::game::Game::setJvmParameters(const QStringList& parameters){
    this->jvmParameters = parameters;
}

// 添加 jvm 参数
void QuickMCL::game::Game::addJvmParameter(const QString& parameter){
    this->jvmParameters.append(parameter);
}

// 设置启动功能模式
void QuickMCL::game::Game::setFeatures(const QStringList& features){
    this->features = features;
}

// 添加启动功能模式
void QuickMCL::game::Game::addFeature(const QString& feature){
    if (!this->features.contains(feature)){
        this->features.append(feature);
    }
}

// 设置分辨率宽度
void QuickMCL::game::Game::setResolutionWidth(int width){
    this->resolutionWidth = width;
}

// 设置分辨率高度
void QuickMCL::game::Game::setResolutionHeight(int height){
    this->resolutionHeight = height;
}

// 设置自动登录服务器
void QuickMCL::game::Game::setServer(const QString& server){
    this->server = server;
}

// 设置自动登录端口
void QuickMCL::game::Game::setPort(int port){
    this->port = port;
}

// 设置快速游戏单人存档名称
void QuickMCL::game::Game::setQuickPlaySinglePlayer(const QString& name){
    this->quickPlaySinglePlayer = name;
}

// 设置快速游戏多人模式服务器
void QuickMCL::game::Game::setQuickPlayMultiPlayer(const QString& name){
    this->quickPlayMultiPlayer = name;
}

// 设置快速游戏多人模式 realms
void QuickMCL::game::Game::setQuickPlayRealms(int realms){
    this->quickPlayRealms = realms;
}

// 从 jsonObject 读取游戏配置
void QuickMCL::game::Game::readConfigFromObject(const QJsonObject& object){
    setJavaPath(object.value("java").toString());
    setSeperate(object.value("isSeperate").toBool());
    setMinimumMemory(object.value("minimumMemory").toInt());
    setMaximumMemory(object.value("maximumMemory").toInt());
    QStringList jvmParameters;
    QJsonArray jvmParametersArray = object.value("jvmParameters").toArray();
    for (const QJsonValue& jvmParameter : jvmParametersArray){
        jvmParameters.append(jvmParameter.toString());
    }
    setJvmParameters(jvmParameters);
    QStringList features;
    QJsonArray featuresArray = object.value("features").toArray();
    for (const QJsonValue& feature : featuresArray){
        features.append(feature.toString());
    }
    setFeatures(features);
    setResolutionWidth(object.value("resolutionWidth").toInt());
    setResolutionHeight(object.value("resolutionHeight").toInt());
    setServer(object.value("server").toString());
    setPort(object.value("port").toInt());
    setQuickPlayMultiPlayer(object.value("quickPlayMultiPlayer").toString());
    setQuickPlaySinglePlayer(object.value("quickPlaySinglePlayer").toString());
    setQuickPlayRealms(object.value("quickPlayRealms").toInt());
}

// 获取配置文件的 jsonObject
const QJsonObject QuickMCL::game::Game::getConfigObject() const {
    QJsonObject configObject;
    configObject.insert("name", this->name);
    configObject.insert("java", this->javaPath);
    configObject.insert("isSeperate", this->seperate);
    configObject.insert("minimumMemory", this->minimumMemory);
    configObject.insert("maximumMemory", this->maximumMemory);
    QJsonArray jvmParameters;
    for (const QString& jvmParameter : this->jvmParameters){
        jvmParameters.append(jvmParameter);
    }
    configObject.insert("jvmParameters", jvmParameters);
    QJsonArray features;
    for (const QString& feature : this->features){
        features.append(feature);
    }
    configObject.insert("features", features);
    configObject.insert("resolutionWidth", this->resolutionWidth);
    configObject.insert("resolutionHeight", this->resolutionHeight);
    configObject.insert("server", this->server);
    configObject.insert("port", this->port);
    configObject.insert("quickPlayMultiPlayer", this->quickPlayMultiPlayer);
    configObject.insert("quickPlaySinglePlayer", this->quickPlaySinglePlayer);
    configObject.insert("quickPlayRealms", this->quickPlayRealms);
    return configObject;
}

// 获取配置 json 路径
const QString QuickMCL::game::Game::getConfigJsonFile() const {
    return QDir::toNativeSeparators(getGameDirectory() + this->name + ".json");
}

// 获取版本名称
const QString QuickMCL::game::Game::getVersionName() const {
    return QuickMCL::utils::JsonPraser::readObjectFromFile(getConfigJsonFile()).value("id").toString();
}

// 获取游戏目录
const QString QuickMCL::game::Game::getGameDirectory() const {
    const QuickMCL::config::Config* const globalConfig = QuickMCL::config::Config::getGlobalConfigPtr();
    if(isSeperate()){
        return QDir::toNativeSeparators(globalConfig->getActuralGameDir() + "versions/" + this->name + "/");
    } else {
        return QDir::toNativeSeparators(globalConfig->getActuralGameDir());
    }
}

// 获取资源目录
const QString QuickMCL::game::Game::getAssetsRoot() const {
    const QuickMCL::config::Config* const globalConfig = QuickMCL::config::Config::getGlobalConfigPtr();
    return QDir::toNativeSeparators(globalConfig->getActuralGameDir() + QuickMCL::game::assetsRoot);
}

// 获取资源索引
const QString QuickMCL::game::Game::getAssetsIndexName() const {
    return QuickMCL::utils::JsonPraser::readObjectFromFile(getConfigJsonFile()).value("assets").toString();
}

// 获取 native 库目录
const QString QuickMCL::game::Game::getNativesDirectory() const {
    const QuickMCL::config::Config* const globalConfig = QuickMCL::config::Config::getGlobalConfigPtr();
    return QDir::toNativeSeparators(getGameDirectory() + "natives-" + globalConfig->getSystemNameInMinecraft() + "-" + globalConfig->getArchInMinecraft());
}

// 获取 libraries 目录
const QString QuickMCL::game::Game::getLibrariesDirectory() const {
    const QuickMCL::config::Config* const globalConfig = QuickMCL::config::Config::getGlobalConfigPtr();
    return QDir::toNativeSeparators(globalConfig->getActuralGameDir() + QuickMCL::game::libraryDir);
}

// 获取游戏的 jar 文件
const QString QuickMCL::game::Game::getGameJar() const {
    return QDir::toNativeSeparators(getGameDirectory() + getName() + ".jar");
}

// 获取建议的 java 版本
const int QuickMCL::game::Game::getJavaVersion() const {
    QJsonObject configObject =  QuickMCL::utils::JsonPraser::readObjectFromFile(getConfigJsonFile());
    if (configObject.contains("javaVersion")){
        return configObject.value("javaVersion").toObject().value("majorVersion").toInt();
    } else {
        return 8;
    }
}

// 从 array 读取已知游戏
void QuickMCL::game::Game::readGamesFromArray(const QJsonArray& array){
    qDebug() << "[QuickMCL::game::Game::readGamesFromArray] 开始读取游戏：";
    for (const QJsonValue& object : array){
        const QJsonObject gameObject = object.toObject();
        qDebug() << "[QuickMCL::game::Game::readGamesFromArray] object: " << object;
        const QString gameName = gameObject.value("name").toString();
        bool success;
        if (gameObject.value("isSeperate").toBool()){
            success = registerGameByPath(config::Config::getGlobalConfigPtr()->getActuralGameDir() + "versions/" + gameName + '/' + gameName + ".jar");
        } else {
            success = registerGameByPath(config::Config::getGlobalConfigPtr()->getActuralGameDir() + gameName + ".jar", false);
        }
        if (success){
            qDebug() << "[QuickMCL::game::Game::readGamesFromArray] 成功注册游戏，开始读取配置";
            Game* const game = gameList->find(gameName).value();
            game->readConfigFromObject(gameObject);
        } else {
            qDebug() << "[QuickMCL::game::Game::readGamesFromArray] 注册游戏失败，跳过读取配置";
        }
    }
}

// 扫描游戏
void QuickMCL::game::Game::scanGame(const QString& path){
    qDebug() << "[QuickMCL::game::Game::scanGame] 开始扫描游戏：";
    QString gameDir;
    if (path == ""){
        gameDir = config::Config::getGlobalConfigPtr()->getActuralGameDir();
    } else {
        gameDir = path;
    }
    qDebug() << "[QuickMCL::game::Game::scanGame] gameDir: " << gameDir;
    {
        qDebug() << "[QuickMCL::game::Game::scanGame] 扫描隔离版本隔离游戏：";
        const QFileInfoList list = QDir(gameDir + '/' + "versions").entryInfoList(QDir::AllDirs | QDir::NoDotAndDotDot);
        qDebug() << "[QuickMCL::game::Game::scanGame] list: " << list;
        for (const QFileInfo& game : list){
            QString gameName = game.fileName();
            if (QFileInfo(game.absoluteFilePath() + '/' + gameName + ".jar").isFile() &&
                QFileInfo(game.absoluteFilePath() + '/' + gameName + ".json").isFile()){
                qDebug() << "[QuickMCL::game::Game::scanGame] 发现游戏：";
                qDebug() << "[QuickMCL::game::Game::scanGame] path: " << game.absoluteFilePath() + '/' + game.fileName() + ".jar";
                registerGameByPath(game.absoluteFilePath() + '/' + game.fileName() + ".jar");
            }
        }
    }
    {
        qDebug() << "[QuickMCL::game::Game::scanGame] 扫描非隔离版本隔离游戏：";
        const QFileInfoList list = QDir(gameDir).entryInfoList({"*.jar"}, QDir::Files);
        for (const QFileInfo& game : list){
            if (QFileInfo(game.absolutePath() + '/' + game.completeBaseName() + ".json").isFile()){
                qDebug() << "[QuickMCL::game::Game::scanGame] 发现游戏：";
                qDebug() << "[QuickMCL::game::Game::scanGame] path: " << game.absoluteFilePath();
                registerGameByPath(game.absoluteFilePath(), false);
            }
        }
    }
    qDebug() << "[QuickMCL::game::Game::scanGame] 扫描完成，更新配置文件";
    writeGameConfig();
}

// 用路径注册游戏
const bool QuickMCL::game::Game::registerGameByPath(const QString& path, const bool isSeperate){
    qDebug() << "[QuickMCL::game::Game::registerGameByPath] 注册游戏：";
    qDebug() << "[QuickMCL::game::Game::registerGameByPath] path: " << path;
    qDebug() << "[QuickMCL::game::Game::registerGameByPath] isSeperate: " << isSeperate;
    const QFileInfo game(path);
    if (game.isFile() &&
        QFileInfo(game.absolutePath() + '/' + game.completeBaseName() + ".json").isFile()){
        qDebug() << "[QuickMCL::game::Game::registerGameByPath] 路径合法，正在注册";
        // **以后可能会有多游戏路径需求，暂时只判断不包含，或包含但是版本隔离不同
        // **现在还不能判断包含但是版本隔离不同，其他部分代码没法区分同样名称的不同版本
        if (!gameList->contains(game.completeBaseName())/* || isSeperate != gameList->find(game.completeBaseName()).value()->isSeperate()*/){
            Game* ptr = new Game(game.completeBaseName());
            gameList->insert(game.completeBaseName(), ptr);
            if (!isSeperate){
                ptr->setSeperate(false);
            }
            return true;
        }
        qDebug() << "[QuickMCL::game::Game::registerGameByPath] 注册失败，游戏已存在";
        return false;
    }
    qDebug() << "[QuickMCL::game::Game::registerGameByPath] 注册失败，路径不合法：";
    qDebug() << "[QuickMCL::game::Game::registerGameByPath] game is file: " << game.isFile();
    qDebug() << "[QuickMCL::game::Game::registerGameByPath] " << game.absolutePath() + '/' + game.completeBaseName() + ".json" << " is file: " << QFileInfo(game.absolutePath() + '/' + game.completeBaseName() + ".json").isFile();
    return false;
}

// 读取全部游戏配置
void QuickMCL::game::Game::readGameConfig(){
    readGamesFromArray(utils::JsonPraser::readArrayFromFile(QuickMCL::config::Config::getGlobalConfigPtr()->getActuralConfigDir() + config::gameListFile));
}

// 写入全部游戏配置
void QuickMCL::game::Game::writeGameConfig(){
    QJsonArray gameConfigArray;
    gameMap gameList = *getGameListPtr();
    for (Game* game : gameList){
        gameConfigArray.append(game->getConfigObject());
    }
    utils::JsonPraser::writeArrayToFile(gameConfigArray, QuickMCL::config::Config::getGlobalConfigPtr()->getActuralConfigDir() + config::gameListFile);
}

// 获取 gameList 指针
QuickMCL::game::gameMap* const QuickMCL::game::Game::getGameListPtr(){
    return gameList;
}

// 获取 globalGameConfig 指针
QuickMCL::game::Game* const QuickMCL::game::Game::getGlobalGameConfigPtr(){
    return globalGameConfig;
}
