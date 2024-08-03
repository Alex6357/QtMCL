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

#include <QSysInfo>
#include <QString>
#include <QStringList>
#include <QDir>
#include <QFileInfo>
#include <QJsonObject>
#include <QGlobalStatic>
#include "game/game.h"
#include "utils/json_parser.h"
#include "utils/utils.h"
#include "config.h"
// #include "version.h"

namespace QuickMCL::config {
// 已知用户列表
Q_GLOBAL_STATIC(QStringList, userList)
Q_GLOBAL_STATIC(Config, globalConfig)
}

// 默认构造函数
QuickMCL::config::Config::Config(QObject *parent){
    // 获取系统类型和架构
    this->arch = QuickMCL::utils::getArch();
    this->system = QuickMCL::utils::getSystemType();
    // 设置系统名称和版本
    this->systemName = QuickMCL::utils::getSystemName();
    this->systemVersion = QuickMCL::utils::getSystemVersion();
    // 自动读取配置文件
    readConfig();
}

// 默认析构函数
QuickMCL::config::Config::~Config(){

}

// 获取 globalConfig 指针
QuickMCL::config::Config* const QuickMCL::config::Config::getGlobalConfigPtr(){
    return QuickMCL::config::globalConfig;
}

// 获取用户列表的副本
const QStringList QuickMCL::config::Config::getUserListCopy(){
    return QStringList::fromList(*QuickMCL::config::userList);
}

// 将用户添加到用户列表
void QuickMCL::config::Config::addToUserList(const QString user){
    QuickMCL::config::userList->append(user);
    qDebug() << "[QuickMCL::config::Config] 添加用户";
    qDebug() << "[QuickMCL::config::Config] 当前用户列表：" << *QuickMCL::config::userList;
}

// 获取用户列表指针
QStringList* const QuickMCL::config::Config::getUserListPtr(){
    return QuickMCL::config::userList;
}

// 设置配置文件位置
void QuickMCL::config::Config::setConfigDirPlace(const enum QuickMCL::config::configDirPlace configDirPlace){
    this->configDirPlace = configDirPlace;
}

// 设置游戏位置
void QuickMCL::config::Config::setGameDirPlace(const enum QuickMCL::config::gameDirPlace gameDirPlace){
    this->gameDirPlace = gameDirPlace;
}

// 设置架构
void QuickMCL::config::Config::setArch(const enum arch arch){
    this->arch = arch;
}

// 设置系统类型
void QuickMCL::config::Config::setSystem(const enum system system){
    this->system = system;
}

// 设置系统名称
void QuickMCL::config::Config::setSystemName(const QString systemName){
    this->systemName = systemName;
}

// 设置系统版本
void QuickMCL::config::Config::setSystemVersion(const QString systemVersion){
    this->systemVersion = systemVersion;
}

// 设置配置文件路径
void QuickMCL::config::Config::setConfigDir(const QString configDir){
    this->configDir = configDir;
}

// 设置游戏路径
void QuickMCL::config::Config::setGameDir(const QString gameDir){
    this->gameDir = gameDir;
}

// 设置临时文件路径
void QuickMCL::config::Config::setTempDir(const QString tempDir){
    this->tempDir = tempDir;
}

// 自动寻找并读取配置文件
void QuickMCL::config::Config::readConfig(){
    // 检查并读取本地配置文件
    if(QFileInfo(getConfigDirName()).isDir() && QFileInfo(getConfigDirName() + QuickMCL::config::configFile).isFile()){
        readConfigFromFile(getConfigDirName() + QuickMCL::config::configFile);
        return;
        // 检查并读取全局配置文件
    } else {
        if(QFileInfo(getGlobalConfigDir()).isDir() && QFileInfo(configDir + QuickMCL::config::configFile).isFile()){
            this->configDirPlace = QuickMCL::config::configDirPlace::globalConfigDir;
            readConfigFromFile(configDir + QuickMCL::config::configFile);
            return;
        }
    }
    // **先没有考虑其他情况，直接进行
    // 判断并新建配置文件夹和文件
    if(!QFileInfo::exists(getGlobalConfigDir())){
        QDir().mkdir(getGlobalConfigDir());
    } else if (!QFileInfo(getGlobalConfigDir()).isDir()){
        // **err
        return;
    } else {
        // **不能读写
    }
    QuickMCL::utils::makeFile(getGlobalConfigDir() + configFile);
}

