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
 * 启动器类，用来启动游戏
 */


#include <QStringList>
#include <QJsonObject>
#include <QJsonArray>
#include <QProcess>
#include <QDebug>
#include "game.h"
#include "launcher.h"
#include "version.h"
#include "../config.h"
#include "../utils/json_parser.h"

// 获取启动命令（Java 路径）
const QString QuickMCL::game::Launcher::getCommand(const QString& name){
    const Game* const game = Game::getGameListPtr()->value(name);
    if (game->getJava() == nullptr){
        return autoGetJava(name);
    } else {
        return Game::getGameListPtr()->value(name)->getJavaPath();
    }
}

// 自动获取适合的 java
const QString QuickMCL::game::Launcher::autoGetJava(const QString& name){
    const QuickMCL::game::Game* const game = Game::getGameListPtr()->value(name);
    QuickMCL::utils::JavaMap javaList = *QuickMCL::utils::Java::getJavaListPtr();
    const int recommendJavaVersion = game->getJavaVersion();
    for (const QuickMCL::utils::Java* const java : javaList){
        if (java->getVersion() == recommendJavaVersion){
            return java->getPath();
        }
    }
    return QString();
}

// 获取启动参数
const QStringList QuickMCL::game::Launcher::getArguments(const QString& name,
                                                         const QString& playerName,
                                                         const QString& uid,
                                                         const QString& token){
    const QuickMCL::game::Game* const game = Game::getGameListPtr()->value(name);
    QStringList arguments;
    arguments.append(QString("-Xms").append(QString::number(game->getMinimumMemory())).append("M"));
    arguments.append(QString("-Xmx").append(QString::number(game->getMaximumMemory())).append("M"));
    arguments.append(game->getJvmParameters());
    arguments.append("-Dminecraft.launcher.brand=QuickMCL");
    arguments.append(QString("-Dminecraft.launcher.version=") + QuickMCL::version);
    arguments.append(getJvmParameters(game));
    arguments.append(getMainClass(game));
    arguments.append(getGameParameters(game));
    arguments.replaceInStrings("${auth_player_name}", playerName);
    arguments.replaceInStrings("${version_name}", game->getVersionName());
    arguments.replaceInStrings("${game_directory}", game->getGameDirectory());
    arguments.replaceInStrings("${assets_root}", game->getAssetsRoot());
    arguments.replaceInStrings("${assets_index_name}", game->getAssetsIndexName());
    arguments.replaceInStrings("${auth_uuid}", uid);
    arguments.replaceInStrings("${auth_access_token}", token);
    // this->arguments.replaceInStrings("${clientid}", game.getClientID());
    // this->arguments.replaceInStrings("${auth_xuid}", game.getAuthXuid());
    arguments.replaceInStrings("${user_type}", QuickMCL::game::userType);
    arguments.replaceInStrings("${version_type}", QuickMCL::game::versionType);
    arguments.replaceInStrings("${resolution_width}", QString::number(game->getResolutionWidth()));
    arguments.replaceInStrings("${resolution_height}", QString::number(game->getResolutionHeight()));
    arguments.replaceInStrings("${quickPlayPath}", QuickMCL::game::quickPlayPath);
    arguments.replaceInStrings("${quickPlaySingleplayer}", game->getQuickPlaySinglePlayer());
    arguments.replaceInStrings("${quickPlayMultiplayer}", game->getQuickPlayMultiPlayer());
    arguments.replaceInStrings("${quickPlayRealms}", QString::number(game->getQuickPlayRealms()));
    arguments.replaceInStrings("${natives_directory}", game->getNativesDirectory());
    arguments.replaceInStrings("${classpath}", getClassPath(game));
    return arguments;
}

// 获取运行目录
const QString QuickMCL::game::Launcher::getWorkingDir(const QString& name){
    return Game::getGameListPtr()->value(name)->getGameDirectory();
}

