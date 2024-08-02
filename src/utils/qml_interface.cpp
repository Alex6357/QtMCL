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

#include <QStringList>
#include <QDebug>
#include "qml_interface.h"
#include "../game/launcher.h"
#include "../game/game.h"
#include "../config.h"

QuickMCL::utils::QmlInterface::QmlInterface(QObject *parent)
    : QObject{parent}
{}

const qint64 QuickMCL::utils::QmlInterface::launchGame(const QString& name, const QString& playerName, const int type){
    return QuickMCL::game::Launcher::launch(name, playerName, type);
}

const QStringList QuickMCL::utils::QmlInterface::getUserList(){
    return QuickMCL::config::Config::getUserListCopy();
}

const QStringList QuickMCL::utils::QmlInterface::getGameList(){
    return QStringList::fromList(QuickMCL::game::Game::getGameListPtr()->keys());
}