// 从配置文件读取配置
void QuickMCL::config::Config::readConfigFromFile(const QString& file){
    const QJsonObject configObject = utils::JsonPraser::readObjectFromFile(file);
    // QuickMCL::game::Game::readGamesFromArray(configObject.value("games").toArray());
    setGameDirPlace((config::gameDirPlace)configObject.value("gameDirPlace").toInt());
    setConfigDir(configObject.value("configDir").toString());
    setGameDir(configObject.value("gameDir").toString());
    setTempDir(configObject.value("tempDir").toString());
    game::Game::getGlobalGameConfigPtr()->readConfigFromObject(configObject.value("globalGameConfig").toObject());
    readUserListFromArray(configObject.value("users").toArray());
}

// 向配置文件写入配置
void QuickMCL::config::Config::writeConfigToFile(){
    QJsonObject configObject;
    // **需要做多系统适配
    configObject.insert("gameDirPlace", this->gameDirPlace);
    configObject.insert("configDir", this->configDir);
    configObject.insert("gameDir", this->gameDir);
    configObject.insert("tempDir", this->tempDir);
    configObject.insert("globalGameConfig", QuickMCL::game::Game::getGlobalGameConfigPtr()->getConfigObject());
    QJsonArray users;
    for (const QString& user : *userList){
        users.append(user);
    }
    configObject.insert("users", users);
    QuickMCL::utils::JsonPraser::writeObjectToFile(configObject, getActuralConfigDir() + configFile);
}

// 从 json array 读取用户列表
void QuickMCL::config::Config::readUserListFromArray(const QJsonArray& array){
    QJsonArray::ConstIterator iterator = array.constBegin();
    QJsonArray::ConstIterator end = array.constEnd();
    for(; iterator != end; iterator++){
        QuickMCL::config::userList->append(iterator->toString());
    }
}

// 获取配置目录名称
const QString QuickMCL::config::Config::getConfigDirName() const {
    if(this->system == QuickMCL::config::system::windows){
        return QuickMCL::config::windowsConfigDir;
    } else {
        return QuickMCL::config::configDir;
    }
}

// 获取全局配置目录
const QString QuickMCL::config::Config::getGlobalConfigDir() const {
    if (this->system == QuickMCL::config::windows){
        // Windows 保存在 Roaming
        return QDir::toNativeSeparators(QDir(QDir::homePath() + "/" + "AppData/" + "Roaming/" + QuickMCL::config::windowsConfigDir).absolutePath());
    } else {
        // 其余保存在 home
        return QDir::toNativeSeparators(QDir(QDir::homePath() + "/" + QuickMCL::config::configDir).absolutePath());
    }
}

// 获取全局游戏目录
const QString QuickMCL::config::Config::getGlobalGameDir() const {
    if (this->system == QuickMCL::config::system::windows){
        return QDir(QDir::homePath() + "/" + "AppData/" + "Roaming/" + QuickMCL::config::gameDir).absolutePath() + '/';
    } else {
        return QDir(QDir::homePath() + "/" + QuickMCL::config::gameDir).absolutePath() + '/';
    }
}

// 获取实际的配置文件目录
const QString QuickMCL::config::Config::getActuralConfigDir() const {
    if (this->configDirPlace == QuickMCL::config::configDirPlace::localConfigDir){
        return QDir(getConfigDirName()).absolutePath() + '/';
    } else {
        return getGlobalConfigDir();
    }
}

// 获取实际的游戏目录
const QString QuickMCL::config::Config::getActuralGameDir() const {
    if (this->gameDirPlace == QuickMCL::config::gameDirPlace::localGameDir){
        return QDir(QuickMCL::config::gameDir).absolutePath() + '/';
    } else if (this->gameDirPlace == QuickMCL::config::gameDirPlace::customGameDir){
        return this->gameDir + '/';
    } else {
        return getGlobalGameDir();
    }
}

// 获取版本 json 文件中架构的写法
const QString QuickMCL::config::Config::getArchInMinecraft() const {
    switch (this->arch){
    case QuickMCL::config::arch::amd64: {
        return QString("amd64");
    }
    case QuickMCL::config::arch::x86: {
        return QString("x86");
    }
    case QuickMCL::config::arch::arm64: {
        return QString("arm64");
    }
    default: {
        return QString("unknown");
    }
    }
}

// 获取版本 json 文件中系统名称的写法
const QString QuickMCL::config::Config::getSystemNameInMinecraft() const {
    switch (this->system){
    case QuickMCL::config::system::windows: {
        return QString("windows");
    }
    case QuickMCL::config::system::linux: {
        return QString("linux");
        break;
    }
    case QuickMCL::config::system::macos: {
        return QString("osx");
        break;
    }
    case QuickMCL::config::system::freebsd: {
        return QString("freebsd");
        break;
    }
    default: {
        return QString("unknown");
    }
    }
}
