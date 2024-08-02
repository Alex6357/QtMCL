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
}

// 默认构造函数
QuickMCL::game::Game::Game(){

}

// 根据游戏名称新建配置，并从 globalGameConfig 复制配置
QuickMCL::game::Game::Game(const QString& name){
    setName(name);
    setJava(globalGameConfig->getJava());
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

// 设置游戏 java
void QuickMCL::game::Game::setJava(const QuickMCL::utils::Java* java){
    this->java = java;
}

// 获取 java 路径
const QString QuickMCL::game::Game::getJavaPath() const {
    return this->java->getPath();
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
    this->features.append(feature);
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

// 从 array 读取已知游戏
void QuickMCL::game::Game::readGamesFromArray(const QJsonArray& array){
    QJsonArray::ConstIterator iterator = array.constBegin();
    QJsonArray::ConstIterator end = array.constEnd();
    for(; iterator != end; iterator++){
        QString name = iterator->toObject().value("name").toString();
        gameList()->insert(name, new QuickMCL::game::Game(name));
    }
}

// void readConfigFromObject(const QJsonObject& object){

// }

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

// 获取 gameList 指针
QuickMCL::game::gameMap* const QuickMCL::game::Game::getGameListPtr(){
    return gameList;
}
