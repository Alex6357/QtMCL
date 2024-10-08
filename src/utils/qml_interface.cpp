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
 * Qml界面类，负责与 Qml 交互
 */

#include <QtTypes>
#include <QString>
#include <QStringList>
#include <QVariantList>
#include <QDebug>
#include "qml_interface.h"
#include "../game/launcher.h"
#include "../game/game.h"
#include "../config.h"
#include "java.h"
#include "utils.h"

namespace QuickMCL::utils{
// QmlInterface 维护的 java 列表，会在每次请求 java 列表时更新
Q_GLOBAL_STATIC(QStringList, javaNameList)
}

// 默认构造函数
QuickMCL::utils::QmlInterface::QmlInterface(QObject *parent)
    : QObject{parent}
{}

// 初始化当前游戏名称
QString QuickMCL::utils::QmlInterface::currentGame = "";

// 启动游戏
const qint64 QuickMCL::utils::QmlInterface::launchGame(const QString& name, const QString& playerName, const int type){
    return QuickMCL::game::Launcher::launch(name, playerName, type);
}

// 获取现在的游戏名称
const QString QuickMCL::utils::QmlInterface::getCurrentGame() {
    return QuickMCL::utils::QmlInterface::currentGame;
}

// 设置现在的游戏名称
void QuickMCL::utils::QmlInterface::setCurrentGame(const QString& gameName){
    QuickMCL::utils::QmlInterface::currentGame = gameName;
}

// 获取 userList
const QStringList QuickMCL::utils::QmlInterface::getUserList(){
    return QuickMCL::config::Config::getUserListCopy();
}

// 获取 gameList
const QStringList QuickMCL::utils::QmlInterface::getGameList(){
    return QStringList::fromList(QuickMCL::game::Game::getGameListPtr()->keys());
}

// 向 userList 中添加用户
void QuickMCL::utils::QmlInterface::addUserToList(const QString& user){
    QuickMCL::config::Config::getUserListPtr()->append(user);
    QuickMCL::config::Config::getGlobalConfigPtr()->writeConfigToFile();
}

// 获取 javaList
const QStringList QuickMCL::utils::QmlInterface::getJavaList(const QString& game){
    QString java;
    if (game == ""){
        java = game::Game::getGlobalGameConfigPtr()->getJavaPath();
    } else {
        java = game::Game::getGameListPtr()->value(game)->getJavaPath();
    }
    QStringList list;
    // 正在扫描的话先不允许获取目录
    if (Java::isScanning()){
        list.append(tr("正在扫描 Java，请稍候"));
        return list;
    }
    // 没有找到已经设置的 java 就加一个提示
    if (java != "" && !Java::getJavaListPtr()->contains(java)){
        list.append(tr("未找到设置的 Java：") + java + tr(" 可能已经被移走或删除。"));
    }
    *javaNameList = Java::getJavaListPtr()->keys();
    list.append(tr("自动选择合适的 Java"));
    for (const QString& java : *javaNameList){
        QString name;
        if (Java::getJavaPtrByPath(java)->isJdk()){
            name.append("JDK ");
        } else {
            name.append("JRE ");
        }
        name.append(QString::number(Java::getJavaPtrByPath(java)->getVersion()));
        name.append(" (").append(Java::getJavaPtrByPath(java)->getName());
        name.append(") at ").append(Java::getJavaPtrByPath(java)->getPath());
        list.append(name);
    }
    return list;
}

// 用路径获取指定游戏的 java 的 index
const int QuickMCL::utils::QmlInterface::getJavaIndex(const QString& name){
    if (Java::isScanning()){
        return 0;
    }
    QString java;
    if (name == ""){
        java = game::Game::getGlobalGameConfigPtr()->getJavaPath();
    } else {
        java = game::Game::getGameListPtr()->value(name)->getJavaPath();
    }
    if (java == nullptr){
        return 0;
    } else {
        return javaNameList->indexOf(java) + 1;
    }
    return 0;
}