// 从游戏配置文件读取 jvm 参数
const QStringList QuickMCL::game::Launcher::getJvmParameters(const Game* const game){
    const QuickMCL::config::Config* const config = QuickMCL::config::Config::getGlobalConfigPtr();
    QStringList parameters;
    // 前三个先投机取巧，直接判断环境添加
    if (config->getSystem() == QuickMCL::config::system::macos){
        parameters.append("-XstartOnFirstThread");
    }
    if (config->getSystem() == QuickMCL::config::system::windows){
        parameters.append("-XX:HeapDumpPath=MojangTricksIntelDriversForPerformance_javaw.exe_minecraft.exe.heapdump");
    }
    if (config->getArch() == QuickMCL::config::arch::x86){
        parameters.append("-Xss1M");
    }

    const QJsonObject gameJsonObject = QuickMCL::utils::JsonPraser::readObjectFromFile(game->getConfigJsonFile());

    // 1.13+
    if (gameJsonObject.contains("arguments")){
        const QJsonArray jvmArray = gameJsonObject.value("arguments").toObject().value("jvm").toArray();
        QJsonArray::ConstIterator jvmIterator = jvmArray.constBegin();
        QJsonArray::ConstIterator jvmEnd = jvmArray.constEnd();
        // 跳过前面的 object 部分
        for (; jvmIterator->isObject(); jvmIterator++){

        }
        // 处理后面的 string 部分
        for (; jvmIterator != jvmEnd; jvmIterator++){
            parameters.append(jvmIterator->toString());
        }

        // 后处理，删掉 jvmBaseParameters 里的两条
        int index;
        index = parameters.indexOf("-Dminecraft.launcher.brand=${launcher_name}");
        if (index != -1){
            parameters.remove(index);
        }
        index = parameters.indexOf("-Dminecraft.launcher.version=${launcher_version}");
        if (index != -1){
            parameters.remove(index);
        }

    // 1.12-
    } else {
        parameters.append("-Djava.library.path=${natives_directory}");
        parameters.append("-cp");
        parameters.append("${classpath}");
    }

    return parameters;
}

// 从 json 文件读取 -cp 库
const QString QuickMCL::game::Launcher::getClassPath(const Game* const game){
    const QuickMCL::config::Config* const config = QuickMCL::config::Config::getGlobalConfigPtr();
    QStringList javaClasses;
    // 先定义系统名称方便比较
    QString systemName = config->getSystemNameInMinecraft();
    const QJsonObject gameJsonObject = QuickMCL::utils::JsonPraser::readObjectFromFile(game->getConfigJsonFile());
    const QJsonArray libraryArray =  gameJsonObject.value("libraries").toArray();
    QJsonArray::ConstIterator libraryIterator = libraryArray.constBegin();
    QJsonArray::ConstIterator end = libraryArray.constEnd();
    for (; libraryIterator < end; libraryIterator++){
        if (libraryIterator->toObject().contains("rules")){
            // allow 和 disallow 都是 macos，暂时投机取巧
            QJsonArray::ConstIterator ruleIterator = libraryIterator->toObject().value("rules").toArray().constBegin();
            // 有 os，就是 allow macos，不是 macos 则跳过
            if (ruleIterator->toObject().contains("os")){
                if (config->getSystem() != QuickMCL::config::system::macos){
                    continue;
                }
                // 没有 os，就是 disallow macos，是 macos 则跳过
            } else {
                if (config->getSystem() == QuickMCL::config::system::macos){
                    continue;
                }
            }
        }
        // 是 natives 库
        if (libraryIterator->toObject().contains("natives")){
            // 需要解压，跳过，应该在下载阶段处理
            if (libraryIterator->toObject().contains("extract")){
                continue;
                // 不需要解压
            } else {
                // 如果有对应的 natives 则添加
                if (libraryIterator->toObject().value("natives").toObject().contains(systemName)){
                    javaClasses.append(
                        QDir::toNativeSeparators(game->getLibrariesDirectory() +
                                                  libraryIterator->toObject().value("downloads").toObject().value("classifiers").toObject()
                                                      .value(QString("natives-") + systemName).toObject()
                                                      .value("path").toString()
                        )
                    );
                }
            }
            // 不是 natives 库，直接添加
        } else {
            javaClasses.append(QDir::toNativeSeparators(
                                    game->getLibrariesDirectory() + libraryIterator->toObject().value("downloads").toObject()
                                    .value("artifact").toObject().value("path").toString()
                               )
            );
        }
    }
    javaClasses.append(game->getGameJar());
    return javaClasses.join(";");
}

