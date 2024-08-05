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
 * 这是主入口文件，目前只负责加载 Main.qml 模块
*/

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QThread>
#include <QtConcurrent>
#include <QThreadPool>
// #include <QDir>
// #include <QStringList>
// #include <QtDebug>
// #include <QLoggingCategory>
#include "config.h"
#include "game/game.h"
#include "utils/qml_interface.h"

int main(int argc, char *argv[])
{
    // 解析配置文件
    QuickMCL::config::Config* const globalConfig = QuickMCL::config::Config::getGlobalConfigPtr();
    QuickMCL::utils::QmlInterface interface;

    QThreadPool::globalInstance()->start(QuickMCL::utils::Java::scanJava);  // **这位置好像不对，需要改地方
    // QFuture<void> scanGameFuture = QtConcurrent::run(QuickMCL::game::Game::scanGame, "");
    QuickMCL::game::Game::readGameConfig();
    QuickMCL::game::Game::scanGame();

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // 注册相关类
    engine.rootContext()->setContextProperty("Interface", &interface);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("QuickMCL", "Main");

    return app.exec();
}