// 设置 java
void QuickMCL::utils::QmlInterface::setJava(const QString& text, const QString& gameName){
    if (text == tr("正在扫描 Java，请稍候")){
        return;
    } // **好像不需要这部分，如果只有一项触发不了 ComboBox 的 onAccepted
    QString java = "";
    if (text.endsWith("java.exe")){
        java = text.last(text.size() - text.indexOf("at") - 3);
    }
    game::Game* game;
    if (gameName == ""){
        game = game::Game::getGlobalGameConfigPtr();
    } else {
        game = game::Game::getGameListPtr()->value(gameName);
    }
    game->setJavaPath(java);
    if (gameName == ""){
        config::Config::getGlobalConfigPtr()->writeConfigToFile();
    } else {
        game::Game::writeGameConfig();
    }
}

// 获取版本隔离
const bool QuickMCL::utils::QmlInterface::getSeperate(const QString& gameName){
    const game::Game* game;
    if (gameName == ""){
        game = game::Game::getGlobalGameConfigPtr();
    } else {
        game = game::Game::getGameListPtr()->value(gameName);
    }
    return game->isSeperate();
}

// 设置版本隔离
void QuickMCL::utils::QmlInterface::setSeperate(const bool seperate, const QString& gameName){
    game::Game* game;
    if (gameName == ""){
        game = game::Game::getGlobalGameConfigPtr();
    } else {
        game = game::Game::getGameListPtr()->value(gameName);
    }
    game->setSeperate(seperate);
    if (gameName == ""){
        config::Config::getGlobalConfigPtr()->writeConfigToFile();
    } else {
        game::Game::writeGameConfig();
    }
}

// 获取内存大小
const unsigned int QuickMCL::utils::QmlInterface::getMemory(const QString& gameName){
    game::Game* game;
    if (gameName == ""){
        game = game::Game::getGlobalGameConfigPtr();
    } else {
        game = game::Game::getGameListPtr()->value(gameName);
    }
    return game->getMaximumMemory();
}

// 设置内存大小
void QuickMCL::utils::QmlInterface::setMemory(const unsigned int memoryMiB, const QString& gameName){
    game::Game* game;
    if (gameName == ""){
        game = game::Game::getGlobalGameConfigPtr();
    } else {
        game = game::Game::getGameListPtr()->value(gameName);
    }
    game->setMaximumMemory(memoryMiB);
    if (gameName == ""){
        config::Config::getGlobalConfigPtr()->writeConfigToFile();
    } else {
        game::Game::writeGameConfig();
    }
}

// 获取是否自定义窗口大小
const bool QuickMCL::utils::QmlInterface::hasResolutionFeature(const QString& gameName){
    game::Game* game;
    if (gameName == ""){
        game = game::Game::getGlobalGameConfigPtr();
    } else {
        game = game::Game::getGameListPtr()->value(gameName);
    }
    return game->getFeatures().contains("has_custom_resolution");
}

// 获取自定义窗口大小
const QVariantList QuickMCL::utils::QmlInterface::getResolution(const QString& gameName){
    game::Game* game;
    if (gameName == ""){
        game = game::Game::getGlobalGameConfigPtr();
    } else {
        game = game::Game::getGameListPtr()->value(gameName);
    }
    QVariantList resolution;
    resolution.append(game->getResolutionWidth());
    resolution.append(game->getResolutionHeight());
    return resolution;
}

// 设置自定义窗口大小
void QuickMCL::utils::QmlInterface::setResolution(const int width, const int height, const QString& gameName){
    game::Game* game;
    if (gameName == ""){
        game = game::Game::getGlobalGameConfigPtr();
    } else {
        game = game::Game::getGameListPtr()->value(gameName);
    }
    if (width == -1 || height == -1){
        game->deleteFeature("has_custom_resolution");
    } else {
        game->addFeature("has_custom_resolution");
    }
    if (gameName == ""){
        config::Config::getGlobalConfigPtr()->writeConfigToFile();
    } else {
        game::Game::writeGameConfig();
    }
}

