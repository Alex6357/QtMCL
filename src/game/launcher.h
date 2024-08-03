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

#ifndef LAUNCHER_H
#define LAUNCHER_H

#include <QObject>
// #include <QProcess>
#include <QtTypes>
#include <QString>
#include <QStringList>
#include "game.h"

namespace QuickMCL::game {
class Launcher
{
public:
    // 获取启动命令（Java 路径）
    static const QString getCommand(const QString& name);
    // 自动获取适合的 java
    static const QString autoGetJava(const QString& name);
    // 获取启动参数
    static const QStringList getArguments(const QString& name,
                                   const QString& playerName,
                                   const QString& uid = "00000FFFFFFFFFFFFFFFFFFFFFF2F4BA",
                                   const QString& token = "00000FFFFFFFFFFFFFFFFFFFFFF2F4BA");
    // 获取运行目录
    static const QString getWorkingDir(const QString& name);
    // 从游戏配置文件读取 jvm 参数
    static const QStringList getJvmParameters(const Game* const game);
    // 从 json 文件读取 -cp 库
    static const QString getClassPath(const Game* const game);
    // 从 json 文件中获取 MainClass
    static const QString getMainClass(const Game* const game);
    // 从 json 文件中获取游戏参数
    static const QStringList getGameParameters(const Game* const game);
    // 启动游戏
    static const qint64 launch(const QString& name, const QString& playerName, const int type = 0);
};
}

#endif // LAUNCHER_H