// 从 json 文件中获取 MainClass
const QString QuickMCL::game::Launcher::getMainClass(const Game* const game){
    const QJsonObject gameJsonObject = QuickMCL::utils::JsonPraser::readObjectFromFile(game->getConfigJsonFile());
    return gameJsonObject.value("mainClass").toString();
}

// 从 json 文件中获取游戏参数
const QStringList QuickMCL::game::Launcher::getGameParameters(const Game* const game){
    const QJsonObject gameJsonObject = QuickMCL::utils::JsonPraser::readObjectFromFile(game->getConfigJsonFile());
    QStringList gameParameters;

    // 1.13+
    if (gameJsonObject.contains("arguments")){
        const QJsonArray gameArray = gameJsonObject.value("arguments").toObject().value("game").toArray();
        QJsonArray::ConstIterator gameIterator = gameArray.constBegin();
        QJsonArray::ConstIterator gameEnd = gameArray.constEnd();
        // 前半部分的纯字符串直接添加
        for (; gameIterator->isString(); gameIterator++){
            gameParameters += gameIterator->toString();
        }
        // 后半部分的 object，暂时按只有 allow 一种情况处理
        for (; gameIterator != gameEnd; gameIterator++){
            // 获取 features object
            const QJsonObject feature = gameIterator->toObject().value("rules").toArray().first().toObject().value("features").toObject();
            // 获取 key
            QString key = feature.keys().constFirst();
            if (game->getFeatures().contains(key)){
                // 如果是一个字符串，直接添加
                if (gameIterator->toObject().value("value").isString()){
                    gameParameters.append(gameIterator->toObject().value("value").toString());
                    // 如果不是则是字符串数组
                } else {
                    const QJsonArray valueArray = gameIterator->toObject().value("value").toArray();
                    QJsonArray::ConstIterator valueIterator = valueArray.constBegin();
                    QJsonArray::ConstIterator end = valueArray.constEnd();
                    for (; valueIterator != end; valueIterator++){
                        gameParameters.append(valueIterator->toString());
                    }
                }
            }
        }

    // 1.12-
    } else {
        // 直接读取字符串
        QString minecraftArguments = gameJsonObject.value("minecraftArguments").toString();
        gameParameters.append(minecraftArguments.split(" "));
        // 之前没有自定义大小参数的也直接拼在上面
        if (game->getFeatures().contains("has_custom_resolution")){
            gameParameters.append({"--width", "${resolution_width}", "--height", "${resolution_height}"});
        }

    }

    return gameParameters;
}

// 启动游戏
const qint64 QuickMCL::game::Launcher::launch(const QString& name, const QString& playerName, const int type){
    QProcess gameProcess;
    gameProcess.setProgram(getCommand(name));
    gameProcess.setArguments(getArguments(name, playerName));
    gameProcess.setWorkingDirectory(getWorkingDir(name));
    qDebug() << "[QuickMCL::game::Launcher] 启动命令：" << getCommand(name);
    qDebug() << "[QuickMCL::game::Launcher] 启动参数：" << getArguments(name, playerName);
    qDebug() << "[QuickMCL::game::Launcher] 启动目录：" << getWorkingDir(name);
    qint64* pid = nullptr;
    gameProcess.startDetached(pid);
    if (pid != nullptr){
        return *pid;
    } else {
        return -1;
    }
}
