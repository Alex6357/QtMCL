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
 * 这是内容区文件。使用 Loader 动态加载内容页面。
 */

import QtQuick
import "NavBarButtonGroups"

// 内容区
Rectangle {
    width: 540
    height: 405
    color: "#e9faf0"

    // 保存当前功能
    property int funcBarFunction: FuncBar.FunctionTypes.Launch
    property int buttonGroupFunction: 0

    // 统一用 changed 信号通知
    signal changed()

    // 用于动态加载页面
    Loader {
        id: contentAreaLoader
        x: parent.x
        y: parent.y
        width: parent.width
        height: parent.height
        anchors.fill: parent
        anchors.top: parent.top
        anchors.left: parent.left
        // 默认加载“启动游戏”的“启动”功能
        source: "ContentAreaPages/LaunchPages/PageLaunch.qml"
    }

    onChanged: {
        // 寻找主功能
        switch(funcBarFunction){
            // 主功能为“启动游戏”
            case FuncBar.FunctionTypes.Launch:
                // 寻找子功能
                switch(buttonGroupFunction){
                    // 子功能为“启动”
                    case ButtonGroupLaunch.LaunchFunctions.Launch:
                        contentAreaLoader.source = "ContentAreaPages/LaunchPages/PageLaunch.qml"
                        break
                    // fallback
                    default:
                        contentAreaLoader.source = ""
                }
                break

            // 主功能为“全局设置”
            case FuncBar.FunctionTypes.Settings:
                // 寻找子功能
                switch(buttonGroupFunction){
                    // 子功能为“游戏设置”
                    case ButtonGroupSettings.SettingsFunctions.GameSettings:
                        contentAreaLoader.source = "ContentAreaPages/SettingsPages/PageGameSettings.qml"
                        break
                    // fallback
                    default:
                        contentAreaLoader.source = ""
                }
                break

            // fallback
            default:
                contentAreaLoader.source = ""
                break
        }
    }

    // 连接所有信号
    Connections {
        target: funcBar
        function onChanged(number: int){
            funcBarFunction = number
        }
    }
    // 在收到按钮组的信号的时候再触发页面切换的信号
    Connections {
        target: navBar.buttonGroupLaunch
        function onChanged(number: int){
            buttonGroupFunction = number
            changed()
        }
    }
    Connections {
        target: navBar.buttonGroupDownload
        function onChanged(number: int){
            buttonGroupFunction = number
            changed()
        }
    }
    Connections {
        target: navBar.buttonGroupSettings
        function onChanged(number: int){
            buttonGroupFunction = number
            changed()
        }
    }
}