// 获取 jvm 参数
const QString QuickMCL::utils::QmlInterface::getJvmParameters(const QString& gameName){
    game::Game* game;
    if (gameName == ""){
        game = game::Game::getGlobalGameConfigPtr();
    } else {
        game = game::Game::getGameListPtr()->value(gameName);
    }
    return game->getJvmParameters().join('\n');
}

// 设置 jvm 参数
void QuickMCL::utils::QmlInterface::setJvmParameters(const QString& parameters, const QString& gameName){
    game::Game* game;
    if (gameName == ""){
        game = game::Game::getGlobalGameConfigPtr();
    } else {
        game = game::Game::getGameListPtr()->value(gameName);
    }
    QStringList jvmParameters = parameters.split('\n');
    game->setJvmParameters(jvmParameters);
    if (gameName == ""){
        config::Config::getGlobalConfigPtr()->writeConfigToFile();
    } else {
        game::Game::writeGameConfig();
    }
}

// 获取是否是 demo 模式
const bool QuickMCL::utils::QmlInterface::hasDemoFeature(const QString& gameName){
    game::Game* game;
    if (gameName == ""){
        game = game::Game::getGlobalGameConfigPtr();
    } else {
        game = game::Game::getGameListPtr()->value(gameName);
    }
    return game->getFeatures().contains("is_demo_user");
}

// 设置 demo 模式
void QuickMCL::utils::QmlInterface::setDemo(const bool demo, const QString& gameName){
    game::Game* game;
    if (gameName == ""){
        game = game::Game::getGlobalGameConfigPtr();
    } else {
        game = game::Game::getGameListPtr()->value(gameName);
    }
    if (demo){
        game->addFeature("is_demo_user");
    } else {
        game->deleteFeature("is_demo_user");
    }
    if (gameName == ""){
        config::Config::getGlobalConfigPtr()->writeConfigToFile();
    } else {
        game::Game::writeGameConfig();
    }
}

// 获取是否采用全局基础设置
const bool QuickMCL::utils::QmlInterface::getUseGlobalBasic(const QString& gameName){
    game::Game* game;
    if (gameName == ""){ // **按理说不应该有空的
        game = game::Game::getGlobalGameConfigPtr();
    } else {
        game = game::Game::getGameListPtr()->value(gameName);
    }
    return game->getUseGlobalBasic();
}

// 设置是否采用全局基础设置
void QuickMCL::utils::QmlInterface::setUseGlobalBasic(const bool useGlobalBasic, const QString& gameName){
    game::Game* game;
    if (gameName == ""){
        game = game::Game::getGlobalGameConfigPtr();
    } else {
        game = game::Game::getGameListPtr()->value(gameName);
    }
    game->setUseGlobalBasic(useGlobalBasic);
    if (gameName == ""){
        config::Config::getGlobalConfigPtr()->writeConfigToFile();
    } else {
        game::Game::writeGameConfig();
    }
}

// 获取是否采用全局高级设置
const bool QuickMCL::utils::QmlInterface::getUseGlobalAdvance(const QString& gameName){
    game::Game* game;
    if (gameName == ""){
        game = game::Game::getGlobalGameConfigPtr();
    } else {
        game = game::Game::getGameListPtr()->value(gameName);
    }
    return game->getUseGlobalAdvance();
}

// 设置是否采用全局高级设置
void QuickMCL::utils::QmlInterface::setUseGlobalAdvance(const bool useGlobalAdvance, const QString& gameName){
    game::Game* game;
    if (gameName == ""){
        game = game::Game::getGlobalGameConfigPtr();
    } else {
        game = game::Game::getGameListPtr()->value(gameName);
    }
    game->setUseGlobalAdvance(useGlobalAdvance);
    if (gameName == ""){
        config::Config::getGlobalConfigPtr()->writeConfigToFile();
    } else {
        game::Game::writeGameConfig();
    }
}

// 获取总内存大小
const unsigned int QuickMCL::utils::QmlInterface::getTotalMemoryMiB(){
    return utils::getTotalMemoryMiB();
}
